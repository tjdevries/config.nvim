vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
vim.keymap.set("n", "<c-l>", "<c-w><c-l>")
vim.keymap.set("n", "<c-h>", "<c-w><c-h>")

vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>")
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")

vim.keymap.set("n", "-", "<cmd>edit %:h<CR>")

vim.keymap.set("n", "<CR>", function()
  if vim.opt.hlsearch:get() then
    vim.cmd.nohl()
    return ""
  else
    return "<CR>"
  end
end, { expr = true })

vim.keymap.set("n", "<left>", "gT")
vim.keymap.set("n", "<right>", "gt")

vim.keymap.set("n", "<space>dn", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>dp", vim.diagnostic.goto_prev)

vim.keymap.set("n", "<M-,>", "<c-w>5<")
vim.keymap.set("n", "<M-.>", "<c-w>5>")
vim.keymap.set("n", "<A-t>", "<C-W>+")
vim.keymap.set("n", "<A-s>", "<C-W>-")

vim.keymap.set("n", "<M-j>", function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! ]c]]
  else
    vim.cmd [[m .+1<CR>==]]
  end
end)

vim.keymap.set("n", "<M-k>", function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! [c]]
  else
    vim.cmd [[m .-2<CR>==]]
  end
end)
