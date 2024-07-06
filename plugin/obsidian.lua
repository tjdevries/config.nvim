vim.api.nvim_create_user_command("ObsidianHTML", function(args)
  package.loaded["custom.to-obsidian-html"] = nil

  local opts = {}
  if args.range ~= 0 then
    opts.filter = function(row)
      return row >= args.line1 and row <= args.line2
    end
  end

  require("custom.to-obsidian-html").tohtml(0, opts)
end, { range = true })

vim.api.nvim_create_user_command("RunObsidian", function(args)
  local filename = args.args
  vim.cmd.edit(filename)

  local opts = {}
  local lines = require("custom.to-obsidian-html").tohtml(0, opts)
  io.stderr:write("Trying to open " .. filename .. "\n")
  io.stderr:write("Current working directory: " .. vim.fn.getcwd() .. "\n")
  io.stderr:write(table.concat(lines, "\n"))
  io.stderr:flush()
end, { nargs = 1 })
