local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta

return {
    s({ trig = "iferr", snippetType = "autosnippet" }, fmta([[
        if err != nil {
            <>
        }
    ]], {
        i(1, "return err")
    })),
}
