return {
  {
    enabled = false,
    dir = "~/plugins/riches.nvim/",
    dependencies = {
      "stevearc/aerial.nvim",
    },
    config = function()
      -- require("riches").setup()
      require("aerial").setup {
        ignore = {
          filetypes = { "lua" },
        },
      }

      require("aerial").sync_load()
    end,
  },
}
