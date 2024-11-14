local elixir = require "elixir"
-- local elixirls = require "elixir.elixirls"

local function setup()
  elixir.setup {
    nextls = { enable = false },
    elixirls = {
      enable = true,
      on_attach = function()
        vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
        vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
        vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
      end,
    },
    projectionist = { enable = false },
  }
end

return {
  setup = setup,
}
