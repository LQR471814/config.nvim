local Mathzone = require("lqr471814.lib.mathzone")
local Wrap = require("lqr471814.lib.wrap")

local function in_mathzone()
	return Mathzone:in_mathzone()
end

local function latex_snippet(context, nodes, opts)
	local ls = require("luasnip")
	context.condition = in_mathzone
	context.show_condition = in_mathzone
	return ls.snippet(context, nodes, opts)
end

return {
	latex_snippet = latex_snippet,
	in_mathzone = in_mathzone,
	wrap = Wrap,
}
