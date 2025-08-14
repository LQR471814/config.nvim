-- plugins that do not require dependencies, they should work anywhere
return {
	-- theme
	{
		"sho-87/kanagawa-paper.nvim",
		config = function()
			vim.cmd("colorscheme kanagawa-paper")
		end
	},
	-- file explorer
	{
		'stevearc/oil.nvim',
		opts = {
			view_options = {
				show_hidden = true
			},
			keymaps = {
				["go"] = "actions.open_external",
			}
		},
		dependencies = {
			{ "echasnovski/mini.icons", opts = {} }
		},
	},
	-- line wrap
	{
		"andrewferrier/wrapping.nvim",
		event = "VeryLazy",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("wrapping").setup({
				notify_on_switch = false
			})
		end
	},
	-- rename html tags
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
	},
	-- pcre syntax
	{
		"othree/eregex.vim",
		event = "VeryLazy"
	},
	-- make editing big files faster
	{
		"mireq/large_file",
		config = function()
			require("large_file").setup()
		end
	},
	-- guess indentation config of a file
	{
		"NMAC427/guess-indent.nvim",
		event = "VeryLazy",
		config = function()
			require("guess-indent").setup {}
		end
	},
	-- fancy undos
	{
		"mbbill/undotree",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	-- switch between files
	require("lqr471814.plugins.harpoon"),
	-- manipulate brackets
	require("lqr471814.plugins.surround"),
	-- auto close brackets
	require("lqr471814.plugins.autoclose"),
	-- multi-cursors
	require("lqr471814.plugins.multicursors"),
    -- text case modifications
    -- {
    --     "johmsalas/text-case.nvim",
    --     event = "VeryLazy",
    --     dependencies = {
    --         "nvim-telescope/telescope.nvim"
    --     },
    --     config = function()
    --         require("textcase").setup({})
    --         require("telescope").load_extension("textcase")
    --     end
    -- },
}
