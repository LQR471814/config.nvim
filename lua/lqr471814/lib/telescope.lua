-- A custom picker that allows deleting multiple buffers
local function buffers()
	local builtins = require("telescope.builtin")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
    builtins.buffers({
        sort_mru = true,
        ignore_current_buffer = false,
        show_all_buffers = true,
        attach_mappings = function(prompt_bufnr, map)
            -- Single buffer delete
            map("n", "<C-d>", function()
                local selection = action_state.get_selected_entry()
                vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                actions.close(prompt_bufnr)
                buffers()
            end)

            -- Multi buffer delete
            map("n", "<C-D>", function()
                local picker = action_state.get_current_picker(prompt_bufnr)
                local multi = picker:get_multi_selection()
                for _, entry in ipairs(multi) do
                    vim.api.nvim_buf_delete(entry.bufnr, { force = true })
                end
                actions.close(prompt_bufnr)
                buffers()
            end)

            map("i", "<C-d>", function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.api.nvim_buf_delete(selection.bufnr, { force = true })
                buffers()
            end)

            map("i", "<C-D>", function()
                actions.close(prompt_bufnr)
                local picker = action_state.get_current_picker(prompt_bufnr)
                local multi = picker:get_multi_selection()
                for _, entry in ipairs(multi) do
                    vim.api.nvim_buf_delete(entry.bufnr, { force = true })
                end
                buffers()
            end)

            return true
        end,
    })
end

return {
	buffers = buffers,
}
