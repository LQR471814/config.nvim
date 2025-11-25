-- plugins that require dependencies, dependencies which may be called "bloat"
return {
	-- blink
	require("lqr471814.plugins.blink"),
	-- language server
	require("lqr471814.plugins.lsp"),
	-- markdown editing
	require("lqr471814.plugins.markdown"),
	-- latex support
	require("lqr471814.plugins.latex"),
	-- treesitter walker
	require("lqr471814.plugins.tree-climber"),
	-- git merge tool
	require("lqr471814.plugins.diffview"),
	-- browser integration
	require("lqr471814.plugins.firenvim"),
	-- troubleshooting
	require("lqr471814.plugins.trouble"),
	-- profiling
	require("lqr471814.plugins.profile"),
	-- support .fountain files
	{ "kblin/vim-fountain", event = "VeryLazy" },
}
