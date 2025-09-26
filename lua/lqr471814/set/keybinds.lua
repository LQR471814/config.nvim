vim.g.mapleader = " "

local opts = { noremap = true, silent = true, unique = true }

-- clipboard settings

vim.keymap.set("n", "gy", "\"+y", opts)
vim.keymap.set("v", "gy", "\"+y", opts)
vim.keymap.set("n", "gyy", "\"+Y", opts)

vim.keymap.set("n", "gyp", function()
    local dir = vim.fn.expand("%:p")
    vim.fn.setreg("+", dir)
    vim.notify("Copied file path to clipboard.")
end, opts)
vim.keymap.set("n", "gyd", function()
    local dir = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", dir)
    vim.notify("Copied directory to clipboard.")
end, opts)
vim.keymap.set("n", "gy'", function() -- add quotes to whatever is in the clipboard
    local value = vim.fn.getreg("+")
    vim.fn.setreg("+", string.format([["%s"]], value:sub(0, #value - 1)))
    vim.notify("Quoted clipboard.")
end, opts)

local function paste_from_clipboard()
    local clipboard = vim.fn.getreg("+")
    clipboard = clipboard:gsub("^[\t\n ]+", "")
    clipboard = clipboard:gsub("[\t\n ]+$", "")
    vim.api.nvim_paste(clipboard, false, -1)
end

vim.keymap.set("n", "gp", paste_from_clipboard, opts)
vim.keymap.set("v", "gp", paste_from_clipboard, opts)

-- avoid keybind typos
vim.keymap.set("n", "Q", "<nop>", opts)
vim.api.nvim_create_user_command("W", "w", {})

vim.keymap.set({ "n", "v", "i", "x" }, "<C-z>", "<nop>", opts)
vim.keymap.set("n", "<leader>w", "m'gwap`'", opts)
vim.keymap.set("n", "<leader>pv", "<cmd>Oil<cr>", opts)

local lib = require("lqr471814.lib")
vim.keymap.set("n", "<leader>z", function()
    lib.wrap:toggle("soft")
end, opts)
vim.keymap.set("n", "<leader>Z", function()
    lib.wrap:toggle("hard")
end, opts)

vim.keymap.set("n", "<leader>re", "<cmd>GrugFar<cr>", opts)

vim.keymap.set("n", "<leader>h", function()
    Snacks.notifier.show_history()
end, opts)

vim.keymap.set("n", "<leader>l", function()
    Snacks.lazygit.open()
end, opts)

-- telescope

vim.keymap.set("n", "<leader>pf", function()
    require("telescope.builtin").find_files({
        find_command = { "fd", "--type", "file", "--hidden", "-E", ".git", "-E", ".treesitter" },
    })
end, opts)
vim.keymap.set("n", "<leader>ps", function()
    local target = vim.fn.input("grep > ")
    require("telescope.builtin").grep_string({
        search = target,
        additional_args = { "--iglob", "!.{git,treesitter}", "--hidden" }
    })
end, opts)
vim.keymap.set("n", "<leader>pg", function()
    require("telescope.builtin").git_files()
end, opts)
vim.keymap.set("n", "<leader>o", lib.telescope.buffers, opts)
vim.keymap.set("n", "<leader>pl", function()
    require("telescope.builtin").live_grep()
end, opts)
vim.keymap.set("n", "<leader>pe", function()
    require("telescope.builtin").diagnostics()
end, opts)
vim.keymap.set({ "n", "v" }, "<leader>pc", function()
    require("telescope.builtin").commands()
end, opts)
vim.keymap.set("n", "<leader>ph", function()
    require("telescope.builtin").help_tags()
end, opts)

-- bufferline

vim.keymap.set("n", "g.", "<cmd>BufferLineCycleNext<cr>", opts)
vim.keymap.set("n", "g,", "<cmd>BufferLineCyclePrev<cr>", opts)
vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>", opts)
vim.keymap.set("n", "<leader>Q", "<cmd>bd!<cr>", opts)
vim.keymap.set("n", "<leader>pt", "<cmd>BufferLinePick<cr>", opts)

-- wrap
vim.keymap.set("n", "gq", "gw", opts)
vim.keymap.set("n", "gqq", "gww", opts)
vim.keymap.set("v", "gq", "gw", opts)
