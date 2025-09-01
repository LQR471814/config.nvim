local lib = require("lqr471814.lib")

-- enable hard wrap on markdown files
vim.api.nvim_create_autocmd("BufRead", {
    pattern = { "*.md", "*.tex" },
    callback = function()
        lib.wrap:set("hard")

        local opts = { buffer = true }

        -- bold
        vim.keymap.set("v", "<C-b>", "2<Plug>(nvim-surround-visual)*", opts)
        vim.keymap.set("i", "<C-b>", "****<Left><Left>", opts)

        -- highlight
        vim.keymap.set("v", "<C-h>", "2<Plug>(nvim-surround-visual)=", opts)
        vim.keymap.set("i", "<C-h>", "====<Left><Left>", opts)

        -- renumber list
        vim.keymap.set("n", "<leader>rl", "<Plug>(bullets-renumber)", opts)

        -- bullets
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

        -- tab size
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4

        -- table mode
        local enabled = false

        --- @type "off" | "hard" | "soft"
        local wrapStatus

        vim.keymap.set("n", "<leader>tm", function()
            enabled = not enabled
            if enabled then
                vim.cmd("TableModeEnable")
                wrapStatus = lib.wrap:status()
                lib.wrap:set("off")
            else
                vim.cmd("TableModeDisable")
                lib.wrap:set(wrapStatus)
            end
        end, opts)
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.tex" },
    callback = function()
        -- use vimtex latex conceal in latex
        vim.o.conceallevel = 3
        vim.g.vimtex_syntax_conceal_disable = 0
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.md" },
    callback = function(args)
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en"

        local opts = { buffer = true }
        vim.keymap.set({ "n", "i" }, "<C-[>", "<ESC>m'[s1z=<CR>`'", opts)
        vim.keymap.set({ "n", "i" }, "<C-]>", "<ESC>m']s1z=<CR>`'", opts)

        -- this is in a defer because something keeps overriding it
        vim.defer_fn(function()
            -- don't use vimtex latex conceal in markdown
            vim.o.conceallevel = 0
            vim.g.vimtex_syntax_conceal_disable = 1

            -- ensure vimtex mathzone detection works
            vim.opt_local.syntax = "tex"
        end, 1000)

        local timer = vim.uv.new_timer()
        local active = false

        local redraw = function()
            vim.cmd("redraw!")
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
                vim.uv.timer_start(timer, 500, 0, handler)
            end
        })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en"

        local opts = { buffer = true }
        vim.keymap.set({ "n", "i" }, "<C-[>", "<ESC>m'[s1z=<CR>`'", opts)
        vim.keymap.set({ "n", "i" }, "<C-]>", "<ESC>m']s1z=<CR>`'", opts)
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
        vim.keymap.set("n", "gd", "<C-]>", { buffer = true })
    end,
})
