return {
	"mbbill/undotree",
	event = "VeryLazy",
	config = function()
		local keymap = require("lqr471814.lib.keymap")
		keymap.map("n", "<leader>u", vim.cmd.UndotreeToggle)
	end,
}
