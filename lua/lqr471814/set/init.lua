require("lqr471814.set.settings")
require("lqr471814.set.autocmds")
require("lqr471814.set.keybinds")

-- local function measure_typing_latency()
-- 	local uv = vim.loop
-- 	local prev_ts = nil
--
-- 	vim.api.nvim_create_autocmd("InsertCharPre", {
-- 		pattern = "*",
-- 		callback = function()
-- 			prev_ts = uv.hrtime()
-- 		end,
-- 	})
--
-- 	vim.api.nvim_create_autocmd("TextChangedI", {
-- 		pattern = "*",
-- 		callback = function()
-- 			local now = uv.hrtime()
-- 			if prev_ts then
-- 				local delta_ns = now - prev_ts
-- 				vim.notify(string.format("Latency: %.3f ms", delta_ns / 1e6))
-- 			end
-- 			prev_ts = nil
-- 		end,
-- 	})
-- end
-- measure_typing_latency()
