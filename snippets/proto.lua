local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
    s("reqres", fmta(
        [[
        // <>
        message <>Request {
          <>
        }
        message <>Response {
          <>
        }
        ]],
        {
            i(1),
            rep(1),
            i(2),
            rep(1),
            i(3)
        }
    )),
    s("rpc", fmta(
        "rpc <>(<>Request) returns (<>Response);",
        {
            i(1),
            rep(1),
            rep(1),
        }
    )),
}
