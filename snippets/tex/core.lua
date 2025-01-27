local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

return {
    -- \documentclass
    s({ trig = "latex", snippetType = "autosnippet" }, fmta([[
        \documentclass[a4paper, 12pt]{article}

        \usepackage{myconfig}

        \begin{document}

        \title{<>}
        \author{<>}
        \maketitle

        <>

        \end{document}
    ]], {
        i(1),
        i(2),
        i(3),
    })),

    -- \begin \end
    s({ trig = "beg", snippetType = "autosnippet" }, fmta(
        [[
        \begin{<>}
          <>
        \end{<>}
        ]],
        {
            i(1),
            i(2),
            rep(1),
        }
    )),

    -- \sections
    s({ trig = "!!", snippetType = "autosnippet" }, fmta(
        "\\section{<>}",
        { i(1) }
    )),
    s({ trig = "!@", snippetType = "autosnippet" }, fmta(
        "\\subsection{<>}",
        { i(1) }
    )),
    s({ trig = "!~", snippetType = "autosnippet" }, fmta(
        "\\subsubsection{<>}",
        { i(1) }
    )),

    -- inline mode math
    s({ trig = "mk", snippetType = "autosnippet" }, fmta(
        "$<>$",
        { i(1) }
    )),

    -- display mode math
    s({ trig = "dm", snippetType = "autosnippet" }, fmta(
        [[
        \[
          <>
        \]
        ]],
        { i(1) }
    )),

    -- aligned display mode math
    s({ trig = "adm", snippetType = "autosnippet" }, fmta(
        [[
        \[
        \begin{aligned}
          <>
        \end{aligned}
        \]
        ]],
        { i(1) }
    )),

    -- usepackage
    s({ trig = "pkg", snippetType = "autosnippet" }, fmta(
        "\\usepackage{<>}",
        { i(1) }
    )),

    -- integrals
    s({ trig = "dint", snippetType = "autosnippet" }, fmta(
        "\\int_{<>}^{<>}",
        { i(1), i(2) }
    )),

    -- subscript
    s({ trig = "([a-zA-Z])(%d)", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, fmta(
        "<>_<>",
        { f(function(_, snip) return snip.captures[1] end), f(function(_, snip) return snip.captures[2] end) }
    )),
    s({ trig = "([a-zA-Z]+)_", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, fmta(
        "<>_{<>}",
        { f(function(_, snip) return snip.captures[1] end), i(1) }
    )),

    -- superscript
    s({ trig = "([a-zA-Z]+)^", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, fmta(
        "<>^{<>}",
        { f(function(_, snip) return snip.captures[1] end), i(1) }
    )),

    -- fraction
    s({ trig = "//", snippetType = "autosnippet" }, fmta(
        "\\frac{<>}{<>}",
        { i(1), i(2) }
    )),
    s({
        trig = "",
        trigEngine = function(_, _2)
            return function(line_to_cursor, _)
                local len = string.len(line_to_cursor)

                if string.sub(line_to_cursor, len, len) ~= "/" then
                    return nil
                end

                local opened_parens = 0
                local idx = len - 1
                while idx >= 1 do
                    local c = string.sub(line_to_cursor, idx, idx)

                    if c == " " then
                        break
                    end

                    if c == "}" then
                        opened_parens = opened_parens + 1
                    elseif c == "{" then
                        opened_parens = opened_parens - 1
                    end

                    if opened_parens < 0 then
                        break
                    end

                    idx = idx - 1
                end

                if idx == len - 1 then
                    return nil
                end

                return string.sub(line_to_cursor, idx + 1, len), {
                    string.sub(line_to_cursor, idx + 1, len - 1),
                }
            end
        end,
        snippetType = "autosnippet"
    }, fmta(
        "\\frac{<>}{<>}",
        { f(function(_, snip) return snip.captures[1] end), i(1) }
    )),

    -- degrees
    s({ trig = "([%d%}%) ])deg", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, fmta(
        "<>^{\\circ}",
        { f(function(_, snip) return snip.captures[1] end) }
    )),

    -- text
    s({ trig = "tno", snippetType = "autosnippet" }, fmta(
        "\\text{<>}",
        { i(1) }
    )),

    -- texttt
    s({ trig = "tmo", snippetType = "autosnippet" }, fmta(
        "\\texttt{<>}",
        { i(1) }
    )),

    -- vector component form
    s({ trig = "<>", snippetType = "autosnippet" }, fmta(
        "\\langle <> \\rangle",
        { i(1) }
    )),

    -- units
    s({ trig = "unit" }, fmta("\\; {<>}", { i(1) })),
    s({ trig = "sec" }, t("\\; s")),
    s({ trig = "meters" }, t("\\; m")),
    s({ trig = "velocity" }, t("\\; {m/s}")),
    s({ trig = "acceleration" }, t("\\; {m/s}^2")),

    -- vertical spacing
    s({ trig = "vsp", snippetType = "autosnippet" }, fmta("\\vspace{<>}", { i(1) })),

    -- sqrt
    s({ trig = "sqrt", snippetType = "autosnippet" }, fmta("\\sqrt{<>}", { i(1) })),

    -- emphasis
    s({ trig = "*E", snippetType = "autosnippet" }, fmta("\\emph{<>}", { i(1) })),

    -- del
    s({ trig = "del" }, t("\\nabla")),

    -- therefore symbol
    s({ trig = "\\there", snippetType = "autosnippet" }, t("\\therefore")),

    s({ trig = "\\*", snippetType = "autosnippet" }, t("\\cdot ")),

    -- ensure space exists after closing }, $ or any common operations
    s({
        trig = "",
        snippetType = "autosnippet",
        trigEngine = function(_, _2)
            return function(line_to_cursor, _)
                local len = string.len(line_to_cursor)

                if len < 2 then
                    return nil
                end

                local current = string.sub(line_to_cursor, len, len)
                if current == " " then
                    return nil
                end

                local prev = string.sub(line_to_cursor, len-1, len-1)
                if
                    prev ~= "$" and
                    prev ~= "}" and
                    prev ~= "+" and
                    prev ~= "-" and
                    prev ~= "*" and
                    prev ~= "/" and
                    prev ~= "%"
                then
                    return nil
                end

                -- this ensures you don't start off with a space in front of every $$ in most cases
                if prev == "$" then
                    -- case: $$
                    if current == "$" then
                        return nil
                    -- case: <whitespace>$<non-space>
                    elseif len > 2 then
                        local prevprev = string.sub(line_to_cursor, len-2, len-2)
                        if prevprev == " " then
                            return nil
                        end
                    -- case: <start of line>$<non-space>
                    else
                        return nil
                    end
                end

                return current, { current }
            end
        end
    }, f(function(_, snip) return " " .. snip.captures[1] end))
}
