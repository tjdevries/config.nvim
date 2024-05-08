return {
  { dir = "~/plugins/plenary.nvim" },
  {
    dir = "~/plugins/telescope.nvim/",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require "custom.telescope"
    end,
  },
}
