local keymap = require("lqr471814.lib.keymap")

local Mathzone = {
	cached_value = false,
	cached = false
}

function Mathzone:in_mathzone()
	-- this caching mechanism is here so that vimtex#syntax#in_mathzone doesn't
	-- need to be called for every snippet that needs to be enabled on a
	-- mathzone.
	if self.cached then
		return self.cached_value
	end
	self.cached = true
	vim.defer_fn(function()
		self.cached = false
	end, 10)

	if vim.bo.filetype == "tex" then
		self.cached_value = true
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
	if res and vim.bo.filetype == "markdown" then
		local ls = require("luasnip")
		keymap:overwrite_buffer_map("i", "<Tab>", function()
			ls.jump(1)
		end)
		keymap:overwrite_buffer_map("i", "<S-Tab>", function()
			ls.jump(-1)
		end)
	else
		keymap:overwrite_buffer_map("i", "<Tab>", "<C-o><Plug>(bullets-demote)")
		keymap:overwrite_buffer_map("i", "<S-Tab>", "<C-o><Plug>(bullets-promote)")
	end

	self.cached_value = res
	return res
end

return Mathzone
