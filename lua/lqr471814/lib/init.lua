local Mathzone = require("lqr471814.lib.mathzone")
local Wrap = require("lqr471814.lib.wrap")
local Telescope = require("lqr471814.lib.telescope")
local Keymap = require("lqr471814.lib.keymap")

local function latex_snippet(context, nodes, opts)
	local ls = require("luasnip")
	context.condition = Mathzone.in_mathzone
	context.show_condition = Mathzone.in_mathzone
	return ls.snippet(context, nodes, opts)
end

return {
	latex_snippet = latex_snippet,
	in_mathzone = Mathzone.in_mathzone,
	wrap = Wrap,
	telescope = Telescope,
	keymap = Keymap,
}
