local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmta = require("luasnip.extras.fmt").fmta

return {
    s({ trig = "chk" }, fmta("[ ] ", {})),
    s({ trig = "mk", snippetType = "autosnippet", wordTrig = true }, fmta("$<>$", { i(1) })),
    s({ trig = "dm", snippetType = "autosnippet", wordTrig = true }, fmta(
        [[
        $$
        <>
        $$
        ]],
        { i(1) })),
    s({ trig = "aligned" }, fmta(
        [[
        $$
        \begin{aligned}
          <>
        \end{aligned}
        $$
        ]],
        { i(1) }
    )),
    s({ trig = [[\to]], snippetType = "autosnippet" }, t("→")),
    s({ trig = [[\neg]], snippetType = "autosnippet" }, t("¬")),
    s({ trig = [[\and]], snippetType = "autosnippet" }, t("∧")),
    s({ trig = [[\exi]], snippetType = "autosnippet" }, t("∃")),
    s({ trig = [[\in]], snippetType = "autosnippet" }, t("∈")),
    s({ trig = [[\leq]], snippetType = "autosnippet" }, t("≤")),
    s({ trig = [[\geq]], snippetType = "autosnippet" }, t("≥")),
    s({ trig = [[\forall]], snippetType = "autosnippet" }, t("∀")),
    s({ trig = [[\alpha]], snippetType = "autosnippet" }, t("α")),
    s({ trig = [[\beta]], snippetType = "autosnippet" }, t("β")),
    s({ trig = [[\Sigma]], snippetType = "autosnippet" }, t("Σ")),
    s({ trig = [[\gamma]], snippetType = "autosnippet" }, t("γ")),
    s({ trig = [[\omega]], snippetType = "autosnippet" }, t("ω")),
}
