local util = require("lqr471814.lib.util")
local keymap = require("lqr471814.lib.keymap")

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
		keymap.overwrite_buffer_map("i", "<Tab>", "<C-o><Plug>(bullets-demote)")
		keymap.overwrite_buffer_map("i", "<S-Tab>", "<C-o><Plug>(bullets-promote)")
	end

	return res
end

local function outside_mathzone_tex()
	return vim.bo.filetype == "tex" and (not in_mathzone())
end

local function all_zones_tex()
	return vim.bo.filetype == "tex"
end

return {
	-- this caching mechanism is here so that mathzone checking does not need
	-- to performed for every snippet that needs to be enabled on a mathzone
	-- (since this function will be called for every snippet that is only
	-- enabled in a mathzone)
	in_mathzone = util.cache(20, in_mathzone),
	outside_mathzone_tex = util.cache(20, outside_mathzone_tex),
	all_zones_tex = util.cache(20, all_zones_tex),
}
