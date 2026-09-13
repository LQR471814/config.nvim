local keymap = require("lqr471814.lib.keymap")
local lib = require("lqr471814.lib")

local state = {
	enabled = {}
}

---@param mime string
local function mime_to_image_ext(mime)
	local formats = {
		{ mime = "image/png",  ext = "png" },
		{ mime = "image/jpeg", ext = "jpg" },
		{ mime = "image/webp", ext = "webp" },
		{ mime = "image/gif",  ext = "gif" },
	}
	local format
	for _, candidate in ipairs(formats) do
		print(string.format("'%s' = '%s'", candidate.mime, mime))
		if candidate.mime == mime then
			format = candidate
			break
		end
	end
	return format
end

local function paste_clipboard_image()
	if vim.bo.filetype ~= "markdown" then
		error({ code = 0, msg = "Not a Markdown buffer" })
	end

	if vim.fn.executable("wl-paste") ~= 1 then
		error({ code = 1, msg = "wl-paste not found" })
	end

	local md_path = vim.api.nvim_buf_get_name(0)
	if md_path == "" then
		error({ code = 2, "Save Markdown file first" })
	end

	local types = vim.fn.system({ "wl-paste", "--list-types" })

	local format
	for type in string.gmatch(types, "[^\n]+") do
		print(type)
		format = mime_to_image_ext(type)
	end
	if not format then
		error({ code = 3, "Clipboard does not contain an image" })
	end

	local md_dir = vim.fn.fnamemodify(md_path, ":p:h")
	local assets_dir = md_dir .. "/assets"

	vim.fn.mkdir(assets_dir, "p")

	-- prevent collisions between names
	local stem = os.date("image-%Y%m%d-%H%M%S")
	local filename = stem .. "." .. format.ext
	local target = assets_dir .. "/" .. filename

	local n = 1
	while vim.fn.filereadable(target) == 1 do
		filename = string.format("%s-%d.%s", stem, n, format.ext)
		target = assets_dir .. "/" .. filename
		n = n + 1
	end

	local cmd = string.format(
		"wl-paste --type %s | save -f %s",
		vim.fn.shellescape(format.mime),
		vim.fn.shellescape(target)
	)

	vim.fn.system(cmd)

	if vim.v.shell_error ~= 0 or vim.fn.getfsize(target) <= 0 then
		vim.fn.delete(target)
		error({ code = 4, "Failed to read clipboard image" })
	end

	local row = vim.api.nvim_win_get_cursor(0)[1]
	local link = string.format("![](assets/%s)", filename)

	vim.api.nvim_buf_set_lines(0, row, row, false, { link })
	vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
end

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
		local clipboard = vim.fn.getreg("+")
		clipboard = clipboard:gsub("\n", "")
		local pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_put({ "[](" .. clipboard .. ")" }, "c", true, false)
		vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
	end, "Insert link based on clipboard contents.")

	keymap.overwrite_buffer_map({ "n" }, "gp", function()
		local ok, result = pcall(paste_clipboard_image)
		if not ok then
			if result.code == 3 then
				print("normal paste")
				vim.cmd('normal! "+p')
			else
				vim.notify(result)
			end
		end
	end, "Paste from clipboard.")
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
