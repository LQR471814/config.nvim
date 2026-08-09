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
            "Gelio/cmp-natdat",
        },
        event = "VeryLazy",
        opts = {
            keymap = {
                preset = "none",

                ["<C-space>"] = {
                    function(cmp)
                        cmp.show({
                            providers = {
                                "natdat",
                                "lazydev",
                                "lsp",
                                "path",
                                "snippets",
                                "buffer"
                            }
                        })
                    end,
                    "show_documentation",
                    "hide_documentation"
                },
                ["<C-e>"] = { "hide", "fallback" },
                ["<CR>"] = { "accept", "fallback" },

                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },

                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
                ["<C-n>"] = { "select_next", "fallback_to_mappings" },
            },
            snippets = {
                preset = "luasnip"
            },
            sources = {
                default = { "natdat", "lazydev", "lsp", "path" },
                providers = {
                    markdown_path = {
                        name = 'Path',
                        module = 'blink.cmp.sources.path',

                        transform_items = function(_, items)
                            for _, item in ipairs(items) do
                                if item.insertText then
                                    item.insertText = item.insertText:gsub(' ', '%%20')
                                end

                                if item.textEdit and item.textEdit.newText then
                                    item.textEdit.newText =
                                        item.textEdit.newText:gsub(' ', '%%20')
                                end
                            end

                            return items
                        end,
                    },
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
                per_filetype = {
                    markdown = { "natdat", "lsp", "markdown_path", "snippets" }
                }
            },
        },
    },
}
