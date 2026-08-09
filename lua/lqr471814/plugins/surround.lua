return {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    version = false,
    config = function()
        local keymap = require("lqr471814.lib.keymap")

        local surround = require("mini.surround")
        surround.setup({
            -- Preserve current behavior:
            -- use no-space pairs for opening bracket keys too.
            custom_surroundings = {
                ["("] = { output = { left = "(", right = ")" } },
                ["["] = { output = { left = "[", right = "]" } },
                ["{"] = { output = { left = "{", right = "}" } },
                ["<"] = { output = { left = "<", right = ">" } },
                ["="] = { output = { left = "==", right = "==" } },
            },

            mappings = {
                add = "ys",
                delete = "ds",
                replace = "cs",

                find = "",
                find_left = "",
                highlight = "",

                suffix_last = "",
                suffix_next = "",
            },

            -- Avoid linewise/blockwise surround changing layout/indent.
            respect_selection_type = false,

            -- Similar to classic surround: operate on covering pair only.
            search_method = "cover",
        })

        -- yss<new> => surround whole line
        keymap.overwrite_map("n", "yss", "ys_", "Surround the whole line.")

        -- Visual S<new> => surround selection
        keymap.unmap({ "v", "x" }, "ys")
        keymap.overwrite_map({ "v", "x" }, "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], "Surround the visual selection.")
    end,
}
