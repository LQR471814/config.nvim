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
	}
}
