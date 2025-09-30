return {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        local keymap = require("lqr471814.lib.keymap")
        keymap:map("n", "<leader>a", function() harpoon:list():add() end)
        keymap:map("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        keymap:map({ "n", "i" }, "<C-1>", function() harpoon:list():select(1) end)
        keymap:map({ "n", "i" }, "<C-2>", function() harpoon:list():select(2) end)
        keymap:map({ "n", "i" }, "<C-3>", function() harpoon:list():select(3) end)
        keymap:map({ "n", "i" }, "<C-4>", function() harpoon:list():select(4) end)
    end
}
