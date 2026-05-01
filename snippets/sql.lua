local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
	s({ trig = "on cascade" }, t("on update cascade on delete cascade")),
}
