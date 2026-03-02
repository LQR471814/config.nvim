return {
    -- improve formatters
    {
        'stevearc/conform.nvim',
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format()
                end,
                mode = "n",
                desc = "Format buffer."
            },
        },
        config = function()
            local conform = require("conform")
            local jsopts = {
                "biome",
                "denols",
                "vtsls",
                stop_after_first = true,
                lsp_format = "fallback"
            }
            conform.setup({
                notify_no_formatters = true,
                default_format_opts = {
                    lsp_format = "prefer",
                    timeout_ms = 500
                },
                formatters = {
                    nufmt = {
                        command = "nufmt",
                        args = { "--stdin" },
                        stdin = true,
                    },
                },
                formatters_by_ft = {
                    typescript = jsopts,
                    typescriptreact = jsopts,
                    javascript = jsopts,
                    tex = {
                        "latexindent",
                        lsp_format = "fallback"
                    },
                    nushell = { "nufmt", lsp_format = "fallback" },
                    ["*"] = { "trim_whitespace" },
                },
                format_on_save = {
                    lsp_format = "prefer",
                    timeout_ms = 500,
                }
            })
        end,
    }
}
