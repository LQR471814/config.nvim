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

return {
	cache = cache
}
