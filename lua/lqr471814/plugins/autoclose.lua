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
            ["'"] = { escape = false, close = true, pair = "''" },
            ["`"] = { escape = false, close = true, pair = "``" },
        },
        options = {
            disabled_filetypes = { "TelescopePrompt", "grug-far", "tex", "markdown" },
            auto_indent = true,
            disable_command_mode = true,
        },
    }
}
