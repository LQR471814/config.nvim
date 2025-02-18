local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node

local mapping = {
    i = "item",
    fa = "forall",
    t = "therefore",
    u = "underset"
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
