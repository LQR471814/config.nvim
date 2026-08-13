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

            ---@enum JSLsp
            local js_lsp = {
                vtsls = "vtsls",
                deno = "deno"
            }

            ---@class JSLspChoice
            ---@field lsp JSLsp
            ---@field priority integer

            ---@type table<string, JSLspChoice>
            local js_root_markers = {
                ["deno.json"] = {
                    lsp = "deno",
                    priority = 2,
                },
                ["package.json"] = {
                    lsp = "vtsls",
                    priority = 3,
                },
                ["jsconfig.json"] = {
                    lsp = "vtsls",
                    priority = 1,
                },
                ["tsconfig.json"] = {
                    lsp = "vtsls",
                    priority = 1,
                }
            }

            ---@return string, JSLsp
            local function resolve_js_root(bufnr)
                local path = vim.api.nvim_buf_get_name(bufnr)

                -- we first take the set of paths that are the most specific

                ---@class PathEntry
                ---@field path string
                ---@field segment_count integer
                ---@field choice JSLspChoice

                ---@type PathEntry[]
                local resolved = {}
                for pattern, choice in pairs(js_root_markers) do
                    local resolved_path = lspconfig.util.root_pattern(pattern)(path)
                    if not resolved_path then
                        goto continue
                    end
                    table.insert(resolved, {
                        path = resolved_path,
                        segment_count = #vim.split(resolved_path, "/", { trimempty = true }),
                        choice = choice
                    })
                    ::continue::
                end
                table.sort(resolved, function(a, b)
                    return a.segment_count < b.segment_count
                end)

                -- if nothing was resolved

                if #resolved == 0 then
                    return vim.fn.getcwd(), "vtsls"
                end

                -- we take the highest priority LSP from the set of most specific

                ---@type PathEntry[]
                local most_specific = {}
                for _, entry in ipairs(resolved) do
                    if #most_specific <= 0 then
                        table.insert(most_specific, entry)
                        goto continue
                    end
                    local prev = most_specific[#most_specific]
                    if prev.segment_count == entry.segment_count then
                        table.insert(most_specific, entry)
                    else
                        break
                    end
                    ::continue::
                end

                ---@type JSLspChoice | nil
                local chosen = nil
                ---@type string | nil
                local chosen_path = nil
                for _, entry in ipairs(most_specific) do
                    if chosen == nil or entry.choice.priority > chosen.priority then
                        chosen = entry.choice
                        chosen_path = entry.path
                    end
                end

                assert(chosen, "chosen must be defined")
                assert(chosen_path, "chosen_path must be defined")

                return chosen_path, chosen.lsp
            end

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

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
                marksman = {
                    root_markers = { '.marksman.toml', '.git' },
                },
                nushell = {},
                ast_grep = {},
                ty = {},
                ltex_plus = {
                    on_attach = function(client, bufnr)
                        require("ltex-utils").on_attach(bufnr)
                    end,
                    ltex = {
                        language = "en-US",
                    },
                    settings = {
                        ltex = {
                            checkFrequency = "save"
                        }
                    }
                },
                -- NOTE: removed because too flaky
                -- ["nu-lint"] = {
                --     cmd = { "nu-lint", "--lsp" },
                --     filetypes = { "nu" },
                --     root_markers = { '.git' }
                -- },
                please = {},

                rust_analyzer = {},
                -- ocamllsp = {},
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
                        local dir, lsp = resolve_js_root(bufnr)
                        if lsp == js_lsp.deno then
                            on_dir(dir)
                        end
                    end,
                    single_file_support = false,
                },
                vtsls = {
                    root_dir = function(bufnr, on_dir)
                        local dir, lsp = resolve_js_root(bufnr)
                        if lsp == js_lsp.vtsls then
                            on_dir(dir)
                        end
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
                },

                hls = {
                    filetypes = { 'haskell', 'lhaskell', 'cabal' },
                }
            }

            -- setup lsp
            local blink = require("blink.cmp")
            for server, config in pairs(opts) do
                config.capabilities = blink.get_lsp_capabilities(config.capabilities)
                vim.lsp.config(server, config)
                vim.lsp.enable(server)
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

            vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
                callback = function()
                    vim.schedule(function()
                        for _, client in ipairs(vim.lsp.get_clients()) do
                            local has_live_buffer = false

                            for bufnr in pairs(client.attached_buffers) do
                                if vim.api.nvim_buf_is_valid(bufnr) then
                                    has_live_buffer = true
                                    break
                                end
                            end

                            if not has_live_buffer then
                                client:stop()
                            end
                        end
                    end)
                end,
            })
        end
    },
    {
        "ray-x/go.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "ray-x/guihua.lua"
        },
        config = function()
            require("go").setup()
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require("go.format").goimports()
                end,
                group = format_sync_grp,
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
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
        event = "VeryLazy",
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
