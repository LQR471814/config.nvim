local keymap = require("lqr471814.lib.keymap")
local lib = require("lqr471814.lib")
local clipboard = require("lqr471814.lib.clipboard")

local state = {
	enabled = {}
}

--- @param buf integer
local function setup(buf)
	if state.enabled[buf] then
		return
	end
	state.enabled[buf] = true

	-- set hard wrap
	lib.wrap.set("hard", true)

	-- spell check
	vim.opt_local.spell     = true
	vim.opt_local.spelllang = "en"
	keymap.buffer_map("n", "z,", "<ESC>m'[s1z=<CR>`'", "Correct previous spelling error.")
	keymap.buffer_map("n", "z.", "<ESC>m']s1z=<CR>`'", "Correct next spelling error.")

	-- tab size
	vim.opt.tabstop = 4
	vim.opt.shiftwidth = 4

	-- prevent line break inside brackets
	vim.opt_local.breakat = " \\\t!@*-+;:,./?"

	-- bold
	keymap.overwrite_buffer_map({ "x", "v" }, "<C-b>", "2:<C-u>lua MiniSurround.add('visual')<CR>*",
		"Make visual selection bold.")
	keymap.overwrite_buffer_map("i", "<C-b>", "****<Left><Left>", "Create bold text.")

	-- italics (don't work because <Tab> and <C-i> typically mean the same thing for terminals)
	-- keymap.overwrite_buffer_map({ "x", "v" }, "<C-i>", ":<C-u>lua MiniSurround.add('visual')<CR>*",
	-- 	"Make visual selection italic.")
	-- keymap.overwrite_buffer_map("i", "<C-i>", "**<Left>", "Create italic text.")

	-- highlight
	keymap.overwrite_buffer_map({ "x", "v" }, "<C-h>", ":<C-u>lua MiniSurround.add('visual')<CR>=",
		"Highlight visual selection.")
	keymap.overwrite_buffer_map("i", "<C-h>", "====<Left><Left>", "Create highlighted text.")

	-- insert link
	keymap.buffer_map("i", "<C-k>", function()
		clipboard.paste_link_markdown()
	end, "Insert link based on clipboard contents.")

	keymap.overwrite_buffer_map(
		{ "n" },
		"gp",
		clipboard.paste_image_markdown,
		"Paste from clipboard."
	)
end

vim.api.nvim_create_autocmd("BufDelete", {
	callback = function(args)
		local buf = args.buf
		state.enabled[buf] = nil
	end
})

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*.md", "*.markdown" },
	callback = function(args)
		setup(args.buf)
	end,
})
