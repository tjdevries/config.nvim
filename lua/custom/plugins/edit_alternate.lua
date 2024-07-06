return {
  {
    "tjdevries/edit_alternate.vim",
    dependencies = { "tjdevries/standard.vim", "tjdevries/conf.vim" },
    config = function()
      vim.fn["edit_alternate#rule#add"]("go", function(filename)
        if filename:find "_test.go" then
          return (filename:gsub("_test%.go", ".go"))
        else
          return (filename:gsub("%.go", "_test.go"))
        end
      end)

      vim.fn["edit_alternate#rule#add"]("ml", function(filename)
        return (filename:gsub("%.ml", ".mli"))
      end)

      vim.fn["edit_alternate#rule#add"]("mli", function(filename)
        return (filename:gsub("%.mli", ".ml"))
      end)

      vim.api.nvim_set_keymap("n", "<space>ea", "<cmd>EditAlternate<CR>", { silent = true })
    end,
  },
}
