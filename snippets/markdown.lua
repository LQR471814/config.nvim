local ls = require('luasnip')
local s = ls.snippet
local fmta = require('luasnip.extras.fmt').fmta

return {
    s({ trig = "chk" }, fmta("[ ] ", { })),
}
