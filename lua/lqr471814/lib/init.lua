local Mathzone = require("lqr471814.lib.mathzone")
local Wrap = require("lqr471814.lib.wrap")
local Keymap = require("lqr471814.lib.keymap")

local function latex_snippet(context, nodes, opts)
	local cond = context.condition

	local guard = Mathzone.in_mathzone
	if context.all_zones_tex then
		guard = Mathzone.all_zones_tex
	elseif context.outside_latex then
		guard = Mathzone.outside_mathzone_tex
	end

	local wrapped = function()
		if not guard() then
			return false
		end
		if cond ~= nil then
			return cond()
		end
		return true
	end
	context.condition = wrapped
	context.show_condition = wrapped

	local ls = require("luasnip")
	return ls.snippet(context, nodes, opts)
end

return {
	latex_snippet = latex_snippet,
	in_mathzone = Mathzone.in_mathzone,
	wrap = Wrap,
	keymap = Keymap,
}
