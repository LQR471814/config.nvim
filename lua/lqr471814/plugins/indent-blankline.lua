return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	config = function()
		require("ibl").setup({
			indent = { char = "│" },
			scope = { enabled = false },
		})

		local hooks = require("ibl.hooks")

		hooks.register(hooks.type.ACTIVE, function(bufnr)
			return vim.bo[bufnr].filetype == "yaml"
		end)
	end,
}
