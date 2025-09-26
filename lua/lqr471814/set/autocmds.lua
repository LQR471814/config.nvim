local lib = require("lqr471814.lib")
local keymap = lib.keymap

-- enable hard wrap on markdown and tex files
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = { "*.md", "*.tex" },
    callback = function()
        lib.wrap:set("hard", true)
    end
})

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = { "*.md", "*.markdown" },
    callback = function(args)
        -- spell check
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en"
        keymap:buffer_map("n", "z,", "<ESC>m'[s1z=<CR>`'", "Correct previous spelling error.")
        keymap:buffer_map("n", "z.", "<ESC>m']s1z=<CR>`'", "Correct next spelling error.")

        -- tab size
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4

        -- prevent line break inside brackets
        vim.opt_local.breakat = " \\\t!@*-+;:,./?"

        -- bold
        keymap:buffer_map("v", "<C-b>", "2<Plug>(nvim-surround-visual)*", "Make visual selection bold.")
        keymap:buffer_map("i", "<C-b>", "****<Left><Left>", "Create bold text.")

        -- highlight
        keymap:buffer_map("v", "<C-h>", "2<Plug>(nvim-surround-visual)=", "Highlight visual selection.")
        keymap:buffer_map("i", "<C-h>", "====<Left><Left>", "Create highlighted text.")

        -- bullets
        keymap:buffer_map("n", "<leader>rl", "<Plug>(bullets-renumber)", "Renumber bullets.")

        local blink = require("blink-cmp")
        keymap:buffer_map("i", "<cr>", function()
            local accepted = blink.accept()
            if not accepted then
                vim.cmd("InsertNewBulletCR")
            end
        end)

        keymap:buffer_map("n", "o", function()
            vim.cmd("InsertNewBulletO")
        end)
        keymap:buffer_map("n", "2o", function()
            vim.cmd("InsertNewBulletO")
            vim.cmd("InsertNewBulletO")
        end)
        keymap:buffer_map("n", "<leader>d", "<Plug>(bullets-toggle-checkbox)", "Toggle checkbox.")
        keymap:buffer_map("i", "<Tab>", "<C-o><Plug>(bullets-demote)", "De-indent bullet.")
        keymap:buffer_map("i", "<S-Tab>", "<C-o><Plug>(bullets-promote)", "Indent bullet.")

        -- insert link
        keymap:buffer_map("i", "<C-k>", function()
            local clipboard = vim.fn.getreg("+")
            clipboard = clipboard:gsub("\n", "")
            local pos = vim.api.nvim_win_get_cursor(0)
            vim.api.nvim_put({ "[](" .. clipboard .. ")" }, "c", true, false)
            vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
        end, "Insert link based on clipboard contents.")

        -- table mode

        local function enable_markdown_tablemode()
            local enabled = false

            --- @type "off" | "hard" | "soft"
            local wrapStatus

            keymap:buffer_map("n", "<leader>tm", function()
                enabled = not enabled
                if enabled then
                    vim.cmd("TableModeEnable")
                    vim.cmd("RenderMarkdown disable")
                    wrapStatus = lib.wrap:status()
                    lib.wrap:set("off")
                else
                    vim.cmd("TableModeDisable")
                    vim.cmd("RenderMarkdown enable")
                    lib.wrap:set(wrapStatus)
                end
            end)
        end

        enable_markdown_tablemode()

        -- monkeypatch mdmath issues

        local function monkeypatch_mdmath()
            local timer = vim.uv.new_timer()
            if not timer then
                vim.notify("failed to create timer!", vim.log.levels.ERROR)
                return
            end

            local active = false

            local redraw = function()
                vim.cmd("redraw")
                if vim.opt.filetype:get() == "markdown" then
                    vim.opt_local.spell = not lib.in_mathzone()
                end
            end

            local handler = function()
                vim.uv.timer_stop(timer)
                active = false
                vim.schedule(redraw)
            end

            vim.api.nvim_create_autocmd({ "CursorMoved" }, {
                buffer = args.buf,
                callback = function()
                    if active then
                        vim.uv.timer_stop(timer)
                    end

                    active = true
                    local success = vim.uv.timer_start(timer, 200, 0, handler)
                    if not success then
                        active = false
                    end
                end
            })
        end

        monkeypatch_mdmath()
    end,
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
        keymap:buffer_map("n", "gd", "<C-]>", "Jump to definition")
    end,
})

-- resize splits automatically when window is resized
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})
