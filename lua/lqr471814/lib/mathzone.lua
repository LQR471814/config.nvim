local util = require("lqr471814.lib.util")
local keymap = require("lqr471814.lib.keymap")
local markdown = require("lqr471814.plugins.markdown")

--- @param envnames table
local function in_latex_env(envnames)
	local _, res = pcall(vim.fn["vimtex#delim#get_surrounding"], "env_tex")
	for _, match in ipairs(res) do
		local env = match.name
		for _, target in ipairs(envnames) do
			if target == env then
				return true
			end
		end
	end
	return false
end

local function in_mathzone()
	if vim.bo.filetype == "tex" then
		return vim.fn["vimtex#syntax#in_mathzone"]() == 1
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
	if res and vim.bo.filetype == "markdown" then
		local ls = require("luasnip")
		keymap.overwrite_buffer_map("i", "<Tab>", function()
			ls.jump(1)
		end)
		keymap.overwrite_buffer_map("i", "<S-Tab>", function()
			ls.jump(-1)
		end)
	else
		markdown.bullets_mapping()
	end

	return res
end

local function in_tex_and_outside_mathzone()
	return vim.bo.filetype == "tex" and (not in_mathzone())
end

local function in_tex()
	return vim.bo.filetype == "tex"
end

return {
	in_latex_env = function(envs)
		return util.cache(20, function()
			return in_latex_env(envs)
		end)
	end,
	-- this caching mechanism is here so that mathzone checking does not need
	-- to performed for every snippet that needs to be enabled on a mathzone
	-- (since this function will be called for every snippet that is only
	-- enabled in a mathzone)
	in_mathzone = util.cache(20, in_mathzone),
	outside_mathzone = util.cache(20, function ()
		return not in_mathzone()
	end),
	in_tex_and_outside_mathzone = util.cache(20, in_tex_and_outside_mathzone),
	in_tex = util.cache(20, in_tex),
}
