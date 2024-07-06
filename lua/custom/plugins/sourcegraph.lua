return {
  {
    dir = "~/plugins/sg.nvim",
    config = function()
      require("sg").setup {
        accept_tos = true,
        node_executable = "/home/tjdevries/.local/share/mise/installs/node/latest/bin/node",
        chat = {
          default_model = "opeanai/gpt-4o",
        },
      }
    end,
  },
}
