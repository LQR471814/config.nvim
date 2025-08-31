vim.g.mapleader = " "

vim.keymap.set("n", "gy", "\"+y")
vim.keymap.set("v", "gy", "\"+y")
vim.keymap.set("n", "gyy", "\"+Y")

vim.keymap.set("n", "gyp", function()
    local dir = vim.fn.expand("%:p")
    vim.fn.setreg("+", dir)
    vim.notify("Copied file path to clipboard.")
end)
vim.keymap.set("n", "gyd", function()
    local dir = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", dir)
    vim.notify("Copied directory to clipboard.")
end)
vim.keymap.set("n", "gy'", function() -- add quotes to whatever is in the clipboard
    local value = vim.fn.getreg("+")
    vim.fn.setreg("+", string.format([["%s"]], value:sub(0, #value - 1)))
    vim.notify("Quoted clipboard.")
end)

local function paste_from_clipboard()
    local clipboard = vim.fn.getreg("+")
    clipboard = clipboard:gsub("^[\t\n ]+", "")
    clipboard = clipboard:gsub("[\t\n ]+$", "")
    vim.api.nvim_paste(clipboard, false, -1)
end

vim.keymap.set("n", "gp", paste_from_clipboard)
vim.keymap.set("v", "gp", paste_from_clipboard)

-- avoid keybind typos
vim.keymap.set("n", "Q", "<nop>")
vim.api.nvim_create_user_command('W', 'w', {})

vim.keymap.set({ "n", "v", "i", "x" }, "<C-z>", "<nop>")
vim.keymap.set("n", "<leader>w", "gqap")
vim.keymap.set("n", "<leader>pv", function() vim.cmd("Oil") end)

vim.keymap.set("n", "<leader>z", function()
    local wrapping = require('wrapping')
    wrapping.toggle_wrap_mode()
    vim.notify("Toggled wrap mode. Current: " .. wrapping.get_current_mode())
end)

vim.keymap.set("n", "<leader>Z", function()
    if vim.opt.textwidth:get() > 0 then
        vim.opt.textwidth = 0
        vim.notify("Hard wrapping off.")
    else
        vim.opt.textwidth = 66
        vim.notify("Hard wrapping on.")
    end
end)

vim.keymap.set('n', "<leader>re", ":GrugFar<cr>")

vim.keymap.set('i', '<Esc>', function()
    local luasnip = require('luasnip')
    if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] then
        luasnip.unlink_current()
    end
    return '<Esc>'
end, { expr = true })

vim.keymap.set('n', '<leader>h', function()
    Snacks.notifier.show_history()
end)

vim.keymap.set('n', "<leader>l", function()
    Snacks.lazygit.open()
end)

