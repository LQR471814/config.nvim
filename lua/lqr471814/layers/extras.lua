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
}
