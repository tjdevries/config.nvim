return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- { dir = "~/plugins/tree-sitter-lua" },
      { "reasonml-editor/tree-sitter-reason" },
    },
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    config = function()
      require("custom.treesitter").setup()
    end,
  },
}
