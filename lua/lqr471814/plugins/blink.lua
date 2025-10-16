return {
    {
        "saghen/blink.compat",
        -- use v2.* for blink.cmp v1.*
        version = "2.*",
        -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
        lazy = true,
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        opts = {},
    },
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "windwp/nvim-autopairs",
            "Gelio/cmp-natdat",
        },
        event = "VeryLazy",
        opts = {
            keymap = {
                preset = "none",

                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide", "fallback" },
                -- this is unreliable, we use our own mappings
                ["<CR>"] = { "accept", "fallback" },

                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },

                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
                ["<C-n>"] = { "select_next", "fallback_to_mappings" },

                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },

                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            },
            snippets = {
                preset = "luasnip"
            },
            sources = {
                default = { "natdat", "lazydev", "lsp", "path", "snippets", "buffer" },
                per_filetype = {
                    markdown = { "natdat", "lsp", "path", "snippets" },
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    natdat = {
                        name = "natdat",
                        module = "blink.compat.source",
                    },
                },
            },
        },
    },
}
