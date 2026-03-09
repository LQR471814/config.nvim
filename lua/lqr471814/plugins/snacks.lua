return {
	"folke/snacks.nvim",
	priority = 1000,
	---@type snacks.Config
	opts = {
		notifier = {},
		image = {
			doc = {
				inline = false,
				float = true,
			},
			math = { enabled = false },
		},
		lazygit = {},
		quickfile = {},
		picker = {
			main = {
				file = false,
				current = true,
			},
		},
	}
}
