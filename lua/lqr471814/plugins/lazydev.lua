return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			{ path = "snacks.nvim",        words = { "Snacks" } },
		},
		integrations = {
			cmp = false,
			coq = false,
			blink = true
		},
	},
}
