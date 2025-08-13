vim.g.mapleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
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

vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
        ["+"] = "wl-copy",
        ["*"] = "wl-copy",
    },
    paste = {
        ["+"] = "wl-paste",
        ["*"] = "wl-paste",
    },
    cache_enabled = 0,
}
vim.keymap.set("n", "gy", "\"+y")
vim.keymap.set("v", "gy", "\"+y")
vim.keymap.set("n", "gyy", "\"+Y")
vim.keymap.set("n", "gyp", "let @\" = expand(\"%\")")

vim.keymap.set("n", "gp", "\"+p")
vim.keymap.set("v", "gp", "\"+p")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set({ "n", "v", "i", "x" }, "<C-z>", "<nop>")

vim.keymap.set("n", "<leader>pv", function() vim.cmd("Oil") end)

local writing_enabled = false

vim.keymap.set("n", "<leader>z", function()
    if writing_enabled then
        writing_enabled = false
    else
        writing_enabled = true
    end
    require("wrapping").soft_wrap_mode()
    vim.b.completion = not writing_enabled
end)

vim.keymap.set("n", "<leader>Z", function()
    if writing_enabled then
        writing_enabled = false
    else
        writing_enabled = true
    end
    require("wrapping").hard_wrap_mode()
    if writing_enabled then
        vim.opt.textwidth = 66
    else
        vim.opt.textwidth = 0
    end
end)

-- enable hard wrap on markdown files
vim.api.nvim_create_autocmd("BufRead", {
    pattern = { "*.md", "*.tex" },
    callback = function()
        vim.opt.textwidth = 66
        require("wrapping").hard_wrap_mode()
        vim.b.completion = false

        -- italic / bold
        vim.keymap.set('v', "<C-b>", "2<Plug>(nvim-surround-visual)*")
        vim.keymap.set('v', "<C-k>", "<Plug>(nvim-surround-visual)*")
    end
})

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

-- remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local save_cursor = vim.api.nvim_win_get_cursor(0)
        local view = vim.fn.winsaveview()

        vim.cmd([[%s/\s\+$//e]])

        vim.fn.winrestview(view)
        vim.api.nvim_win_set_cursor(0, save_cursor)
    end,
})

-- cancel snippet on escape
vim.keymap.set('i', '<Esc>', function()
    local luasnip = require('luasnip')
    if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] then
        luasnip.unlink_current()
    end
    return '<Esc>'
end, { expr = true })

-- show notification history
vim.keymap.set('n', '<leader>h', function()
    Snacks.notifier.show_history()
end)

-- show lazygit
vim.keymap.set('n', "<leader>l", function()
    Snacks.lazygit.open()
end)
