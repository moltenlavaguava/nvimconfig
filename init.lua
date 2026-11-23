print("init.lua loaded!!!!!")

require("config.lazy")

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

