-- plugins that provide key functionality, but may require dependencies
return {
	-- AST parsing/syntax highlighting
	require("lqr471814.plugins.treesitter"),
	-- tree sitter comments
	require("lqr471814.plugins.comment"),
	-- fuzzy find
	require("lqr471814.plugins.telescope"),
	-- luasnip
	require("lqr471814.plugins.luasnip"),
	-- search and replace
	require("lqr471814.plugins.spectre"),
	-- multi-cursors
	require("lqr471814.plugins.multicursors"),
}
