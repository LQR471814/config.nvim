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
vim.keymap.set("n", "<leader>w", "m'gqap`'")
vim.keymap.set("n", "<leader>pv", function() vim.cmd("Oil") end)

local lib = require("lqr471814.lib")
vim.keymap.set("n", "<leader>z", function()
    lib.wrap:toggle("soft")
end)
vim.keymap.set("n", "<leader>Z", function()
    lib.wrap:toggle("hard")
end)

vim.keymap.set('n', "<leader>re", ":GrugFar<cr>")

vim.keymap.set('n', '<leader>h', function()
    Snacks.notifier.show_history()
end)

vim.keymap.set('n', "<leader>l", function()
    Snacks.lazygit.open()
end)

-- telescope

vim.keymap.set("n", "<leader>pf", function()
    require("telescope.builtin").find_files({
        find_command = { 'fd', '--type', 'file', '--hidden', '-E', '.git', '-E', '.treesitter' },
    })
end, {})
vim.keymap.set("n", "<leader>ps", function()
    local target = vim.fn.input("grep > ")
    require("telescope.builtin").grep_string({
        search = target,
        additional_args = { "--iglob", "!.{git,treesitter}", "--hidden" }
    })
end, {})
vim.keymap.set("n", "<leader>pg", function()
    require("telescope.builtin").git_files()
end)
vim.keymap.set("n", "<leader>pb", function()
    require("telescope.builtin").buffers()
end)
vim.keymap.set("n", "<leader>pl", function()
    require("telescope.builtin").live_grep()
end)
vim.keymap.set("n", "<leader>pe", function()
    require("telescope.builtin").diagnostics()
end)
vim.keymap.set({ "n", "v" }, "<leader>pc", function()
    require("telescope.builtin").commands()
end)
vim.keymap.set("n", "<leader>ph", function()
    require("telescope.builtin").help_tags()
end)

-- bufferline

vim.keymap.set("n", "g.", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set("n", "g,", "<cmd>BufferLineCyclePrev<cr>")
vim.keymap.set("n", "<leader>w", "<cmd>bd<cr>")
vim.keymap.set("n", "<leader>W", "<cmd>bd!<cr>")
vim.keymap.set("n", "<leader>pt", "<cmd>BufferLinePick<cr>")
