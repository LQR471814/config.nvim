--- cache caches a callback's return value for the amount of time specified in
--- timeout_ms
---
--- @param timeout_ms integer
--- @param callback function
local function cache(timeout_ms, callback)
	local cached
	local is_cached = false

	local evict_cache = function()
		cached = nil
		is_cached = false
	end

	return function()
		if is_cached then
			return cached
		end
		vim.defer_fn(evict_cache, timeout_ms)
		cached = callback()
		is_cached = true
		return cached
	end
end

--- relpath computes the path of `target` relative to `from`, using ".." for
--- ancestor directories. Both arguments must be absolute paths; `from` is
--- treated as a directory.
---
--- @param from string absolute directory path
--- @param target string absolute file or directory path
--- @return string
local function relpath(from, target)
	local function split(path)
		local parts = {}
		for part in path:gmatch("[^/]+") do
			parts[#parts + 1] = part
		end
		return parts
	end

	local from_parts = split(from)
	local to_parts = split(target)

	-- drop the common prefix
	local i = 1
	while from_parts[i] and to_parts[i] and from_parts[i] == to_parts[i] do
		i = i + 1
	end

	local rel_parts = {}
	for _ = i, #from_parts do
		rel_parts[#rel_parts + 1] = ".."
	end
	for j = i, #to_parts do
		rel_parts[#rel_parts + 1] = to_parts[j]
	end

	if #rel_parts == 0 then
		return "."
	end
	return table.concat(rel_parts, "/")
end

return {
	cache = cache,
	relpath = relpath,
}
