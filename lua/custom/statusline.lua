local M = {}

local builtin = require "el.builtin"
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
        local task_count = #require("misery.scheduler").tasks
        if task_count == 0 then
          return ""
        else
          return string.format(" (Queued Events: %d)", task_count)
        end
      end)
      table.insert(segments, sections.split)
      table.insert(segments, "%f")
      table.insert(segments, sections.split)
      table.insert(segments, builtin.filetype)
      table.insert(segments, "[")
      table.insert(segments, builtin.line_with_width(3))
      table.insert(segments, ":")
      table.insert(segments, builtin.column_with_width(2))
      table.insert(segments, "]")

      return segments
    end,
  }
end

M.setup()

return M
