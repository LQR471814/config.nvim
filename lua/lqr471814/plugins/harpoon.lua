return {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        local opts = { noremap = true, silent = true, unique = true }
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, opts)
        vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, opts)

        vim.keymap.set({ "n", "i" }, "<C-1>", function() harpoon:list():select(1) end, opts)
        vim.keymap.set({ "n", "i" }, "<C-2>", function() harpoon:list():select(2) end, opts)
        vim.keymap.set({ "n", "i" }, "<C-3>", function() harpoon:list():select(3) end, opts)
        vim.keymap.set({ "n", "i" }, "<C-4>", function() harpoon:list():select(4) end, opts)
    end
}
