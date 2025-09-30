-- A custom picker that allows deleting multiple buffers
local function buffers()
    local builtins = require("telescope.builtin")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local function buffer_delete(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()

        actions.close(prompt_bufnr)

        if not multi or #multi == 0 then
            vim.api.nvim_buf_delete(selection.bufnr, { force = true })
        else
            for _, entry in ipairs(multi) do
                vim.api.nvim_buf_delete(entry.bufnr, { force = true })
            end
        end

        buffers()
    end

    builtins.buffers({
        sort_mru = true,
        ignore_current_buffer = false,
        show_all_buffers = true,
        initial_mode = "normal",
        attach_mappings = function(prompt_bufnr, map)
            map("n", "<C-d>", function()
                buffer_delete(prompt_bufnr)
            end)
            map("i", "<C-d>", function()
                buffer_delete(prompt_bufnr)
            end)
            return true
        end,
    })
end

return {
    buffers = buffers,
}
