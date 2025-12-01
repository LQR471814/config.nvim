return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose" },
	config = function()
		require("diffview").setup({})

		local keymap = require("lqr471814.lib.keymap")

		local open = false
		keymap.map("n", "<leader>d", function()
			if not open then
				vim.cmd("DiffviewOpen")
			else
				vim.cmd("DiffviewClose")
			end
			open = not open
		end, "Toggle diffview window.")
	end
}
