vim.g.mapleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true

local function setIndent(files, size, tabs)
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = files,
        callback = function()
            if tabs then
                vim.opt.tabstop = size
                vim.opt.shiftwidth = size
                vim.opt.expandtab = false
            else
                vim.opt.tabstop = 8
                vim.opt.softtabstop = size
                vim.opt.shiftwidth = size
                vim.opt.expandtab = true
            end
        end
    })
end

setIndent({
    "*.yaml",
    "*.dart",
    "*.proto",
    "*.nix",
    "*.tex",
    "*.sty"
}, 2)
setIndent({
    "*.rs",
    "*.py",
    "*.lua",
    "*.sh",
    "Dockerfile*",
    "*.html",
    "*.cpp",
    "*.c",
    "*.xml",
    "*.sql",
    "*.java",
    "*.toml",
}, 4)
setIndent({
    "*.json",
    "*.jsx",
    "*.ts",
    "*.tsx",
    "*.svelte",
    "*.js",
    "*.css",
    "*.go",
    "*.templ",
    "Makefile*",
    "*.json5",
    "*.cu",
    "*.cpp",
    "*.hpp",
    "*.c",
    "*.h",
    "*.conf",
    "*.md"
}, 4, true)

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.g.mapleader = " "
vim.g.maplocalleader = "'"

vim.opt.autoread = true

vim.keymap.set("n", "gy", "\"+y")
vim.keymap.set("v", "gy", "\"+y")
vim.keymap.set("n", "gyy", "\"+Y")
vim.keymap.set("n", "gyp", "let @\" = expand(\"%\")")

vim.keymap.set("n", "gp", "\"+p")
vim.keymap.set("v", "gp", "\"+p")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set({ "n", "v", "i", "x" }, "<C-z>", "<nop>")

vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>")
vim.keymap.set("n", "<leader>z", "<CMD>Limelight!!<CR><CMD>SoftWrapMode<CR>")

vim.g.vimtex_view_method = "zathura"
vim.g.tex_flavor = "latex"
vim.opt.conceallevel = 1
vim.opt.title = true
vim.g.tex_conceal = "abdmg"
vim.g.vimtex_compiler_latexmk = {
    out_dir = "",
}
vim.g.vimtex_doc_enabled = false
vim.g.vimtex_imaps_enabled = false
vim.o.breakindent = true

vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_set_keymap('i', '<M-s>', '<Esc>:w<CR>a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<M-s>', '<Esc>:w<CR>gv', { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en"
        vim.keymap.set({ "n", "i" }, "<C-;>", "<ESC>[s1z=`]a")
    end
})
