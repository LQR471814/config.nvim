return {
    {
        "L3MON4D3/LuaSnip",
        event = "VeryLazy",
        tag = "v2.3.0",
        build = "make install_jsregexp",
        config = function()
            local ls = require("luasnip")
            ls.config.setup({
                enable_autosnippets = true,
                update_events = { "TextChanged", "TextChangedI" }
            })
            ls.filetype_extend("markdown", { "tex" })

            local ll = require("luasnip.loaders.from_lua")
            ll.lazy_load({
                paths = { "~/.config/nvim/snippets" },
            })

            -- clear jumps on insert leave
            vim.api.nvim_create_autocmd("InsertLeave", {
                pattern = "*",
                callback = function()
                    vim.cmd("silent lua require('luasnip').unlink_current()")
                end
            })
        end
    }
}
