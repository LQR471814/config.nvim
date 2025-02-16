local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node

local mapping = {
    a = "alpha",
    b = "beta",
    g = "gamma",
    d = "delta",
    e = "epsilon",
    z = "zeta",
    h = "eta",
    th = "theta",
    i = "iota",
    k = "kappa",
    l = "lambda",
    m = "mu",
    n = "nu",
    x = "xi",
    oi = "omicron",
    pi = "pi",
    ph = "phi",
    r = "rho",
    s = "sigma",
    ta = "tau",
    u = "upsilon",
    c = "chi",
    ps = "psi",
    om = "omega",
}
local result = {}

local i = 1
for key, value in pairs(mapping) do
    result[i] = s(
        {
            trig = "'" .. key,
            snippetType = "autosnippet"
        },
        {
            t("\\" .. value)
        }
    )
    i = i + 1
    result[i] = s(
        {
            trig = "'" .. string.upper(key),
            snippetType = "autosnippet"
        },
        {
            t("\\" .. string.upper(string.sub(value, 0, 1)) .. string.sub(value, 2))
        }
    )
    i = i + 1
end

return result
