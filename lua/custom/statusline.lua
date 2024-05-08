local M = {}

-- local builtin = require "el.builtin"
local extensions = require "el.extensions"
local subscribe = require "el.subscribe"
local sections = require "el.sections"

vim.opt.laststatus = 3

M.setup = function()
  require("el").setup {
    generator = function()
      local segments = {}

      table.insert(segments, extensions.mode)
      table.insert(segments, " ")
      table.insert(
        segments,
        subscribe.buf_autocmd("el-git-branch", "BufEnter", function(win, buf)
          local branch = extensions.git_branch(win, buf)
          if branch then
            return branch
          end
        end)
      )
      table.insert(
        segments,
        subscribe.buf_autocmd("el-git-changes", "BufWritePost", function(win, buf)
          local changes = extensions.git_changes(win, buf)
          if changes then
            return changes
          end
        end)
      )
      table.insert(segments, function()
        return string.format(" (Queued Events: %d)", #require("misery.scheduler").tasks)
      end)
      table.insert(segments, sections.split)
      table.insert(segments, "%f")
      table.insert(segments, sections.split)

      return segments
    end,
  }
end

M.setup()

return M
