local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
    s({ trig = "namespace", snippetType = "autosnippet" }, fmta([[
        namespace <>
        end <>
    ]], { i(1), rep(1), })),
}
