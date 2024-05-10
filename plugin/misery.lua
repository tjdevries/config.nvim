vim.opt.rtp:append "/home/tjdevries/plugins/misery.nvim"
vim.opt.rtp:append "/home/tjdevries/plugins/websocket.nvim"

vim.cmd.source "/home/tjdevries/plugins/misery.nvim/plugin/misery.lua"

-- vim.cmd [[hi clear]]

-- vim.defer_fn(function()
--   vim.cmd [[hi clear]]
--   vim.cmd.colorscheme "colorbuddy"
-- end, 100)

vim.keymap.set("n", "<space>fm", function()
  require("telescope.builtin").find_files { cwd = "/home/tjdevries/plugins/misery.nvim/" }
end)
