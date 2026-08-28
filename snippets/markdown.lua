local luasnip = require("luasnip")
local s = require("lqr471814.lib").latex_snippet
local i = luasnip.insert_node
local t = luasnip.text_node
local fmta = require("luasnip.extras.fmt").fmta

return {
    s({ trig = "chk", outside_mathzone = true }, fmta("[ ] ", {})),
    s({ trig = "mk", snippetType = "autosnippet", wordTrig = true, outside_mathzone = true }, fmta("$<>$", { i(1) })),
    s({ trig = "dm", snippetType = "autosnippet", wordTrig = true, outside_mathzone = true }, fmta(
        [[
        $$
        <>
        $$
        ]],
        { i(1) })),
    s({ trig = "aligned", outside_mathzone = true }, fmta(
        [[
        $$
        \begin{aligned}
          <>
        \end{aligned}
        $$
        ]],
        { i(1) }
    )),
    s({ trig = [[\to]], snippetType = "autosnippet", outside_mathzone = true }, t("→")),
    s({ trig = [[\neg]], snippetType = "autosnippet", outside_mathzone = true }, t("¬")),
    s({ trig = [[\and]], snippetType = "autosnippet", outside_mathzone = true }, t("∧")),
    s({ trig = [[\exi]], snippetType = "autosnippet", outside_mathzone = true }, t("∃")),
    s({ trig = [[\in]], snippetType = "autosnippet", outside_mathzone = true }, t("∈")),
    s({ trig = [[\leq]], snippetType = "autosnippet", outside_mathzone = true }, t("≤")),
    s({ trig = [[\geq]], snippetType = "autosnippet", outside_mathzone = true }, t("≥")),
    s({ trig = [[\forall]], snippetType = "autosnippet", outside_mathzone = true }, t("∀")),
    s({ trig = [[\alpha]], snippetType = "autosnippet", outside_mathzone = true }, t("α")),
    s({ trig = [[\beta]], snippetType = "autosnippet", outside_mathzone = true }, t("β")),
    s({ trig = [[\Sigma]], snippetType = "autosnippet", outside_mathzone = true }, t("Σ")),
    s({ trig = [[\gamma]], snippetType = "autosnippet", outside_mathzone = true }, t("γ")),
    s({ trig = [[\omega]], snippetType = "autosnippet", outside_mathzone = true }, t("ω")),
}
