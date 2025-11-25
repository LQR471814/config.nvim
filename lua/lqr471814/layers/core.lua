-- plugins that do not require dependencies, they should work anywhere
return {
	-- theme
	require("lqr471814.plugins.theme"),
	-- guess indentation config of a file
	require('lqr471814.plugins.guess-indent'),
	-- fancy undos
	require("lqr471814.plugins.undotree"),
	-- modern matchparen replacement
	require("lqr471814.plugins.matchup"),
	-- switch between files
	require("lqr471814.plugins.harpoon"),
	-- manipulate brackets
	require("lqr471814.plugins.surround"),
	-- auto close brackets
	require("lqr471814.plugins.autoclose"),
	-- multi-cursors
	require("lqr471814.plugins.multicursors"),
	-- file explorer
	require("lqr471814.plugins.oil"),
	-- local config
	require("lqr471814.plugins.localconf"),
	-- notifications / etc...
	require("lqr471814.plugins.snacks"),
	-- rename html tags
	{ "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" } },
	-- pcre syntax
	{ "othree/eregex.vim",      event = "VeryLazy" },
	-- natural dates
	{ "Gelio/cmp-natdat",       config = true },
	-- make editing big files faster
	{ "mireq/large_file",       config = true },
}
