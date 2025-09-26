return {
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
        event = "VeryLazy",

        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "none",

                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide", "fallback" },
                -- this is unreliable, we use our own mappings
                -- ["<CR>"] = { "accept", "fallback" },

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
            snippets = { preset = "luasnip" },
            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                per_filetype = {
                    markdown = { "lsp", "path", "snippets" },
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
        },
        opts_extend = { "sources.default" },

        config = function()
            local blink = require("blink-cmp")
            vim.keymap.set("i", "<cr>", function()
                if blink.is_active() then
                    blink.accept()
                else
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes('<CR>', true, true, true),
                        'n', true
                    )
                end
            end, { noremap = true, silent = true })
        end
    },
}
