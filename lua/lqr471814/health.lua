local function has_executable(bin)
	vim.health.start(bin)
	if vim.fn.executable(bin) ~= 1 then
		vim.health.error(bin .. " not found")
	else
		vim.health.ok(bin .. " installed")
	end
end

return {
	check = function()
		has_executable("wl-paste")
		has_executable("wl-copy")
	end
}
