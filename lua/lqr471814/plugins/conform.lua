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
                formatters_by_ft = {
                    typescript = jsopts,
                    typescriptreact = jsopts,
                    javascript = jsopts,
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
