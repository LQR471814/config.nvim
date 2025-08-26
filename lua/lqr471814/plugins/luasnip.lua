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

            require("luasnip.loaders.from_lua").lazy_load({
                paths = { "~/.config/nvim/snippets" }
            })
        end
    }
}
