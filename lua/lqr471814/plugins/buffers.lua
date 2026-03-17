return {
	-- heuristically close old un-edited buffers after reaching more than 10 buffers
	{
		'axkirillov/hbac.nvim',
		config = true,
	},
	{
		"n3tw0rth/keeper.nvim",
		config = function()
			require("scrub").setup()
			local keymap = require("lqr471814.lib.keymap")
			keymap.map("n", "<leader>pb", "<cmd>Scrub<cr>", "Open scrub.")
		end
	},
}
