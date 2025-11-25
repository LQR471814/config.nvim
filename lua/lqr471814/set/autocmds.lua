local lib = require("lqr471814.lib")
local keymap = lib.keymap

-- enable hard wrap on tex files
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = { "*.tex" },
    callback = function()
        lib.wrap.set("hard", true)
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

-- make help keybinds more sane
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        keymap.buffer_map("n", "gd", "<C-]>", "Jump to definition")
    end,
})

-- resize splits automatically when window is resized
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})

-- make neovim help open in a vertical split
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    command = "wincmd L"
})

-- vim.api.nvim_create_autocmd("BufWriteCmd", {
--     pattern = "oil://*",
--     callback = function(ev)
--         -- Before oil writes (which includes renames), check for edited buffers
--         for _, buf in ipairs(api.nvim_list_bufs()) do
--             if api.nvim_buf_is_loaded(buf) then
--                 local fname = api.nvim_buf_get_name(buf)
--                 if fname ~= "" and api.nvim_buf_get_option(buf, "modified") then
--                     -- Write that buffer first
--                     api.nvim_buf_call(buf, function() vim.cmd("write") end)
--                 end
--             end
--         end
--         -- After that, let oil continue with its mutation write
--     end,
--     -- ensure this runs before oil’s own write handler
--     desc = "Write modified buffers before oil rename"
-- })

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {
        "learn.zybooks.com*.txt",
        "app.codingrooms.com*.txt",
    },
    callback = function()
        vim.cmd("set filetype=c")
        vim.cmd("set guifont=Monaspice_NF_Light:h11")
        vim.defer_fn(function()
            vim.cmd("LspStop clangd")
        end, 1000)
    end,
})


vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lisp", "nix" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end
})
