return {
	'4e554c4c/darkman.nvim',
	event = 'VimEnter',
	build = 'go build -o bin/darkman.nvim',
	opts = {
		colorscheme = {
			dark = "kanagawa-paper-ink",
			light = "dayfox"
		}
	},
}
