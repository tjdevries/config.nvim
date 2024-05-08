return {
  {
    "tjdevries/express_line.nvim",
    config = function()
      require("custom.statusline").setup()
    end,
  },
}
