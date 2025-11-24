-- buffer-lines
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("bufferline").setup({
			options = {
				pick = {
					alphabet = "123456789abcdefghijklmopqrstuvwxyz"
				}
			}
		})
	end
}
