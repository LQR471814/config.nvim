return {
	"andymass/vim-matchup",
	event = "VeryLazy",
	init = function()
		vim.g.matchup_matchparen_offscreen = { method = "popup" }
	end,
	---@type matchup.Config
	opts = {
		treesitter = {
			stopline = 1500,
		}
	}
}
