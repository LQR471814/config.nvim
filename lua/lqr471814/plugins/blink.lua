return {
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
        event = "VeryLazy",

        config = function()
            local blink = require("blink.cmp")
            local keymap = require("lqr471814.lib.keymap")

            keymap:overwrite_map("i", "<cr>", function()
                local accepted = blink.accept()
                if not accepted then
                    vim.api.nvim_feedkeys("\r", "n", true)
                end
            end)

            blink.setup({
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
            })
        end
    },
}
