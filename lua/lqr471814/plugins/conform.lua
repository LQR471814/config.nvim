return {
    -- improve formatters
    {
        "stevearc/conform.nvim",
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
                    topiary_nu = {
                        command = "topiary-nushell",
                        args = { "format", "-l", "nu" },
                        stdin = true,
                    },
                    tex_fmt = {
                        command = "tex-fmt",
                        args = { "-l", "73", "--stdin" },
                        stdin = true
                    }
                },
                formatters_by_ft = {
                    typescript = jsopts,
                    typescriptreact = jsopts,
                    javascript = jsopts,
                    tex = {
                        "tex_fmt",
                        lsp_format = "never"
                    },
                    nu = { "topiary_nu" },
                    ["*"] = { "trim_whitespace" },
                },
                format_after_save = function(bufnr)
                    local ft = vim.bo[bufnr].filetype
                    if ft == "go" then
                        return nil
                    end
                    return {
                        stop_after_first = true,
                        lsp_format = "fallback",
                        timeout_ms = 500,
                    }
                end
            })
        end,
    }
}
