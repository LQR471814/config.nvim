local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s({ trig = "document" }, fmt([[
		<!doctype html>
		<html lang="en">
		<head>
		  <meta charset="utf-8">
		  <meta name="viewport" content="width=device-width, initial-scale=1">
		  <title>{}</title>
		</head>

		<body>
		  {}
		</body>
		</html>
    ]], {
		i(1, ""),
		i(2, "")
	})),
}
