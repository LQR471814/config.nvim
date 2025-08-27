local ls = require('luasnip')

local function in_mathzone(line_to_cursor, matched_trigger, captures)
	if vim.bo.filetype == "tex" then
		return true
	end
	return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

local function latex_snippet(context, nodes, opts)
	context.condition = in_mathzone
	context.show_condition = in_mathzone
	return ls.snippet(context, nodes, opts)
end

return {
	in_mathzone = in_mathzone,
	latex_snippet = latex_snippet,
}
