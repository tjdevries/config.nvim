return {
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()

      vim.keymap.set("n", "<space>-", require("oil").toggle_float)
    end,
  },
}
