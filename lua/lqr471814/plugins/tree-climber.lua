return {
	"drybalka/tree-climber.nvim",
	config = function()
		local tc = require("tree-climber")
		local keymap = require("lqr471814.lib.keymap")

		local opts = { highlight = true, timeout = 250 }

		-- movement
		keymap:map({ "n", "v" }, "<C-j>", function() tc.goto_next(opts) end, "Go to the next tree-sitter node.")
		keymap:map({ "n", "v" }, "<C-k>", function() tc.goto_prev(opts) end, "Go to the prev tree-sitter node.")
		keymap:map({ "n", "v" }, "<C-h>", function() tc.goto_parent(opts) end, "Go to the parent tree-sitter node.")
		keymap:map({ "n", "v" }, "<C-l>", function() tc.goto_child(opts) end, "Go the child tree-sitter node.")

		-- swapping
		keymap:map({ "v", "o" }, "in", function() tc.select_node(opts) end, "Select tree-sitter node.")
		keymap:map("n", "<C-S-k>", function() tc.swap_prev(opts) end, "Swap prev tree-sitter node.")
		keymap:map("n", "<C-S-j>", function() tc.swap_next(opts) end, "Swap next tree-sitter node.")
		keymap:map("n", "<C-S-h>", function() tc.highlight_node(opts) end, "Highlight tree-sitter node.")
	end

}
