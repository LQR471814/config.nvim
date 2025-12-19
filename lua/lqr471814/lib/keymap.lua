local Keymap = {}

--- @type vim.keymap.set.Opts
local opts = {
	noremap = true,
	silent = true,
	unique = true,
	buffer = false,
	desc = "",
}

function Keymap.map(mode, key, action, desc)
	opts.desc = desc
	vim.keymap.set(mode, key, action, opts)
end

function Keymap.buffer_map(mode, key, action, desc, buffer_no)
	opts.buffer = buffer_no or true
	opts.desc = desc
	vim.keymap.set(mode, key, action, opts)
end

function Keymap.overwrite_map(mode, key, action, desc)
	opts.unique = false
	opts.desc = desc
	vim.keymap.set(mode, key, action, opts)
end

function Keymap.overwrite_buffer_map(mode, key, action, desc, buffer_no)
	opts.buffer = buffer_no or true
	opts.unique = false
	opts.desc = desc
	vim.keymap.set(mode, key, action, opts)
end

function Keymap.unmap(modes, key)
	local ok, _ = pcall(function() vim.keymap.del(modes, key) end)
	return ok
end

function Keymap.buffer_unmap(modes, key, buffer_no)
	local ok, _ = pcall(function()
		vim.keymap.del(modes, key, {
			buffer = buffer_no or true
		})
	end)
	return ok
end

return Keymap
