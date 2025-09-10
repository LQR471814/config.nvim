return {
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        event = "VeryLazy",
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
        opts = {
            defaults = {
                path_display = { "truncate" },
            },
        },
    }
}
