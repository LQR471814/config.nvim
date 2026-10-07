local ls = require("luasnip")
local t = ls.text_node
local latex_snippet = require("lqr471814.lib").latex_snippet

local function s(opts, body)
    opts.in_tex_and_inside_mathzone = true
    return latex_snippet(opts, body)
end

local mapping = {
    fa = "forall",
    t = "therefore",
    u = "underset",
    e = "exists",
    ["c"] = "cdot",
    ["o"] = "circ",
}
local result = {}

local i = 1
for key, value in pairs(mapping) do
    result[i] = s(
        {
            trig = ";" .. key,
            snippetType = "autosnippet",
            wordTrig = false,
        },
        {
            t("\\" .. value)
        }
    )
    i = i + 1
end

return result
