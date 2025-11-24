return {
	"lervag/vimtex",
	-- vimtex lazy loads by default
	lazy = false,
	config = function()
		vim.g.vimtex_syntax_conceal_disable = 1
	end
}
