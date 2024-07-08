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
  io.stderr:write "\n\n"
  io.stderr:write(table.concat(lines, "\n"))
  io.stderr:flush()
end, { nargs = 1 })

vim.api.nvim_create_user_command("EditObsidian", function(args)
  vim.opt.title = true
  vim.opt.titlestring = "edit-obisidian"

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      local lines = require("custom.to-obsidian-html").tohtml(0, {})
      io.stderr:write(table.concat(lines))
    end,
  })

  vim.cmd.edit(args.args)
end, { nargs = 1 })
