-- plugins that require dependencies, dependencies which may be called "bloat"
return {
	-- blink
	require("lqr471814.plugins.blink"),
	-- language server
	require("lqr471814.plugins.lsp"),
	-- markdown editing
	require("lqr471814.plugins.markdown"),
	-- notifications / image viewing / etc...
	require("lqr471814.plugins.snacks"),
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
	-- latex support
	{
		"lervag/vimtex",
		-- vimtex lazy loads by default
		lazy = false,
		config = function()
			vim.g.vimtex_syntax_conceal_disable = 1
		end
	},
}
