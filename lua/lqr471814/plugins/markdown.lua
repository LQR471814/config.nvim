local keymap = require("lqr471814.lib.keymap")
local wrap = require("lqr471814.lib.wrap")

---@param line string
local function line_startswith_bullet(line)
	return string.match(line, "^%s*-") ~= nil
		or string.match(line, "^%s*%*") ~= nil
		or string.match(line, "^%s*%+") ~= nil
		or string.match(line, "^%s*%d+%.") ~= nil
		or string.match(line, "^%s*%d+%)") ~= nil
end

local function bullets_mapping()
	keymap.overwrite_buffer_map("n", "<leader>rl", "<Plug>(bullets-renumber)", "Renumber bullets.")

	keymap.opts.expr = true
	keymap.overwrite_buffer_map("i", "<cr>", function()
		-- we set blink as a dependency to bullets so this works
		local blink = require("blink.cmp")
		local accepted = blink.accept()
		if accepted then
			return ""
		end
		return "<Plug>(bullets-newline-cr)"
	end)
	keymap.opts.expr = false

	keymap.overwrite_buffer_map("n", "o", function()
		vim.cmd("InsertNewBulletO")
	end)
	keymap.overwrite_buffer_map("n", "2o", function()
		vim.cmd("InsertNewBulletO")
		vim.cmd("InsertNewBulletO")
	end)
	keymap.overwrite_buffer_map("n", "<leader>d", "<Plug>(bullets-toggle-checkbox)", "Toggle checkbox.")

	-- we let the action fn return string actions
	keymap.opts.expr = true
	keymap.overwrite_buffer_map("i", "<Tab>", function()
		local line = vim.api.nvim_get_current_line()
		if line_startswith_bullet(line) then
			return "<C-o><Plug>(bullets-demote)"
		end
		return "<Plug>(Tabout)"
	end, "De-indent bullet.")
	keymap.overwrite_buffer_map("i", "<S-Tab>", function()
		local line = vim.api.nvim_get_current_line()
		if line_startswith_bullet(line) ~= nil then
			return "<C-o><Plug>(bullets-promote)"
		end
		return "<Plug>(TaboutBack)"
	end, "Indent bullet.")
	keymap.opts.expr = false
end

local plugins = {
	-- this plugin already does lazy-loading by default, lazy-loading tends to
	-- interfere with its functioning
	{
		"dhruvasagar/vim-table-mode",
		config = function()
			local enabled = false

			--- @type "off" | "hard" | "soft"
			local wrapStatus

			keymap.overwrite_buffer_map("n", "<leader>tm", function()
				enabled = not enabled
				if enabled then
					vim.cmd("TableModeEnable")
					vim.cmd("RenderMarkdown disable")
					wrapStatus = wrap.status()
					wrap.set("off")
				else
					vim.cmd("TableModeDisable")
					vim.cmd("RenderMarkdown enable")
					wrap.set(wrapStatus)
				end
			end)
		end
	},
	{
		"kaymmm/bullets.nvim",
		dependencies = {
			"saghen/blink.cmp"
		},
		commit = "cfc5c6038d6edcb93509ea7d96d9c8fe3dad5438",
		ft = "markdown",
		config = function()
			require("Bullets").setup({
				outline_levels = { "num", "std-" },
				mappings = false,
			})
			bullets_mapping()
		end
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"echasnovski/mini.icons",
			"nvim-tree/nvim-web-devicons"
		},
		ft = "markdown",
		config = function()
			require("render-markdown").setup(
			---@module 'render-markdown'
			---@type render.md.UserConfig
				{
					completions = {
						blink = {
							enabled = true
						},
					},
					render_modes = true,

					win_options = {
						conceallevel = { default = vim.o.conceallevel, rendered = 3 },
						concealcursor = { default = vim.o.concealcursor, rendered = '' },
					},
					anti_conceal = {
						enabled = true,
						ignore = {
							quote = true,
							code_background = true,
							indent = true,
							sign = true,
							virtual_lines = true,
						},
					},

					heading = {
						enabled = true,
						sign = false,
					},
					latex = {
						enabled = true,
					},
					html = {
						enabled = false,
					},
					yaml = {
						enabled = false,
					},
				}
			)
		end
	},

	-- sc-im support
	-- {
	--     "DAmesberger/sc-im.nvim",
	--     event = "VeryLazy",
	--     config = function()
	--         local scim = require("sc-im")
	--         vim.keymap.set("n", "<leader>to", function()
	--             scim.open_in_scim()
	--         end, { noremap = true, silent = true })
	--         vim.keymap.set("n", "<leader>tr", function()
	--             scim.rename()
	--         end, { noremap = true, silent = true })
	--     end
	-- },
}

return {
	plugins = plugins,
	bullets_mapping = bullets_mapping
}
