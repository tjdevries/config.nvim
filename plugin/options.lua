local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.splitbelow = true
opt.splitright = true

opt.inccommand = "split"
opt.signcolumn = "yes"
opt.shada = { "'10", "<0", "s10", "h" }

-- Best search settings :)
opt.smartcase = true
opt.ignorecase = true

opt.clipboard = "unnamedplus"
