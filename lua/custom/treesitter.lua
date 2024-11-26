-- local treesitter = require "nvim-treesitter"

local M = {}

M.setup = function()
  local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })

  require("nvim-treesitter").setup {
    ensure_install = {
      "core",
      "stable",
      -- Elixir langs
      "elixir",
      "heex",
    },
  }

  local syntax_on = {
    elixir = true,
    php = true,
  }

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
      if not ok or not parser then
        return
      end
      pcall(vim.treesitter.start)

      local ft = vim.bo[bufnr].filetype
      if syntax_on[ft] then
        vim.bo[bufnr].syntax = "on"
      end
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
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

      parsers.blade = {
        tier = 0,

        ---@diagnostic disable-next-line: missing-fields
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }
    end,
  })
end

-- M.setup()

return M
