local ns = vim.api.nvim_create_namespace "custom-on-key"

local bufnr = 859
local win = 1639

local ignored_filetypes = {
  terminal = true,
}

local enabled_modes = {
  n = true,
}

print(vim.on_key(function(_, typed)
  if ignored_filetypes[vim.bo.filetype] then
    return
  end

  local mode = vim.api.nvim_get_mode().mode
  if not enabled_modes[mode] then
    return
  end

  if typed and typed ~= "" then
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { vim.fn.keytrans(typed) })
    vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(bufnr), 0 })
  end
end, ns))

-- vim.on_key(nil, ns)
