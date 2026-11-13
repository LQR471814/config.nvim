local keymap = require("lqr471814.lib.keymap")
local clipboard = require("lqr471814.lib.clipboard")

--- @param buf integer
local function setup(buf)
	keymap.overwrite_buffer_map(
		{ "n" },
		"gp",
		clipboard.paste_image_tex,
		"Paste from clipboard."
	)
end

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*.tex" },
	callback = function(args)
		setup(args.buf)
	end,
})
