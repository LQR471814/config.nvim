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

---@param config { minimal: boolean }
local function init(config)
    local lazy = require("lazy")

    local modules
    if not config.minimal then
        modules = {
            require("lqr471814.layers.core"),
            require("lqr471814.layers.keystone"),
            require("lqr471814.layers.extras"),
        }
    else
        modules = {
            require("lqr471814.layers.core"),
            require("lqr471814.layers.keystone"),
        }
    end

    lazy.setup(modules)
end

return init
