return {
  {
    "gpanders/nvim-parinfer",
    config = function()
      vim.g.parinfer_filetypes = {
        "dune",
        "scheme",
        "query",
        "racket",
      }
    end,
  },
}
