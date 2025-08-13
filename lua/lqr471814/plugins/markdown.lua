return {
	{
		"iurimateus/luasnip-latex-snippets.nvim",
		ft = { "markdown", "tex", "norg" },
		config = function()
			require("luasnip-latex-snippets").setup({
				use_treesitter = true
			})

			local ls = require("luasnip")
			local utils = require("luasnip-latex-snippets.util.utils")
			local fmta = require("luasnip.extras.fmt").fmta

			local snip = ls.snippet({ trig = "dm", snippetType = "autosnippet" }, fmta([[
				$$
				<>
				$$
			]], { ls.insert_node(1) }))

			local not_math = utils.pipe({ utils.with_opts(utils.not_math, true) })
			snip.condition = not_math
			snip.priority = 10

			ls.add_snippets("markdown", { snip }, {
				type = "autosnippets",
			})
		end,
	},
	{
		"dhruvasagar/vim-table-mode",
		ft = "markdown",
	},
	{
		"gaoDean/autolist.nvim",
		ft = {
			"markdown",
			"text",
			"tex",
			"plaintex",
			"norg",
		},
		config = function()
			require("autolist").setup()
		end
	}
    -- sc-im support
    -- {
    --     "DAmesberger/sc-im.nvim",
    --     event = "VeryLazy",
    --     config = function()
    --         local scim = require("sc-im")
    --         vim.keymap.set("n", "<leader>to", function()
    --             scim.open_in_scim()
    --         end, { noremap = true, silent = true })
    --         vim.keymap.set("n", "<leader>tr", function()
    --             scim.rename()
    --         end, { noremap = true, silent = true })
    --     end
    -- },
}
