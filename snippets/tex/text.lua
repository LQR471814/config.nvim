local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta
local latex_snippet = require("lqr471814.lib").latex_snippet

local function s(opts, body)
    opts.outside_latex = true
    return latex_snippet(opts, body)
end

return {
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
    s({ trig = "aligned" }, fmta(
        [[
        \[
        \begin{aligned}
          <>
        \end{aligned}
        \]
        ]],
        { i(1) }
    )),

    -- \begin \end
    ls.snippet({ trig = "beg", snippetType = "autosnippet" }, fmta(
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
        \usepackage{myconfig}

        \begin{document}

        <>

        \end{document}
    ]], {
        i(1)
    })),

    -- usepackage
    s({ trig = "pkg", snippetType = "autosnippet" }, fmta(
        "\\usepackage{<>}",
        { i(1) }
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

    -- vertical spacing
    s({ trig = "vsp", snippetType = "autosnippet" }, fmta("\\vspace{<>}", { i(1) })),

    -- emphasis
    s({ trig = "*E", wordTrig = false, snippetType = "autosnippet" }, fmta("\\emph{<>}", { i(1) })),

    -- item
    s({ trig = "--", snippetType = "autosnippet" }, t("\\item")),

    -- % (applies to both math and normal)
    s({ trig = "%", wordTrig = false, snippetType = "autosnippet", all_zones_tex = true }, t("\\%")),

    -- comment
    s({ trig = "comment" }, t("% ")),

    -- todos
    s({ trig = "todo" }, t("% TODO: ")),

    -- table
    s({ trig = "table" }, fmta(
        [[
            \begin{table}[h]
                \centering
                \begin{tabular}{<>}
                    \hline
                    <>
                \end{tabular}
                \caption{<>}
                \label{<>}
            \end{table}
        ]],
        { i(1), i(2), i(3), i(4) }
    )),

    -- image
    s({ trig = "image" }, fmta(
        [[\includegraphics[width=\linewidth]{<>}]],
        { i(1) }
    )),

}
