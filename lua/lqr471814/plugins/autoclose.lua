return {
    "m4xshen/autoclose.nvim",
    event = "VeryLazy",
    config = function()
        require("autoclose").setup({
            keys = {
                ["{"] = { escape = false, close = true, pair = "{}", disabled_filetypes = { "tex" } },
                ["["] = { escape = false, close = true, pair = "[]", disabled_filetypes = { "tex" } },
                ["("] = { escape = false, close = true, pair = "()", disabled_filetypes = { "tex" } },
                ["'"] = { escape = false, close = true, pair = "''", disabled_filetypes = { "text", "markdown", "tex" } },
                ['"'] = { escape = false, close = true, pair = '""', disabled_filetypes = { "tex" } },
                ["`"] = { escape = false, close = true, pair = "``", disabled_filetypes = { "tex" } },
            },
        })
    end
}
