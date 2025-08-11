-- Bootstrap lazyvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Actual plugin definition

---@type LazySpec
local commonConfig = {
    -- rename html tags
    "windwp/nvim-ts-autotag",
    -- theme
    {
        "sho-87/kanagawa-paper.nvim",
        config = function()
            vim.cmd("colorscheme kanagawa-paper")
        end
    },
    -- fancy undos
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    -- file explorer
    {
        'stevearc/oil.nvim',
        opts = {
            view_options = {
                show_hidden = true
            },
            keymaps = {
                ["go"] = "actions.open_external",
            }
        },
        dependencies = {
            { "echasnovski/mini.icons", opts = {} }
        },
    },
    -- line wrap
    {
        "andrewferrier/wrapping.nvim",
        config = function()
            ---@diagnostic disable-next-line: missing-parameter
            require("wrapping").setup()
        end
    },
    {
        "johmsalas/text-case.nvim",
        config = function()
            require("textcase").setup({})
            require("telescope").load_extension("textcase")
        end
    },
    -- notifications
    {
        "folke/snacks.nvim",
        priority = 1000,
        ---@type snacks.Config
        opts = {
            notifier = {},
            image = {},
            lazygit = {},
            quickfile = {}
        }
    },
    -- pcre syntax
    "othree/eregex.vim",
    -- focused writing
    "junegunn/limelight.vim",
    -- make editing big files faster
    {
        "mireq/large_file",
        config = function()
            require("large_file").setup()
        end
    },
    -- guess indentation config of a file
    {
        "NMAC427/guess-indent.nvim",
        config = function()
            require("guess-indent").setup {}
        end
    },
    {
        "iurimateus/luasnip-latex-snippets.nvim",
        config = function()
            require("luasnip-latex-snippets").setup({
                use_treesitter = true
            })
        end,
    },
}

---@param config { slim: boolean }
local function init(config)
    local modules = {
        -- support .fountain files
        {
            "kblin/vim-fountain",
            enabled = not config.slim
        },
        -- latex support
        {
            "lervag/vimtex",
            enabled = not config.slim
        },
        -- switch between files
        require("lqr471814.plugins.harpoon"),
        -- search and replace
        require("lqr471814.plugins.spectre"),
        -- luasnip
        require('lqr471814.plugins.luasnip'),
        -- fuzzy find
        require("lqr471814.plugins.telescope"),
        -- multi-cursors
        require("lqr471814.plugins.multicursors"),
        -- auto close brackets
        require("lqr471814.plugins.autoclose"),
        -- manipulate brackets
        require("lqr471814.plugins.surround"),
        -- comments
        require("lqr471814.plugins.comment"),
        -- AST parsing/syntax highlighting
        require("lqr471814.plugins.treesitter"),
        -- language server
        require("lqr471814.plugins.lsp")(config),
    }

    for i = 1, #commonConfig do
        table.insert(modules, commonConfig[i])
    end

    require("lazy").setup(modules)
end

return init
