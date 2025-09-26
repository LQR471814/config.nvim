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
	local opts = { buffer = true, silent = true }
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

	self.cached_value = res
	return res
end

return Mathzone
