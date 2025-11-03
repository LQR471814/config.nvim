return {
    "m4xshen/autoclose.nvim",
    opts = {
        keys = {
            ["("] = { escape = false, close = true, pair = "()" },
            ["["] = { escape = false, close = true, pair = "[]" },
            ["{"] = { escape = false, close = true, pair = "{}" },

            [">"] = { escape = true, close = false, pair = "<>" },
            [")"] = { escape = true, close = false, pair = "()" },
            ["]"] = { escape = true, close = false, pair = "[]" },
            ["}"] = { escape = true, close = false, pair = "{}" },

            ['"'] = { escape = false, close = true, pair = '""' },
            ["'"] = { escape = false, close = true, pair = "''", disabled_filetypes = { "lisp", "julia" } },
            ["`"] = { escape = false, close = true, pair = "``", disabled_filetypes = { "lisp" } },
        },
        options = {
            disabled_filetypes = { "TelescopePrompt", "grug-far", "tex", "markdown" },
            auto_indent = false,
            disable_command_mode = true,
        },
    }
}
