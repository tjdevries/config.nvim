---@diagnostic disable: undefined-field

--[[
--
-- You can ignore this file, it's just for goofy shenanigans
-- related to misery.nvim, not towards my real config
--
--]]
if not vim.uv.fs_stat "/home/tjdevries/plugins/misery.nvim/plugin/misery.lua" then
  return
end

vim.opt.rtp:append "/home/tjdevries/plugins/misery.nvim"
vim.opt.rtp:append "/home/tjdevries/plugins/websocket.nvim"

vim.cmd.source "/home/tjdevries/plugins/misery.nvim/plugin/misery.lua"

vim.keymap.set("n", "<space>fm", function()
  require("telescope.builtin").find_files { cwd = "/home/tjdevries/plugins/misery.nvim/" }
end)
