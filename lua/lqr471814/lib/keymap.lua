local Keymap = {
	--- @class vim.keymap.set.Opts
	opts = {
		-- prevents keymap from being overriden
		noremap = true,
		-- suppresses command text and info messages
		silent = true,
		-- throw error if already assigned
		unique = true,
		-- map key for current buffer only
		buffer = false,
		-- set keymap description
		desc = "",
	}
}

-- try to map a keymap globally, throw an error if already mapped
function Keymap.map(mode, key, action, desc)
	Keymap.opts.unique = true
	Keymap.opts.buffer = false
	Keymap.opts.desc = desc
	vim.keymap.set(mode, key, action, Keymap.opts)
end

-- try to map a key to the specific buffer, throw error if already mapped
function Keymap.buffer_map(mode, key, action, desc, buffer_no)
	Keymap.opts.unique = true
	Keymap.opts.buffer = buffer_no or true
	Keymap.opts.desc = desc
	vim.keymap.set(mode, key, action, Keymap.opts)
end

-- map a keymap globally, potentially overwriting existing maps
function Keymap.overwrite_map(mode, key, action, desc)
	Keymap.opts.unique = false
	Keymap.opts.buffer = false
	Keymap.opts.desc = desc
	vim.keymap.set(mode, key, action, Keymap.opts)
end

-- map a keymap for the buffer, potentially overwriting existing maps
function Keymap.overwrite_buffer_map(mode, key, action, desc, buffer_no)
	Keymap.opts.unique = false
	Keymap.opts.buffer = buffer_no or true
	Keymap.opts.desc = desc
	vim.keymap.set(mode, key, action, Keymap.opts)
end

-- remove a keymap globally
function Keymap.unmap(modes, key)
	local ok, _ = pcall(function() vim.keymap.del(modes, key) end)
	return ok
end

-- remove a keymap for the current buffer
function Keymap.buffer_unmap(modes, key, buffer_no)
	local ok, _ = pcall(function()
		vim.keymap.del(modes, key, {
			buffer = buffer_no or true
		})
	end)
	return ok
end

return Keymap
