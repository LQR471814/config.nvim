return {
	'stevearc/quicker.nvim',
	ft = "qf",
	config = function()
		local keymap = require("lqr471814.lib.keymap")

		require("quicker").setup({
			keys = {
				{
					">",
					function()
						require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
					end,
					desc = "Expand quickfix context",
				},
				{
					"<",
					function()
						require("quicker").collapse()
					end,
					desc = "Collapse quickfix context",
				},
			},
		})

		keymap.map("n", "<leader>q", function()
			require("quicker").toggle()
		end, "Toggle quickfix")
	end
}
