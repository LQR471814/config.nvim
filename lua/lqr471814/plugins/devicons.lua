return {
	"nvim-tree/nvim-web-devicons",
	config = function()
		require("nvim-web-devicons").setup({
			override_by_extension = {
				tla = {
					icon = "󰘧",
					color = "#4B8BBE",
					name = "TLA",
				},
			},
		})
	end
}
