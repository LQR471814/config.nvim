local ls = require("luasnip")
local s = require("lqr471814.lib").latex_snippet
local t = ls.text_node

local mapping = {
    a = "alpha",
    b = "beta",
    g = "gamma",
    G = "Gamma",
    d = "delta",
    D = "Delta",
    e = "epsilon",
    z = "zeta",
    h = "eta",
    th = "theta",
    Th = "Theta",
    i = "iota",
    k = "kappa",
    l = "lambda",
    L = "Lambda",
    m = "mu",
    n = "nu",
    x = "xi",
    X = "Xi",
    oi = "omicron",
    pi = "pi",
    PI = "Pi",
    ph = "phi",
    Ph = "Phi",
    r = "rho",
    s = "sigma",
    S = "Sigma",
    ta = "tau",
    u = "upsilon",
    U = "Upsilon",
    c = "chi",
    ps = "psi",
    Ps = "Psi",
    w = "omega",
    W = "Omega",
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
end

return result
