if true or not pcall(require, "php") then
  return
end

require("php").setup {}

vim.keymap.set("n", "<space>pa", function()
  R "php"
  require("php.artisan").telescope_select_artisan()
end)
