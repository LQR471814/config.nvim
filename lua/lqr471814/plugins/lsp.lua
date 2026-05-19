return {
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        dependencies = {
            "b0o/schemastore.nvim",
            "saghen/blink.cmp",
            "jhofscheier/ltex-utils.nvim",
        },
        config = function()
            -- disable lsp debug logging
            vim.lsp.log.set_level("off")

            local lspconfig = require("lspconfig")
            local opts = {
                clangd = {
                    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
                },
                tailwindcss = {},
                biome = {},
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
                    on_attach = function(client, bufnr)
                        require("ltex-utils").on_attach(bufnr)
                    end,
                    ltex = {
                        language = "en-US",
                    },
                    settings = {}
                },
                ["nu-lint"] = {
                    cmd = { "nu-lint", "--lsp" },
                    filetypes = { "nu" },
                    root_markers = { '.git' }
                },
                please = {},

                rust_analyzer = {},
                ocamllsp = {},
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
                    keymap.overwrite_buffer_map("n", "ge", function() vim.diagnostic.open_float() end, "", ev.buf)
                    keymap.overwrite_buffer_map("n", "gd", function()
                        Snacks.picker.lsp_definitions({
                            auto_confirm = true
                        })
                    end, "Go to definition.", ev.buf)
                    keymap.overwrite_buffer_map("n", "gh", vim.lsp.buf.hover, "", ev.buf)
                    keymap.overwrite_buffer_map("n", "gr", function()
                        Snacks.picker.lsp_references()
                    end, "", ev.buf)

                    -- rename with a completely different name
                    keymap.overwrite_buffer_map("n", "<leader>rr", function()
                        vim.ui.input(
                            {
                                prompt = "Rename: ",
                                default = "",
                            },
                            function(input)
                                if not input then
                                    return
                                end
                                if not require("ts-autotag").rename(input) then
                                    vim.lsp.buf.rename(input)
                                end
                            end
                        )
                    end, "", ev.buf)

                    -- rename starting with the same name
                    keymap.overwrite_buffer_map("n", "<leader>rn", function()
                        if not require("ts-autotag").rename() then
                            vim.lsp.buf.rename()
                        end
                    end, "", ev.buf)

                    keymap.overwrite_buffer_map("i", "<C-h>", function() vim.lsp.buf.signature_help() end, "", ev.buf)
                    keymap.overwrite_buffer_map({ "n", "v" }, "<leader>.", vim.lsp.buf.code_action, "", ev.buf)
                    keymap.overwrite_buffer_map("n", "]g", function()
                        vim.diagnostic.jump({ count = 1, float = true })
                    end, "", ev.buf)
                    keymap.overwrite_buffer_map("n", "[g", function()
                        vim.diagnostic.jump({ count = -1, float = true })
                    end, "", ev.buf)
                end,
            })

            vim.diagnostic.config({
                update_in_insert = false
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                callback = function(args)
                    local client_id = args.data.client_id
                    local client = vim.lsp.get_client_by_id(client_id)
                    if not client then
                        return
                    end

                    -- Check if any other buffers are still using this client
                    local active_buffers = vim.lsp.get_buffers_by_client_id(client_id)
                    if #active_buffers <= 1 then
                        vim.lsp.stop_client(client_id)
                        print("All buffers using LSP closed, stopping: " .. client.name)
                    end
                end,
            })
        end
    },
    {
        "ray-x/go.nvim",
        version = "v0.11",
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
        'dmmulroy/ts-error-translator.nvim',
        opts = {
            auto_attach = true,
            servers = {
                "astro",
                "svelte",
                "ts_ls",
                "denols",
                "typescript-tools",
                "volar",
                "vtsls",
            },
        },
    },
    {
        "jhofscheier/ltex-utils.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            dictionary = {
                use_vim_dict = true
            }
        }
    }
}
