return {
    "nvim-pack/nvim-spectre",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "cd ~/.local/share/nvim/lazy/nvim-spectre/ && sh build.sh",
    config = function()
        require("spectre").setup({
            default = {
                find = {
                    cmd = "rg",
                    options = { "ignore-case" }
                },
                replace = {
                    cmd = "oxi"
                }
            },
        })
        vim.keymap.set('n', '<leader>re', '<cmd>lua require("spectre").toggle()<CR>', {
            desc = "Toggle Spectre"
        })
    end
}
