return {
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
                    require("go.format").goimports()
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
        config = function()
            -- disable lsp debug logging
            vim.lsp.set_log_level("off")

            local lspconfig = require("lspconfig")
            local opts = {
                clangd = {
                    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
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
                pyright = {},
                ltex_plus = {
                    ltex = {
                        language = "en-US",
                    },
                },

                julials = {},
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
                                nixos = {
                                    expr = [[
                                        let
                                            config = (builtins.getFlake (builtins.toString ./.)).nixosConfigurations;
                                        in
                                            builtins.getAttr (builtins.elemAt (builtins.attrNames config) 0) config
                                    ]],
                                },
                                home_manager = {
                                    expr =
                                    [[(builtins.getFlake (builtins.toString ./.)).homeConfigurations.lqr471814.options]],
                                },
                            },
                        },
                    },
                },
                denols = {
                    root_dir = function(bufnr, on_dir)
                        local path = vim.api.nvim_buf_get_name(bufnr)
                        local denopath = lspconfig.util.root_pattern("deno.json")(path)
                        local nodepath = lspconfig.util.root_pattern("package.json")(path)
                        if not denopath then
                            return
                        end
                        if not nodepath then
                            on_dir(denopath)
                            return
                        end
                        local denoparts = vim.split(denopath, "/", { trimempty = true })
                        local nodeparts = vim.split(nodepath, "/", { trimempty = true })

                        -- if both deno.json and node.json are both present in closest ancestor, enable denols
                        if #denoparts == #nodeparts then
                            on_dir(nodepath)
                            return
                        end
                        -- if deno.json is closest ancestor, enable denols
                        if #denoparts > #nodeparts then
                            on_dir(nodepath)
                            return
                        end
                        -- if package.json is closest ancestor, don't enable denols
                    end,
                    single_file_support = false,
                },
                vtsls = {
                    root_dir = function(bufnr, on_dir)
                        local path = vim.api.nvim_buf_get_name(bufnr)
                        local denopath = lspconfig.util.root_pattern("deno.json")(path)
                        local nodepath = lspconfig.util.root_pattern("package.json")(path)
                        if not nodepath then
                            return
                        end
                        if not denopath then
                            on_dir(nodepath)
                            return
                        end
                        local denoparts = vim.split(denopath, "/", { trimempty = true })
                        local nodeparts = vim.split(nodepath, "/", { trimempty = true })

                        -- if both deno.json and node.json are both present in closest ancestor, enable vtsls
                        if #denoparts == #nodeparts then
                            on_dir(nodepath)
                            return
                        end
                        -- if deno.json is closest ancestor, don't enable vtsls
                        if #denoparts > #nodeparts then
                            return
                        end
                        -- if package.json is closest ancestor, enable vtsls
                        on_dir(nodepath)
                    end,
                    single_file_support = false,
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
                jsonls = {
                    settings = {
                        json = {
                            schemas = require("schemastore").json.schemas(),
                            validate = { enable = true },
                        }
                    }
                }
            }

            -- setup lsp
            local blink = require("blink.cmp")
            for server, config in pairs(opts) do
                config.capabilities = blink.get_lsp_capabilities(config.capabilities)
                vim.lsp.enable(server)
                vim.lsp.config(server, config)
            end

            -- setup lsp keymapping
            local keymap = require("lqr471814.lib.keymap")
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    keymap.buffer_map("n", "ge", function() vim.diagnostic.open_float() end, "", ev.buf)
                    keymap.buffer_map("n", "gd", vim.lsp.buf.definition, "", ev.buf)
                    keymap.buffer_map("n", "gh", vim.lsp.buf.hover, "", ev.buf)
                    keymap.buffer_map("n", "gr", vim.lsp.buf.references, "", ev.buf)

                    -- rename with a completely different name
                    keymap.buffer_map("n", "<leader>rr", function()
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
                    end, "", ev.buf)

                    -- rename starting with the same name
                    keymap.buffer_map("n", "<leader>rn", vim.lsp.buf.rename, "", ev.buf)

                    keymap.buffer_map("i", "<C-h>", function() vim.lsp.buf.signature_help() end, "", ev.buf)
                    keymap.buffer_map({ "n", "v" }, "<space>.", vim.lsp.buf.code_action, "", ev.buf)
                    keymap.buffer_map({ "n" }, "<leader>f", function()
                        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                    end, "", ev.buf)
                    keymap.buffer_map("n", "]g", function()
                        vim.diagnostic.jump({ count = 1, float = true })
                    end, "", ev.buf)
                    keymap.buffer_map("n", "[g", function()
                        vim.diagnostic.jump({ count = -1, float = true })
                    end, "", ev.buf)
                end,
            })
        end
    },
}
