return {
	"lervag/vimtex",
	-- vimtex lazy loads by default
	lazy = false,
	config = function()
		vim.g.vimtex_syntax_conceal_disable = 1
		vim.g.vimtex_compiler_latexmk = {
			aux_dir = '.vimtex',
			out_dir = '.vimtex',
			callback = 1,
			continuous = 1,
			executable = 'latexmk',
			hooks = {},
			options = {
				'-verbose',
				'-file-line-error',
				'-synctex=1',
				'-interaction=nonstopmode',
			},
		}
	end
}
