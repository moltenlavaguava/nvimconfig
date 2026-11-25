-- test comment to see if sync works
print("init.lua loaded!!!!!")

require("config.lazy")

local nvim_dir = vim.fn.stdpath("config")
local fail_log = vim.fn.stdpath("state") .. "/config-sync-failure.txt"

local function git(args)
	local cmd = vim.list_extend({ "git", "-C", nvim_dir }, args)
	local out = vim.fn.system(cmd)
	return vim.v.shell_error == 0, out
end

-- on start: report last exit's push failure, then pull in the background
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.filereadable(fail_log) == 1 then
			local msg = table.concat(vim.fn.readfile(fail_log), "\n")
			vim.notify(msg, vim.log.levels.ERROR)
			vim.fn.delete(fail_log)
		end
		vim.fn.jobstart({ "git", "-C", nvim_dir, "pull", "--ff-only" }, {
			on_exit = function(_, code)
				if code ~= 0 then
					vim.schedule(function()
						vim.notify(
							"Config pull FAILED (exit " .. code .. "). Run `git pull` in " .. nvim_dir .. " to see why.",
							vim.log.levels.ERROR
						)
					end)
				end
			end,
		})
	end,
})

-- on exit: commit and push
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		git({ "add", "-A" })
		git({ "commit", "-m", "auto: " .. os.date("%F %T") }) -- fails harmlessly if nothing changed
		local ok, out = git({ "push" })
		if not ok then
			local msg = "Config push FAILED. Run `git push` in " .. nvim_dir .. " to see why.\n" .. out
			vim.fn.writefile(vim.split(msg, "\n"), fail_log)
			vim.api.nvim_echo({ { msg, "ErrorMsg" } }, true, {})
		end
	end,
})

-- show errors on right of line
vim.diagnostic.config({ virtual_text = true })

-- 4 spaces when tab
vim.opt.shiftwidth = 4
-- show line numbers
vim.opt.number = true
-- show line numbers not at the current one as relative numbers
vim.opt.relativenumber = true
-- paste system clipboard buffer when pasting
vim.opt.clipboard = "unnamedplus"
