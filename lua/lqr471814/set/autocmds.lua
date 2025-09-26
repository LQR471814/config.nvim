local lib = require("lqr471814.lib")

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
        local opts = { buffer = true, silent = true }

        -- spell check
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en"
        vim.keymap.set("n", "z,", "<ESC>m'[s1z=<CR>`'", opts)
        vim.keymap.set("n", "z.", "<ESC>m']s1z=<CR>`'", opts)

        -- tab size
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4

        -- prevent line break inside brackets
        vim.opt_local.breakat = " \\\t!@*-+;:,./?"

        -- bold
        vim.keymap.set("v", "<C-b>", "2<Plug>(nvim-surround-visual)*", opts)
        vim.keymap.set("i", "<C-b>", "****<Left><Left>", opts)

        -- highlight
        vim.keymap.set("v", "<C-h>", "2<Plug>(nvim-surround-visual)=", opts)
        vim.keymap.set("i", "<C-h>", "====<Left><Left>", opts)

        -- bullets
        vim.keymap.set("n", "<leader>rl", "<Plug>(bullets-renumber)", opts)
        vim.keymap.set("i", "<cr>", "<Plug>(bullets-newline-cr)", opts)
        vim.keymap.set("n", "o", "<Plug>(bullets-newline-o)", opts)
        vim.keymap.set("n", "<leader>d", "<Plug>(bullets-toggle-checkbox)", opts)
        vim.keymap.set("i", "<Tab>", "<C-o><Plug>(bullets-demote)", opts)
        vim.keymap.set("i", "<S-Tab>", "<C-o><Plug>(bullets-promote)", opts)

        -- insert link
        vim.keymap.set("i", "<C-k>", function()
            local clipboard = vim.fn.getreg("+")
            clipboard = clipboard:gsub("\n", "")
            local pos = vim.api.nvim_win_get_cursor(0)
            vim.api.nvim_put({ "[](" .. clipboard .. ")" }, "c", true, false)
            vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
        end, opts)

        -- table mode

        local function enable_markdown_tablemode()
            local enabled = false

            --- @type "off" | "hard" | "soft"
            local wrapStatus

            vim.keymap.set("n", "<leader>tm", function()
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
            end, opts)
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
        vim.keymap.set("n", "gd", "<C-]>", { buffer = true })
    end,
})

-- resize splits automatically when window is resized
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})
