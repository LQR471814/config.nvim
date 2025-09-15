local ls = require('luasnip')
local s = require("lqr471814.lib").latex_snippet
local t = ls.text_node

local mapping = {
    fa = "forall",
    t = "therefore",
    u = "underset",
    e = "exists"
}
local result = {}

local i = 1
for key, value in pairs(mapping) do
    result[i] = s(
        {
            trig = ";" .. key,
            snippetType = "autosnippet"
        },
        {
            t("\\" .. value)
        }
    )
    i = i + 1
end

return result
