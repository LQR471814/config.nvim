---@param filetype string
local function assert_filetype(filetype)
	if vim.bo.filetype ~= filetype then
		error({ code = 0, msg = "Not a " .. filetype .. " buffer" })
	end
end

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
		if candidate.mime == mime then
			format = candidate
			break
		end
	end
	return format
end

local function get_copied_image_format()
	if vim.fn.executable("wl-paste") ~= 1 then
		error({ code = 1, msg = "wl-paste not found" })
	end

	local types = vim.fn.system({ "wl-paste", "--list-types" })
	local format
	for type in string.gmatch(types, "[^\n]+") do
		format = mime_to_image_ext(type)
	end
	if not format then
		error({ code = 3, msg = "Clipboard does not contain an image" })
	end

	return format
end

---@return string
local function get_pwd()
	local filepath = vim.api.nvim_buf_get_name(0)
	if filepath == "" then
		error({ code = 2, msg = "Save file first" })
	end
	return vim.fn.fnamemodify(filepath, ":p:h")
end

---@param pwd string
local function get_asset_dir(pwd)
	local assets_dir = pwd .. "/assets"
	vim.fn.mkdir(assets_dir, "p")

	return assets_dir
end

---@param dir string
---@param stem string
---@param ext string
local function get_noncolliding_path(dir, stem, ext)
	local target = string.format("%s/%s.%s", dir, stem, ext)
	local n = 1
	while vim.fn.filereadable(target) == 1 do
		local name = string.format("%s-%d.%s", stem, n, ext)
		target = string.format("%s/%s", dir, name)
		n = n + 1
	end
	return target
end

---@return string
local function new_image_asset_name()
	return "" .. os.date("image-%Y%m%d-%H%M%S")
end

---@param pwd string
---@return string
local function save_clipboard_image_asset(pwd)
	local format = get_copied_image_format()
	local asset_dir = get_asset_dir(pwd)

	-- prevent collisions between names
	local stem = new_image_asset_name()
	local target = get_noncolliding_path(asset_dir, stem, format.ext)

	local cmd = string.format(
		"wl-paste --type %s | save -f %s",
		vim.fn.shellescape(format.mime),
		vim.fn.shellescape(target)
	)

	vim.fn.system(cmd)

	if vim.v.shell_error ~= 0 or vim.fn.getfsize(target) <= 0 then
		vim.fn.delete(target)
		error({ code = 5, msg = "Failed to read clipboard image" })
	end

	local relative = vim.fs.relpath(pwd, target)
	if not relative then
		error({ code = 6, msg = "Resulting target is not an descendent of pwd, this should never happen!." })
	end
	return relative
end

---@param lines table<string>
local function paste_text(lines, mode)
	vim.api.nvim_put(lines, mode, true, true)
end

local function paste_image_markdown()
	assert_filetype("markdown")

	local pwd = get_pwd()
	local asset_path = save_clipboard_image_asset(pwd)

	local link = string.format("![](%s)", asset_path)
	paste_text({ link }, "c")

	local pos = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_win_set_cursor(0, {
		pos[1],
		pos[2] - #link + 3,
	})

	vim.cmd("startinsert")
end

local function paste_image_tex()
	assert_filetype("tex")

	local pwd = get_pwd()
	local asset_path = save_clipboard_image_asset(pwd)

	local image = {
		"\\begin{figure}[htbp]",
		"\t\\centering",
		string.format("\t\\includegraphics[width=\\textwidth]{%s}", asset_path),
		"\t\\caption{}",
		"\t\\label{}",
		"\\end{figure}"
	}
	paste_text(image, "l")
end

local function paste_link_markdown()
	assert_filetype("markdown")

	local clipboard = vim.fn.getreg("+")
	clipboard = clipboard:gsub("\n", "")
	local pos = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_put({ "[](" .. clipboard .. ")" }, "c", true, false)
	vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
end

local function try_paste_image(fn)
	return function()
		local ok, result = pcall(fn)
		if not ok then
			if result.code == 3 then
				vim.cmd('normal! "+p')
			else
				vim.notify(result.msg)
			end
		end
	end
end

return {
	paste_link_markdown = paste_link_markdown,
	paste_image_markdown = try_paste_image(paste_image_markdown),
	paste_image_tex = try_paste_image(paste_image_tex),
}
