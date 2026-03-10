return {
	"folke/snacks.nvim",
	priority = 1000,
	config = function()
		require("snacks").setup(
		---@type snacks.Config
			{
				notifier = {},
				image = {
					doc = {
						inline = false,
						float = true,
						max_width = 66,
						max_height = 16,
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
			})
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "markdown", "tex" },
			callback = function(ev)
				if ev.match == "markdown" then
					Snacks.image.config.doc.float = false
					Snacks.image.config.doc.inline = true
				elseif ev.match == "tex" then
					Snacks.image.config.doc.float = true
					Snacks.image.config.doc.inline = false
				end
			end,
		})
	end
}
