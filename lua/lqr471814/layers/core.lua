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
		"stevearc/oil.nvim",
		opts = {
			view_options = {
				show_hidden = true
			},
			keymaps = {
				["go"] = "actions.open_external",
			}
		},
		dependencies = {
			"echasnovski/mini.icons",
			"nvim-tree/nvim-web-devicons"
		},
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
			require("guess-indent").setup {
				filetype_exclude = {
					"markdown"
				},
			}
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
	-- modern matchparen replacement
	{
		"andymass/vim-matchup",
		event = "VeryLazy",
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
		---@type matchup.Config
		opts = {
			treesitter = {
				stopline = 1500,
			}
		}
	},
	-- switch between files
	require("lqr471814.plugins.harpoon"),
	-- manipulate brackets
	require("lqr471814.plugins.surround"),
	-- auto close brackets
	require("lqr471814.plugins.autoclose"),
	-- multi-cursors
	require("lqr471814.plugins.multicursors"),
	-- buffer-lines
	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	version = "*",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	config = function()
	-- 		require("bufferline").setup({
	-- 			options = {
	-- 				pick = {
	-- 					alphabet = "123456789abcdefghijklmopqrstuvwxyz"
	-- 				}
	-- 			}
	-- 		})
	-- 	end
	-- },

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
