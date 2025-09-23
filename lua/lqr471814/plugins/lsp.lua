return {
    {
        'saghen/blink.cmp',
        version = '1.*',
        dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },
        event = "VeryLazy",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = 'enter' },
            snippets = { preset = 'luasnip' },
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
        opts_extend = { "sources.default" }
    },
    {
        "ray-x/go.nvim",
        ft = { "go", "gomod" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
            "ray-x/guihua.lua"
        },
        config = function()
            require("go").setup()

            local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require('go.format').goimports()
                end,
                group = format_sync_grp,
            })
        end,
        event = { "CmdlineEnter" },
        build = ':lua require("go.install").update_all_sync()'
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
            integrations = {
                cmp = false,
                coq = false,
                blink = true
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        dependencies = {
            "b0o/schemastore.nvim",
            "saghen/blink.cmp",
        },
        opts = {
            servers = {
                clangd = {
                    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' }
                },
                tailwindcss = {},
                svelte = {},
                templ = {},
                ruff = {},
                gopls = {},
                texlab = {},
                marksman = {},
                nushell = {},
                ast_grep = {},

                nixd = {
                    cmd = { "nixd" },
                    settings = {
                        nixd = {
                            nixpkgs = {
                                expr = "import <nixpkgs> { }",
                            },
                            formatting = {
                                command = { "nixfmt" },
                            },
                            options = {
                                home_manager = {
                                    expr =
                                    "(import <home-manager/modules> { configuration = ~/.config/home-manager/home.nix; pkgs = import <nixpkgs> {}; }).options",
                                },
                            },
                        },
                    },
                },
                vtsls = {
                    settings = {
                        vtsls = {
                            experimental = {
                                completion = {
                                    enableServerSideFuzzyMatch = true
                                }
                            }
                        },
                        javascript = {
                            preferences = {
                                autoImportFileExcludePatterns = {
                                    "node_modules/**"
                                }
                            },
                            updateImportsOnFileMove = { enabled = "always" },
                            suggest = {
                                completeFunctionCalls = true,
                            },
                        },
                        typescript = {
                            preferences = {
                                autoImportFileExcludePatterns = {
                                    "node_modules/**"
                                }
                            },
                            updateImportsOnFileMove = { enabled = "always" },
                            suggest = {
                                completeFunctionCalls = true,
                            },
                        }
                    }
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace"
                            }
                        }
                    }
                },
            }
        },
        config = function(_, opts)
            opts.jsonls = {
                settings = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
                    }
                }
            }

            local blink = require('blink.cmp')

            for server, config in pairs(opts.servers) do
                vim.lsp.enable(server)

                config.capabilities = blink.get_lsp_capabilities(config.capabilities)
                vim.lsp.config(server, config)
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    vim.keymap.set('n', 'gq', 'gw', { noremap = true })
                    vim.keymap.set('n', 'gqq', 'gww', { noremap = true })
                    vim.keymap.set('v', 'gq', 'gw', { noremap = true })

                    local options = { buffer = ev.buf }
                    vim.keymap.set("n", "ge", function() vim.diagnostic.open_float() end, options)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
                    vim.keymap.set("n", "gh", vim.lsp.buf.hover, options)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, options)

                    -- rename with a completely different name
                    vim.keymap.set("n", "<leader>rr", function()
                        vim.ui.input(
                            {
                                prompt = "Rename: ",
                                default = "",
                            },
                            function(input)
                                if input then
                                    vim.lsp.buf.rename(input)
                                end
                            end
                        )
                    end, options)

                    -- rename starting with the same name
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options)

                    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, options)
                    vim.keymap.set({ "n", "v" }, "<space>.", vim.lsp.buf.code_action, options)
                    vim.keymap.set({ "n" }, "<leader>f", function()
                        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                    end, options)
                    vim.keymap.set("n", "]g", function()
                        vim.diagnostic.jump({ count = 1, float = true })
                    end)
                    vim.keymap.set("n", "[g", function()
                        vim.diagnostic.jump({ count = -1, float = true })
                    end)
                end,
            })
        end
    },
}
