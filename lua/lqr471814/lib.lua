local ls = require('luasnip')

local function in_mathzone()
	return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

local function latex_snippet(context, nodes, opts)
	context.conditional = in_mathzone
	return ls.snippet(context, nodes, opts)
end

return {
	in_mathzone = in_mathzone,
	latex_snippet = latex_snippet,
}
