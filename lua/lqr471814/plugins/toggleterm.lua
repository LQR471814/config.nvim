return {
	'akinsho/toggleterm.nvim',
	version = "9a88eae817ef395952e08650b3283726786fb5fb",
	config = function()
		local keymap = require("lqr471814.lib.keymap")
		require("toggleterm").setup({})

		keymap.map("n", "<leader>pt", "<cmd>TermSelect<cr>", "Select a terminal.")
		keymap.overwrite_map("n", "<leader>tt", "<cmd>ToggleTerm<cr>", "Toggle the in-built terminal.")
		keymap.map("n", "<leader>tn", "<cmd>TermNew<cr>", "Toggle the in-built terminal.")
	end
}
