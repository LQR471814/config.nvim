local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
    s({ trig = "chk" }, fmta("[ ] ", { })),
    s({ trig = "mk", snippetType = "autosnippet" }, fmta("$<>$", { i(1) })),
    s({ trig = "dm", snippetType = "autosnippet" }, fmta(
        [[
        $$
        <>
        $$
        ]],
    { i(1) })),
    s({ trig = "{", wordTrig = false, snippetType = "autosnippet" }, fmta(
        "{<>}",
        { i(1) }
    )),
    s({ trig = "[", wordTrig = false, snippetType = "autosnippet" }, fmta(
        "[<>]",
        { i(1) }
    )),
    s({ trig = "(", wordTrig = false, snippetType = "autosnippet" }, fmta(
        "(<>)",
        { i(1) }
    )),
    s({ trig = "\"", wordTrig = false, snippetType = "autosnippet" }, fmta(
        [["<>"]],
        { i(1) }
    )),
    s({ trig = "`", wordTrig = false, snippetType = "autosnippet" }, fmta(
        [[`<>`]],
        { i(1) }
    )),
}
