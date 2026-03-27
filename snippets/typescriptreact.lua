local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
	s({ trig = "imp" }, fmta([[import <> from "<>"]], {
		i(1),
		i(2),
	})),
}
