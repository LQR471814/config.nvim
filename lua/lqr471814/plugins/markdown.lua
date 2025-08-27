return {
	-- this plugin already does lazy-loading by default, lazy-loading tends to
	-- interfere with its functioning
	"dhruvasagar/vim-table-mode",
	{
		"kaymmm/bullets.nvim",
		event = "VeryLazy",
		opts = {
			outline_levels = { 'num', 'std-' },
			mappings = false,
		},
	},
	{
		"Thiago4532/mdmath.nvim",
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
		},
		event = "VeryLazy",
		opts = {
			hide_on_insert = false
		}
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.icons"
		},
		config = function()
			require("render-markdown").setup({
				---@module 'render-markdown'
				---@type render.md.UserConfig
				completions = {
					blink = {
						enabled = true
					},
				},
				render_modes = { "n", "i", "c", "t" },
				heading = {
					enabled = true,
					sign = false,
				},
				latex = {
					enabled = false,
				}
			})
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
