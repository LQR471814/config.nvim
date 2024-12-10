return {
    {
        "L3MON4D3/LuaSnip",
        tag = "v2.*",
        build = "make install_jsregexp",
        config = function()
            local ls = require("luasnip")
            ls.config.setup({
                enable_autosnippets = true,
                update_events = { "TextChanged", "TextChangedI" }
            })

            require("luasnip.loaders.from_snipmate").lazy_load({
                paths = { "~/.config/nvim/snippets" }
            })
            require("luasnip.loaders.from_lua").lazy_load({
                paths = { "~/.config/nvim/snippets" }
            })
        end
    }
}