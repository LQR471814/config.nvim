local ls = require("luasnip")
local s = ls.snippet
local fmta = require("luasnip.extras.fmt").fmta

return {
	s({ trig = "pyright uv lsp" }, fmta([[
		[tool.pyright]
		venvPath = "."
		venv = ".venv"
    ]], {})),
}
