local Mathzone = require("lqr471814.lib.mathzone")
local Wrap = require("lqr471814.lib.wrap")
local Telescope = require("lqr471814.lib.telescope")
local Keymap = require("lqr471814.lib.keymap")

local function latex_snippet(context, nodes, opts)
	local cond = Mathzone.in_mathzone
	if context.all_zones_tex then
		cond = Mathzone.all_zones_tex
	elseif context.outside_latex then
		cond = Mathzone.outside_mathzone_tex
	end

	local ls = require("luasnip")
	context.condition = cond
	context.show_condition = cond
	return ls.snippet(context, nodes, opts)
end

return {
	latex_snippet = latex_snippet,
	in_mathzone = Mathzone.in_mathzone,
	wrap = Wrap,
	telescope = Telescope,
	keymap = Keymap,
}
