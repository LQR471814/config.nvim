-- plugins that require dependencies, dependencies which may be called "bloat"
return {
	-- multi-cursors
	require("lqr471814.plugins.multicursors"),
	-- language server
	require("lqr471814.plugins.lsp"),
	-- markdown editing
	require("lqr471814.plugins.markdown"),
	-- notifications / image viewing / etc...
	require("lqr471814.plugins.snacks"),
	-- support .fountain files
	{
		"kblin/vim-fountain",
		event = "VeryLazy",
	},
	-- latex support
	{
		"lervag/vimtex",
		event = "VeryLazy",
	},
	-- local config
	{
		"klen/nvim-config-local",
		config = function()
			require("config-local").setup({
				config_files = { ".nvim.lua" },
				hashfile = vim.fn.stdpath("data") .. "/config-local",
				autocommands_create = true,
				commands_create = true,
				silent = false,
				lookup_parents = false,
			})
		end
	},
	-- troubleshooting
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	}
	--
}
