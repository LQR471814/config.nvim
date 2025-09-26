local keymap = require("lqr471814.lib.keymap")

vim.g.mapleader = " "

-- clipboard settings

keymap:map("v", "gy", "\"+y", "Copy visual selection text to system clipboard.")
keymap:map("n", "gyy", "\"+Y", "Copy current line to system clipboard.")

keymap:map("n", "gyp", function()
    local dir = vim.fn.expand("%:p")
    vim.fn.setreg("+", dir)
    vim.notify("Copied file path to clipboard.")
end, "Copy current file path to clipboard.")
keymap:map("n", "gyd", function()
    local dir = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", dir)
    vim.notify("Copied directory to clipboard.")
end, "Copy current directory to clipboard.")
keymap:map("n", "gy'", function() -- add quotes to whatever is in the clipboard
    local value = vim.fn.getreg("+")
    vim.fn.setreg("+", string.format([["%s"]], value:sub(0, #value - 1)))
    vim.notify("Quoted clipboard.")
end, "Surround current clipboard content with quotes.")

local function paste_from_clipboard()
    local clipboard = vim.fn.getreg("+")
    clipboard = clipboard:gsub("^[\t\n ]+", "")
    clipboard = clipboard:gsub("[\t\n ]+$", "")
    vim.api.nvim_paste(clipboard, false, -1)
end

keymap:map("n", "gp", paste_from_clipboard, "Paste from clipboard.")
keymap:map("v", "gp", paste_from_clipboard, "Paste from clipboard.")

-- avoid keybind typos
keymap:overwrite_map("n", "Q", "<nop>")
vim.api.nvim_create_user_command("W", "w", {})

keymap:overwrite_map({ "n", "v", "i", "x" }, "<C-z>", "<nop>")
keymap:map("n", "<leader>w", "m'gwap`'", "Apply hard wrapping on current paragraph.")
keymap:map("n", "<leader>pv", "<cmd>Oil<cr>", "Open file explorer.")

local lib = require("lqr471814.lib")
keymap:map("n", "<leader>z", function()
    lib.wrap:toggle("soft")
end, "Toggle soft wrapping.")
keymap:map("n", "<leader>Z", function()
    lib.wrap:toggle("hard")
end, "Toggle hard wrapping.")

keymap:map("n", "<leader>re", "<cmd>GrugFar<cr>", "Open grug-far (find-and-replace).")

keymap:map("n", "<leader>h", function()
    Snacks.notifier.show_history()
end, "Show notification history.")

keymap:map("n", "<leader>l", function()
    Snacks.lazygit.open()
end, "Open lazygit (git).")

-- telescope

keymap:map("n", "<leader>pf", function()
    require("telescope.builtin").find_files({
        find_command = { "fd", "--type", "file", "--hidden", "-E", ".git", "-E", ".treesitter" },
    })
end, "Fuzzy-find files by filename.")
keymap:map("n", "<leader>ps", function()
    local target = vim.fn.input("grep > ")
    require("telescope.builtin").grep_string({
        search = target,
        additional_args = { "--iglob", "!.{git,treesitter}", "--hidden" }
    })
end, "Find files via text content.")
keymap:map("n", "<leader>pg", function()
    require("telescope.builtin").git_files()
end, "Fuzzy-find files in the git working tree.")
keymap:map("n", "<leader>o", lib.telescope.buffers, "Fuzzy-find open buffers.")
keymap:map("n", "<leader>pl", function()
    require("telescope.builtin").live_grep()
end, "Fuzzy-find files via text content (live grep).")
keymap:map("n", "<leader>pe", function()
    require("telescope.builtin").diagnostics()
end, "Fuzzy-find diagnostics.")
keymap:map({ "n", "v" }, "<leader>pc", function()
    require("telescope.builtin").commands()
end, "Fuzzy-find commands.")
keymap:map("n", "<leader>ph", function()
    require("telescope.builtin").help_tags()
end, "Fuzzy-find help entries.")

keymap:map("n", "<leader>q", "<cmd>bd<cr>", "Close the current buffer.")
keymap:map("n", "<leader>Q", "<cmd>bd!<cr>", "Close the current buffer without saving.")

-- wrap
keymap:map("n", "gq", "gw", "Wrap lines.")
keymap:map("n", "gqq", "gww", "Wrap lines.")
keymap:map("v", "gq", "gw", "Wrap visual selection.")
