return {
  {
    dir = "~/plugins/sg.nvim",
    config = function()
      require("sg").setup {
        accept_tos = true,
        chat = {
          default_model = "opeanai/gpt-4o",
        },
      }
    end,
  },
}
