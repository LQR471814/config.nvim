local function enable_soft_wrap()
	vim.opt_local.wrap = true
	vim.opt_local.linebreak = true
end

local function disable_soft_wrap()
	vim.opt_local.wrap = false
	vim.opt_local.linebreak = false
end

local function enable_hard_wrap()
	vim.opt_local.textwidth = 66
end

local function disable_hard_wrap()
	vim.opt_local.textwidth = 0
end

--- @alias Mode "off" | "hard" | "soft"

local Wrap = {}

--- @return Mode
function Wrap.status()
	if vim.opt_local.wrap:get() == true and vim.opt_local.linebreak:get() == true then
		return "soft"
	end
	if vim.opt_local.textwidth:get() > 0 then
		return "hard"
	end
	return "off"
end

--- @param status Mode
--- @param silent boolean?
function Wrap.set(status, silent)
	if status == "off" then
		disable_hard_wrap()
		disable_soft_wrap()
		if not silent then
			vim.notify("All wrappings off.")
		end
	elseif status == "hard" then
		disable_soft_wrap()
		enable_hard_wrap()
		if not silent then
			vim.notify("Hard wrapping on.")
		end
	elseif status == "soft" then
		disable_hard_wrap()
		enable_soft_wrap()
		if not silent then
			vim.notify("Soft wrapping on.")
		end
	end
end

--- @param status "hard" | "soft"
--- @param silent boolean?
function Wrap.toggle(status, silent)
	local current = Wrap.status()
	if status == "hard" then
		if current == "hard" then
			disable_hard_wrap()
			if not silent then
				vim.notify("Hard wrapping off.")
			end
		else
			disable_soft_wrap()
			enable_hard_wrap()
			if not silent then
				vim.notify("Hard wrapping on.")
			end
		end
	elseif status == "soft" then
		if current == "soft" then
			disable_soft_wrap()
			if not silent then
				vim.notify("Soft wrapping off.")
			end
		else
			disable_hard_wrap()
			enable_soft_wrap()
			if not silent then
				vim.notify("Soft wrapping on.")
			end
		end
	end
end

return Wrap
