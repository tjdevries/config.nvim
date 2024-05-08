vim.keymap.set("n", "<space>od", function()
  require("dbee").open()
end)

---@diagnostic disable-next-line: param-type-mismatch
local base = vim.fs.joinpath(vim.fn.stdpath "state", "dbee", "notes")
local pattern = string.format("%s/.*", base)
vim.filetype.add {
  extension = {
    sql = function(path, _)
      if path:match(pattern) then
        return "sql.dbee"
      end

      return "sql"
    end,
  },

  pattern = {
    [pattern] = "sql.dbee",
  },
}
