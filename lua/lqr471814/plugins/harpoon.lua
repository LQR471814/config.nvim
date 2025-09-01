return {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set({ "n", "i" }, "<C-1>", function() harpoon:list():select(1) end)
        vim.keymap.set({ "n", "i" }, "<C-2>", function() harpoon:list():select(2) end)
        vim.keymap.set({ "n", "i" }, "<C-3>", function() harpoon:list():select(3) end)
        vim.keymap.set({ "n", "i" }, "<C-4>", function() harpoon:list():select(4) end)

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set({ "n", "i" }, "<C-p>", function() harpoon:list():prev() end)
        vim.keymap.set({ "n", "i" }, "<C-n>", function() harpoon:list():next() end)
    end
}
