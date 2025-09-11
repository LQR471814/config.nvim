local cached_value = false
local cached = false


local function in_mathzone()
	-- this caching mechanism is here so that vimtex#syntax#in_mathzone doesn't
	-- need to be called for every snippet that needs to be enabled on a
	-- mathzone.
	if cached then
		return cached_value
	end
	cached = true
	vim.defer_fn(function()
		cached = false
	end, 10)

	if vim.bo.filetype == "tex" then
		cached_value = true
		return true
	end

	local res = false
	local captures = vim.treesitter.get_captures_at_cursor(0)
	local i = 1
	while i <= #captures do
		if captures[i] == "markup.math" then
			res = true
			break
		end
		i = i + 1
	end

	-- disable bullets.nvim in mathzone
	local opts = { buffer = true }
	if res and vim.bo.filetype == "markdown" then
		local ls = require("luasnip")
		vim.keymap.set("i", "<Tab>", function()
			ls.jump(1)
		end, opts)
		vim.keymap.set("i", "<S-Tab>", function()
			ls.jump(-1)
		end, opts)
	else
		vim.keymap.set("i", "<Tab>", "<C-o><Plug>(bullets-demote)", opts)
		vim.keymap.set("i", "<S-Tab>", "<C-o><Plug>(bullets-promote)", opts)
	end

	cached_value = res
	return res
end

local function latex_snippet(context, nodes, opts)
	local ls = require("luasnip")
	context.condition = in_mathzone
	context.show_condition = in_mathzone
	return ls.snippet(context, nodes, opts)
end

local function enable_soft_wrap()
	vim.opt_local.wrap = true
	vim.opt_local.linebreak = true
end

local function disable_soft_wrap()
	vim.opt_local.wrap = false
	vim.opt_local.linebreak = false
end

local function enable_hard_wrap()
	vim.opt_local.textwidth = 66
end

local function disable_hard_wrap()
	vim.opt_local.textwidth = 0
end

--- @alias Mode "off" | "hard" | "soft"

local Wrap = {}

--- @return Mode
function Wrap:status()
	if vim.opt_local.wrap:get() == true and vim.opt_local.linebreak:get() == true then
		return "soft"
	end
	if vim.opt_local.textwidth:get() > 0 then
		return "hard"
	end
	return "off"
end

--- @param status Mode
--- @param silent boolean?
function Wrap:set(status, silent)
	if status == "off" then
		disable_hard_wrap()
		disable_soft_wrap()
		if not silent then
			vim.notify("All wrappings off.")
		end
	elseif status == "hard" then
		disable_soft_wrap()
		enable_hard_wrap()
		if not silent then
			vim.notify("Hard wrapping on.")
		end
	elseif status == "soft" then
		disable_hard_wrap()
		enable_soft_wrap()
		if not silent then
			vim.notify("Soft wrapping on.")
		end
	end
end

--- @param status "hard" | "soft"
--- @param silent boolean?
function Wrap:toggle(status, silent)
	local current = self:status()
	if status == "hard" then
		if current == "hard" then
			disable_hard_wrap()
			if not silent then
				vim.notify("Hard wrapping off.")
			end
		else
			disable_soft_wrap()
			enable_hard_wrap()
			if not silent then
				vim.notify("Hard wrapping on.")
			end
		end
	elseif status == "soft" then
		if current == "soft" then
			disable_soft_wrap()
			if not silent then
				vim.notify("Soft wrapping off.")
			end
		else
			disable_hard_wrap()
			enable_soft_wrap()
			if not silent then
				vim.notify("Soft wrapping on.")
			end
		end
	end
end

return {
	in_mathzone = in_mathzone,
	latex_snippet = latex_snippet,
	wrap = Wrap,
}
