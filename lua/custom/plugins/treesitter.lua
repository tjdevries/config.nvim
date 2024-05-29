return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { dir = "~/plugins/tree-sitter-lua" },
    },
    build = ":TSUpdate",
    branch = "main",
    event = { "LazyFile", "VeryLazy" },
    config = function()
      require("custom.treesitter").setup()
    end,
  },
}
