return {
	"stevearc/oil.nvim",
	dependencies = {
		"echasnovski/mini.icons",
		"nvim-tree/nvim-web-devicons",
		"folke/snacks.nvim"
	},
	config = function()
		require("oil").setup({
			watch_for_changes = true,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true
			}
		})

		-- automatically delete buffer when corresponding file on filesystem is deleted
		vim.api.nvim_create_autocmd("User", {
			pattern = "OilActionsPost",
			callback = function(event)
				if event.data.err then
					return
				end

				for _, action in ipairs(event.data.actions) do
					if action.entry_type ~= "file" then
						goto continue
					end

					if action.type == "delete" then
						local path = action.url:match("^.*://(.*)$")
						Snacks.bufdelete({ file = path, wipe = true })
					elseif action.type == "move" then
						local path = action.src_url:match("^.*://(.*)$")
						Snacks.bufdelete({ file = path, wipe = true })
					end

					::continue::
				end
			end,
		})

		-- notify snacks-rename of file rename
		vim.api.nvim_create_autocmd("User", {
			pattern = "OilActionsPost",
			callback = function(event)
				if #event.data.actions == 0 then
					return
				end
				if event.data.actions[1].type == "move" then
					Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
				end
			end,
		})
	end
}
