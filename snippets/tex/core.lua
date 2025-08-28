local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep
local s = require("lqr471814.lib").latex_snippet

return {
    -- \documentclass
    s({ trig = "article" }, fmta([[
        \documentclass[a4paper, 12pt]{article}

        \usepackage{myconfig}

        \begin{document}

        \title{<>}
        \author{<>}
        \maketitle
        \tableofcontents

        <>

        \end{document}
    ]], {
        i(1),
        i(2),
        i(3),
    })),

    s({ trig = "standalone" }, fmta([[
        \documentclass[border=1pt]{standalone}

        \numberwithin{equation}{}
        \usepackage{myconfig}

        \begin{document}

        \begin{equation}
          <>
        \end{equation}

        \end{document}
    ]], {
        i(1)
    })),

    s({ trig = "homework" }, fmta([[
        \documentclass[a4paper, 12pt]{article}

        \setlength{\parindent}{0pt}
        \setcounter{secnumdepth}{0}

        \begin{document}

        <>

        \end{document}
    ]], {
        i(1)
    })),

    -- set notation {}
    s({ trig = "\\{", wordTrig = false, snippetType = "autosnippet" }, fmta(
        "\\{<>\\}",
        { i(1) }
    )),

    -- {, [, (
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
    s({ trig = "~!@", snippetType = "autosnippet" }, fmta(
        [[
            \stdbox{
              \subsection{<>}
              \vspace{1mm}
              <>
            }
        ]],
        { i(1), i(2) }
    )),
    s({ trig = "!@", snippetType = "autosnippet" }, fmta(
        "\\subsection{<>}",
        { i(1) }
    )),
    s({ trig = "~!#", snippetType = "autosnippet" }, fmta(
        [[
            \stdbox{
              \subsubsection{<>}
              \vspace{1mm}
              <>
            }
        ]],
        { i(1), i(2) }
    )),
    s({ trig = "!#", snippetType = "autosnippet" }, fmta(
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

                    -- ensure that fraction numerators don't end up consuming the inline math delimiter
                    if c == "$" then
                        if idx == 1 then
                            break
                        end

                        local before = string.sub(line_to_cursor, idx - 1, idx - 1)
                        -- don't break if $ is escaped
                        if before ~= "\\" then
                            break
                        end
                    end

                    -- ensure stopping at whitespace doesn't break any parenthesis
                    if c == " " and opened_parens == 0 then
                        break
                    end

                    if c == "}" or c == ")" then
                        opened_parens = opened_parens + 1
                    elseif c == "{" or c == "(" then
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

    -- vector variable
    s({ trig = "([a-zA-Z])>", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, fmta(
        "\\vec{<>}<>",
        { f(function(_, snip) return snip.captures[1] end), i(1) }
    )),

    -- vector component form
    s({ trig = "<>", snippetType = "autosnippet" }, fmta(
        "\\langle <> \\rangle",
        { i(1) }
    )),

    -- units
    s({ trig = "\\deg", regTrig = true, wordTrig = false, snippetType = "autosnippet" }, fmta(
        "<>^{\\circ}",
        { f(function(_, snip) return snip.captures[1] end) }
    )),
    s({ trig = "unit" }, fmta("\\; \\text{<>", { i(1) })),
    s({ trig = "sec" }, t("\\; \\text{s}")),
    s({ trig = "meters" }, t("\\; \\text{m}")),
    s({ trig = "velocity" }, t("\\; \\text{m/s}")),
    s({ trig = "acceleration" }, t("\\; \\text{m/s}^2")),

    -- vertical spacing
    s({ trig = "vsp", snippetType = "autosnippet" }, fmta("\\vspace{<>}", { i(1) })),

    -- sqrt
    s({ trig = "sqrt", snippetType = "autosnippet" }, fmta("\\sqrt{<>}", { i(1) })),

    -- emphasis
    s({ trig = "*E", wordTrig = false, snippetType = "autosnippet" }, fmta("\\emph{<>}", { i(1) })),

    -- math double bold
    s({ trig = "*B", wordTrig = false, snippetType = "autosnippet" }, fmta("\\mathbb{<>}", { i(1) })),

    -- del
    s({ trig = "del" }, t("\\nabla")),

    -- therefore symbol
    s({ trig = "\\there", snippetType = "autosnippet" }, t("\\therefore")),

    s({ trig = "\\*", snippetType = "autosnippet" }, t("\\cdot ")),

    -- ensure space exists after closing }, $, %, = or any common operations
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
                if
                    current == " " or
                    not string.match(current, "%w")
                then
                    return nil
                end

                local prev = string.sub(line_to_cursor, len - 1, len - 1)
                if
                    prev ~= "$" and
                    prev ~= "}" and
                    prev ~= "%" and
                    prev ~= "="
                then
                    return nil
                end

                -- this ensures you don't put a space in $<here>$ and instead only out $$<here>
                if prev == "$" then
                    local count = 0
                    local idx = 1
                    while idx < len do
                        if string.sub(line_to_cursor, idx, idx) == "$" then
                            count = count + 1
                        end
                        idx = idx + 1
                    end

                    -- if the current $ is unclosed in the text up to the cursor
                    -- don't add a space after the $
                    if count % 2 ~= 0 then
                        return nil
                    end
                end

                return current, { current }
            end
        end
    }, f(function(_, snip) return " " .. snip.captures[1] end)),

    -- item
    s({ trig = "--", snippetType = "autosnippet" }, t("\\item")),

    -- %
    s({ trig = "%", wordTrig = false, snippetType = "autosnippet" }, t("\\%")),

    -- triple equals
    s({ trig = "&==", snippetType = "autosnippet" }, t("\\equiv")),

    -- &=
    s({ trig = "==", snippetType = "autosnippet" }, t("&=")),

    -- overline
    s(
        { trig = "^_", wordTrig = false, snippetType = "autosnippet" },
        fmta("\\overline{<>}", { i(1) })
    ),
    -- <->
    s(
        { trig = "<->", snippetType = "autosnippet" },
        t("\\leftrightarrow")
    ),
    -- ->
    s(
        { trig = "->", snippetType = "autosnippet" },
        t("\\to")
    ),
}
