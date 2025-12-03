local keymap = require("lqr471814.lib.keymap")
local lib = require("lqr471814.lib")

local state = {
	enabled = {}
}

local function enable_markdown_tablemode()
	local enabled = false

	--- @type "off" | "hard" | "soft"
	local wrapStatus

	keymap.buffer_map("n", "<leader>tm", function()
		enabled = not enabled
		if enabled then
			vim.cmd("TableModeEnable")
			vim.cmd("RenderMarkdown disable")
			wrapStatus = lib.wrap.status()
			lib.wrap.set("off")
		else
			vim.cmd("TableModeDisable")
			vim.cmd("RenderMarkdown enable")
			lib.wrap.set(wrapStatus)
		end
	end)
end

--- @param buf integer
local function monkeypatch_mdmath(buf)
	local timer = vim.uv.new_timer()
	if not timer then
		vim.notify("failed to create timer!", vim.log.levels.ERROR)
		return
	end

	local active = false

	local redraw = function()
		vim.cmd("redraw")
		if vim.opt.filetype:get() == "markdown" then
			vim.opt_local.spell = not lib.in_mathzone()
		end
	end

	local handler = function()
		vim.uv.timer_stop(timer)
		active = false
		vim.schedule(redraw)
	end

	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		buffer = buf,
		callback = function()
			if active then
				vim.uv.timer_stop(timer)
			end

			active = true
			local success = vim.uv.timer_start(timer, 200, 0, handler)
			if not success then
				active = false
			end
		end
	})
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
	keymap.buffer_map("v", "<C-b>", "2<Plug>(nvim-surround-visual)*", "Make visual selection bold.")
	keymap.buffer_map("i", "<C-b>", "****<Left><Left>", "Create bold text.")

	-- highlight
	keymap.buffer_map("v", "<C-M-h>", "2<Plug>(nvim-surround-visual)=", "Highlight visual selection.")
	keymap.buffer_map("i", "<C-M-h>", "====<Left><Left>", "Create highlighted text.")

	-- bullets
	keymap.buffer_map("n", "<leader>rl", "<Plug>(bullets-renumber)", "Renumber bullets.")

	keymap.buffer_map("i", "<cr>", "<Plug>(bullets-newline-cr)")
	keymap.buffer_map("n", "o", function()
		vim.cmd("InsertNewBulletO")
	end)
	keymap.buffer_map("n", "2o", function()
		vim.cmd("InsertNewBulletO")
		vim.cmd("InsertNewBulletO")
	end)
	keymap.buffer_map("n", "<leader>d", "<Plug>(bullets-toggle-checkbox)", "Toggle checkbox.")
	keymap.buffer_map("i", "<Tab>", "<C-o><Plug>(bullets-demote)", "De-indent bullet.")
	keymap.buffer_map("i", "<S-Tab>", "<C-o><Plug>(bullets-promote)", "Indent bullet.")

	-- insert link
	keymap.buffer_map("i", "<C-M-k>", function()
		local clipboard = vim.fn.getreg("+")
		clipboard = clipboard:gsub("\n", "")
		local pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_put({ "[](" .. clipboard .. ")" }, "c", true, false)
		vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
	end, "Insert link based on clipboard contents.")

	-- table mode
	enable_markdown_tablemode()

	-- monkeypatch mdmath issues
	monkeypatch_mdmath(buf)
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
