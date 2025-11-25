return {
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        event = "VeryLazy",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
    },
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        opts = {
            defaults = {
                path_display = { "truncate" },
                layout_strategy = "flex",
                layout_config = {
                    flex = {
                        flip_columns = 120,
                        flip_lines   = 20,
                    },
                    horizontal = {
                        preview_width  = 0.4,
                        preview_cutoff = 40,
                    },
                    vertical = {
                        preview_height = 0.5,
                        preview_cutoff = 10,
                    },
                },
            },
        },
    }
}
