return {
	'Julian/lean.nvim',
	event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"saghen/blink.cmp",
	},
}
