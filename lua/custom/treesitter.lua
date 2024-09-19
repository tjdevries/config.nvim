-- local treesitter = require "nvim-treesitter"

local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })

  require("nvim-treesitter").setup {
    -- ensure_install = { "core", "stable" },
  }

  local syntax_on = {
    elixir = true,
    php = true,
  }

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local ft = vim.bo[bufnr].filetype
      pcall(vim.treesitter.start)

      if syntax_on[ft] then
        vim.bo[bufnr].syntax = "on"
      end
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
      local parsers = require "nvim-treesitter.parsers"

      parsers.lua = {
        tier = 0,

        ---@diagnostic disable-next-line: missing-fields
        install_info = {
          path = "~/plugins/tree-sitter-lua",
          files = { "src/parser.c", "src/scanner.c" },
        },
      }

      -- parsers.menhir = {
      --   tier = 0,
      --
      --   ---@diagnostic disable-next-line: missing-fields
      --   install_info = {
      --     path = "~/git/tree-sitter-ocaml",
      --     location = "grammars/menhir",
      --     files = { "src/parser.c", "src/scanner.c" },
      --   },
      -- }

      parsers.cram = {
        tier = 0,

        ---@diagnostic disable-next-line: missing-fields
        install_info = {
          path = "~/git/tree-sitter-cram",
          files = { "src/parser.c" },
        },
      }

      parsers.reason = {
        tier = 0,

        ---@diagnostic disable-next-line: missing-fields
        install_info = {
          url = "https://github.com/reasonml-editor/tree-sitter-reason",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "master",
        },
      }

      parsers.ocaml_mlx = {
        tier = 0,

        install_info = {
          location = "grammars/mlx",
          url = "https://github.com/ocaml-mlx/tree-sitter-mlx",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "master",
        },
        filetype = "ocaml.mlx",
      }
    end,
  })
end

M.setup()

return M
