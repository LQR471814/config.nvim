return {
	"romus204/tree-sitter-manager.nvim",
	dependencies = {},
	config = function()
		require("tree-sitter-manager").setup({
			ensure_installed = {
				-- jsdoc will not be automatically installed (if opening .js file)
				"jsdoc",

				-- render-markdown
				"latex",

				-- Snacks.image
				"css",
				"html",
				"javascript",
				"latex",
				"scss",
				"svelte",
				"tsx",
				"typst",
				"vue",

				-- Snacks.picker
				"regex",

				-- ts-autotag
				"typescript",
				"javascript",
				"tsx",
				"xml",
				"templ",
				"php",
				"mdx",

				-- go.nvim requirements
				"go",
				"gomod",
				"gowork",
				"gosum",
				"sql",
				"gotmpl",
				"json",
				"comment",
			},
			auto_install = true
		})
	end,
}
