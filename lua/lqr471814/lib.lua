local Bullets = {
	enabled = false
}

function Bullets:enable()
	if self.enabled then
		return
	end
	self.enabled = true

	local opts = { buffer = true }
	vim.keymap.set("i", "<cr>", "<Plug>(bullets-newline-cr)", opts)
	vim.keymap.set("n", "o", "<Plug>(bullets-newline-o)", opts)
	vim.keymap.set("n", "<leader>d", "<Plug>(bullets-toggle-checkbox)", opts)
	vim.keymap.set("i", "<Tab>", "<C-o><Plug>(bullets-demote)", opts)
	vim.keymap.set("i", "<S-Tab>", "<C-o><Plug>(bullets-promote)", opts)
end

function Bullets:disable()
	if not self.enabled then
		return
	end
	self.enabled = false

	local opts = { buffer = true }
	vim.keymap.del("i", "<cr>", opts)
	vim.keymap.del("n", "o", opts)
	vim.keymap.del("n", "<leader>d", opts)
	vim.keymap.del("i", "<Tab>", opts)
	vim.keymap.del("i", "<S-Tab>", opts)

	local ls = require("luasnip")
	vim.keymap.set("i", "<Tab>", function()
		ls.jump(1)
	end, opts)
	vim.keymap.set("i", "<S-Tab>", function()
		ls.jump(-1)
	end, opts)
end

local cached_value = false
local cached = false

local function in_mathzone()
	if vim.bo.filetype == "tex" then
		return true
	end
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

	local res = vim.fn['vimtex#syntax#in_mathzone']() == 1

	-- disable bullets.nvim in mathzone
	if res and vim.bo.filetype == "markdown" then
		Bullets:disable()
	else
		Bullets:enable()
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
function Wrap:set(status)
	if status == "off" then
		disable_hard_wrap()
		disable_soft_wrap()
		vim.notify("All wrappings off.")
	elseif status == "hard" then
		disable_soft_wrap()
		enable_hard_wrap()
		vim.notify("Hard wrapping on.")
	elseif status == "soft" then
		disable_hard_wrap()
		enable_soft_wrap()
		vim.notify("Soft wrapping on.")
	end
end

--- @param status "hard" | "soft"
function Wrap:toggle(status)
	local current = self:status()
	if status == "hard" then
		if current == "hard" then
			disable_hard_wrap()
			vim.notify("Hard wrapping off.")
		else
			disable_soft_wrap()
			enable_hard_wrap()
			vim.notify("Hard wrapping on.")
		end
	elseif status == "soft" then
		if current == "soft" then
			disable_soft_wrap()
			vim.notify("Soft wrapping off.")
		else
			disable_hard_wrap()
			enable_soft_wrap()
			vim.notify("Soft wrapping on.")
		end
	end
end

return {
	in_mathzone = in_mathzone,
	latex_snippet = latex_snippet,
	wrap = Wrap,
	bullets = Bullets,
}
