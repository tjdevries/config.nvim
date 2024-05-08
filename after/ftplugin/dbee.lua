-- local api = require "dbee.api"
local dbee = require "dbee"

-- require("cmp-dbee").setup()

vim.opt_local.commentstring = "-- %s"

vim.api.nvim_create_autocmd("BufWritePost", {
  buffer = 0,
  callback = function()
    local query = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    dbee.execute(query)
  end,
})
