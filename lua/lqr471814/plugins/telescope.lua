return {
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
    },
    {
        'nvim-telescope/telescope.nvim',
        event = "VeryLazy",
        tag = '0.1.5',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzf-native.nvim',
        },
        config = function()
            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<leader>pf", function()
                builtin.find_files({
                    find_command = { 'fd', '--type', 'file', '--hidden', '-E', '.git' },
                })
            end, {})

            vim.keymap.set("n", "<leader>ps", function()
                local target = vim.fn.input("grep > ")
                builtin.grep_string({
                    search = target,
                    additional_args = { "--iglob", "!.git", "--hidden" }
                })
            end, {})

            vim.keymap.set("n", "<leader>pg", builtin.git_files)
            vim.keymap.set("n", "<leader>pb", builtin.buffers)
            vim.keymap.set("n", "<leader>pl", builtin.live_grep)
            vim.keymap.set("n", "<leader>pe", "<CMD>Telescope diagnostics<CR>")
            vim.keymap.set("n", "<leader>pc", "<CMD>Telescope commands<CR>")
            vim.keymap.set("n", "<leader>ph", "<CMD>Telescope help_tags<CR>")
        end
    }
}
