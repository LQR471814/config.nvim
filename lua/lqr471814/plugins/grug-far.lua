return {
	"MagicDuck/grug-far.nvim",
	-- lazy loading not necessary
	config = function()
		require("grug-far").setup({});

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "grug-far",
			callback = function()
				vim.opt_local.expandtab = true
				vim.opt_local.tabstop = 2
				vim.opt_local.shiftwidth = 2
			end
		})
	end
}
