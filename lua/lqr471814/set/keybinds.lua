local keymap = require("lqr471814.lib.keymap")

vim.g.mapleader = " "

-- clipboard settings

keymap.map("v", "gy", "\"+y", "Copy visual selection text to system clipboard.")
keymap.map("n", "gyy", "\"+Y", "Copy current line to system clipboard.")

keymap.map("n", "gyp", function()
    local dir = vim.fn.expand("%:p")
    vim.fn.setreg("+", dir)
    vim.notify("Copied file path to clipboard.")
end, "Copy current file path to clipboard.")
keymap.map("n", "gyd", function()
    local dir = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", dir)
    vim.notify("Copied directory to clipboard.")
end, "Copy current directory to clipboard.")
keymap.map("n", "gy'", function() -- add quotes to whatever is in the clipboard
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

keymap.map("n", "gp", paste_from_clipboard, "Paste from clipboard.")
keymap.map("v", "gp", paste_from_clipboard, "Paste from clipboard.")

-- avoid keybind typos
keymap.overwrite_map("n", "Q", "<nop>")
vim.api.nvim_create_user_command("W", "w", {})

keymap.overwrite_map({ "n", "v", "i", "x" }, "<C-z>", "<nop>")
keymap.map("n", "<leader>w", "m'gwap`'", "Apply hard wrapping on current paragraph.")
keymap.map("n", "<leader>pv", "<cmd>Oil<cr>", "Open file explorer.")

local lib = require("lqr471814.lib")
keymap.map("n", "<leader>z", function()
    lib.wrap.toggle("soft")
end, "Toggle soft wrapping.")
keymap.map("n", "<leader>Z", function()
    lib.wrap.toggle("hard")
end, "Toggle hard wrapping.")

keymap.map("n", "<leader>re", "<cmd>GrugFar<cr>", "Open grug-far (find-and-replace).")

keymap.map("n", "<leader>h", function()
    Snacks.notifier.show_history()
end, "Show notification history.")

keymap.map("n", "<leader>l", function()
    Snacks.lazygit.open()
end, "Open lazygit (git).")

-- snacks.picker

--- filesystem

default_fs_exclusion = { -- fs entries that should always be excluded
    ".git",
    ".venv",
    "node_modules",
    ".treesitter",
    '*.fls',
    '*.aux',
    '*.fdb_latexmk',
    '*.synctex.gz',
    '*.pdf_tex',
    '*.dvi',
    '*.ps',
    '*.bbl',
    '*.bcf',
    '*.blg',
    '*.out',
    '*.run.xml',
    '*.xdv',
    '*.vimtex',
    '*.db',
    '_Archived',
}

keymap.map("n", "<leader>n", function()
    Snacks.picker.explorer()
end)
keymap.map("n", "<leader>pr", function()
    Snacks.picker.smart({
        filter = { cwd = true }
    })
end, "Smart-pick by frequency.")
keymap.map("n", "<leader>pf", function()
    Snacks.picker.files({
        hidden = true,
        ignored = false, -- Snacks handles excludes via the 'exclude' table or native 'fd' logic
        exclude = default_fs_exclusion,
    })
end, "Fuzzy-find files by filename.")
keymap.map("n", "<leader>ps", function()
    Snacks.picker.grep({
        hidden = true,
        exclude = default_fs_exclusion,
    })
end, "Find files via text content.")

--- git integration

keymap.map("n", "<leader>ga", function()
    Snacks.picker.git_log()
end, "Fuzzy-find all git logs on current branch.")
keymap.map("n", "<leader>gf", function()
    Snacks.picker.git_log_file()
end, "Fuzzy-find git logs pertaining to the current file.")
keymap.map("n", "<leader>gl", function()
    Snacks.picker.git_log_file()
end, "Fuzzy-find git logs pertaining to the current line.")

--- editor

keymap.map("n", "<leader>o", function()
    Snacks.picker.buffers({
        win = {
            input = {
                keys = {
                    ["dd"] = "bufdelete"
                }
            }
        },
    })
end, "Fuzzy-find open buffers.")
keymap.map("n", "<leader>pe", function()
    Snacks.picker.diagnostics()
end, "Fuzzy-find diagnostics.")
keymap.map({ "n", "v" }, "<leader>pc", function()
    Snacks.picker.commands()
end, "Fuzzy-find commands.")
keymap.map("n", "<leader>ph", function()
    Snacks.picker.help()
end, "Fuzzy-find help entries.")
keymap.map("n", "<leader>pH", function()
    local docs = {}
    for _, p in ipairs(vim.api.nvim_list_runtime_paths()) do
        local d = p .. "/doc"
        if vim.fn.isdirectory(d) == 1 then
            table.insert(docs, d)
        end
    end
    Snacks.picker.grep({
        dirs = docs,
        glob = "*.txt",
        -- Snacks handles internal tags automatically, but we can pass extra args if needed
        args = { "--glob=!tags" },
        title = "Grep plugin help",
    })
end, "Fuzzy-find help entry content.")

--- language

keymap.map("n", "<leader>ad", function()
    Snacks.picker.lsp_declarations()
end, "Pick lsp_declarations")
keymap.map("n", "<leader>af", function()
    Snacks.picker.lsp_definitions()
end, "Pick lsp_definitions")
keymap.map("n", "<leader>aci", function()
    Snacks.picker.lsp_incoming_calls()
end, "Pick lsp_incoming_calls")
keymap.map("n", "<leader>aco", function()
    Snacks.picker.lsp_incoming_calls()
end, "Pick lsp_incoming_calls")
keymap.map("n", "<leader>ai", function()
    Snacks.picker.lsp_implementations()
end, "Pick lsp_implementations")
keymap.map("n", "<leader>pl", function()
    Snacks.picker.lsp_workspace_symbols()
end, "Pick lsp_workspace_symbols")

-- wrap
keymap.map("n", "gq", "gw", "Wrap lines.")
keymap.map("n", "gqq", "gww", "Wrap lines.")
keymap.map("v", "gq", "gw", "Wrap visual selection.")

-- tabs
keymap.map("n", "<leader>tn", "<cmd>tabnew<cr>", "New tab.")
keymap.map("n", "<leader>tq", "<cmd>tabclose<cr>", "Close tab.")
keymap.map("n", "<leader>to", "<cmd>tabonly<cr>", "Close all other tabs.")

-- to go to a specific tab use {N}gt
-- to go to a next tab use gt
-- to go to a previous tab use gT

-- diff split
local diffopen = false
keymap.map("n", "<leader>ds", function()
    if not diffopen then
        vim.cmd("windo diffthis")
    else
        vim.cmd("windo diffoff")
    end
    diffopen = not diffopen
end, "Toggle diff splits.")

keymap.map("n", "<leader>rn", function()
    require("ts-autotag").rename()
end)
