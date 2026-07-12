return {
	"romus204/tree-sitter-manager.nvim",
	dependencies = {},
	config = function()
		require("tree-sitter-manager").setup({
			ensure_installed = {
				-- jsdoc will not be automatically installed (if opening .js file)
				"jsdoc"
			},
			auto_install = true
		})
	end,
}
