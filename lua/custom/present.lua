---@diagnostic disable: need-check-nil
--- Originally based on presnting.nvim from Stefan Otte,
--- but modified to work for me.
---
--- MIT License Copyright (c) 2024
---

local M = {}

local function open_temp_float()
  -- Get the current Neovim UI dimensions
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.8)
  local height = math.floor(ui.height * 0.95)
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)

  -- Create a buffer for the floating window
  local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer

  -- Define window options
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    noautocmd = true,
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Autoclose the window when it loses focus
  vim.api.nvim_create_autocmd("WinLeave", {
    buffer = buf,
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  return buf
end

-- Usage: Call `open_temp_float()` to open the temporary floating window

---@alias Present.Slide string

---@class Present.Window
---@field buf integer: Buffer ID
---@field win integer: Window ID

--- Create a new presenting window
---@param config any
---@return Present.Window
local create_window = function(config, enter)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, enter, config)

  return {
    buf = buf,
    win = win,
  }
end

---@class Present.State
---@field active boolean: Actively presenting
---@field title string: Title of the presentation.
---@field index number: The slide index
---@field slides Present.Slide[]: The parsed slides
---@field slide Present.Window
---@field header Present.Window
---@field background Present.Window
---@field footer Present.Window

---@type Present.State
---@diagnostic disable-next-line: missing-fields
local state = {}

local separator = "^#+ "

local config = {
  -- The width of the slide buffer.
  width = 100,
}

M.setup = function()
  vim.api.nvim_create_user_command("Present", M.toggle, {})

  local presenting_autocmd_group_id = vim.api.nvim_create_augroup("PresentResize", { clear = true })
  vim.api.nvim_create_autocmd("WinResized", { group = presenting_autocmd_group_id, callback = M.resize })
end

--- Start presenting the current buffer.
M.start = function()
  if state.active then
    return
  end

  state.active = true

  -- Reset title
  state.title = vim.fn.expand "%:t:r"

  -- content of slides
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  state.slides = M.parse_slides(lines)

  local window_config = M.get_win_configs()

  state.background = create_window(window_config.background)

  state.footer = create_window(window_config.footer)
  vim.api.nvim_buf_set_lines(state.footer.buf, 0, -1, false, { "" })

  state.slide = create_window(window_config.slide, true)
  M.configure_slide_buffer(state.slide)

  M.set_slide_content(1)
end

--- Quit the current presentation and go back to the normal buffer.
--- By default this is mapped to `q`.
M.quit = function()
  if not state.active then
    return
  end

  state.active = false
  pcall(vim.api.nvim_buf_delete, state.slide.buf, { force = true })
  pcall(vim.api.nvim_buf_delete, state.footer.buf, { force = true })
  pcall(vim.api.nvim_buf_delete, state.background.buf, { force = true })
end

--- Go to the next slide.
--- By default this is mapped to `<CR>` and `n`.
-- stylua: ignore start
M.toggle = function() if state.active then M.quit() else M.start() end end
M.next = function() M.set_slide_content(math.min(state.index + 1, #state.slides)) end
M.prev = function() M.set_slide_content(math.max(state.index - 1, 1)) end
M.first = function() M.set_slide_content(1) end
M.last = function() M.set_slide_content(#state.slides) end
-- stylua: ignore end

M.select_block = function()
  -- Get the current buffer and cursor position
  local bufnr = state.slide.buf
  local start_line = 1

  -- Get the total number of lines in the buffer
  local total_lines = vim.api.nvim_buf_line_count(bufnr)

  -- Find the start of the markdown block
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, total_lines, false)
  local block_start = nil
  local block_end = nil

  for i, line in ipairs(lines) do
    if block_start == nil and line:match "^```" then
      block_start = start_line + i - 1
    elseif block_start ~= nil and line:match "^```" then
      block_end = start_line + i - 1
      break
    end
  end

  -- If we found a markdown block, set the visual selection
  if block_start and block_end then
    -- Set the visual selection from line after block start to block end
    vim.api.nvim_win_set_cursor(0, { block_start + 1, 0 })
    vim.cmd "normal! V"
    vim.api.nvim_win_set_cursor(0, { block_end - 1, 0 })
  else
    print "No markdown block found."
  end
end

M.execute_block = function()
  -- Get the current buffer and cursor position
  local bufnr = state.slide.buf
  local start_line = 1

  -- Get the total number of lines in the buffer
  local total_lines = vim.api.nvim_buf_line_count(bufnr)

  -- Find the start of the markdown block
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, total_lines, false)
  local block_start = nil
  local block_end = nil

  for i, line in ipairs(lines) do
    if block_start == nil and line:match "^```" then
      block_start = start_line + i - 1
    elseif block_start ~= nil and line:match "^```" then
      block_end = start_line + i - 1
      break
    end
  end

  -- If we found a markdown block, set the visual selection
  if block_start and block_end then
    -- Store the original print function
    local original_print = print

    -- Table to capture print messages
    local output = { "", "# Code", "" }

    -- Redefine the print function
    print = function(...)
      local args = { ... }
      local message = table.concat(vim.tbl_map(tostring, args), "\t")
      table.insert(output, message)
    end

    -- Call the provided function
    pcall(function()
      local block = vim.api.nvim_buf_get_lines(bufnr, block_start, block_end - 1, false)

      local chunk = vim.api.nvim_buf_get_lines(bufnr, block_start - 1, block_end, false)
      for idx, line in ipairs(chunk) do
        if idx < 20 or idx == #chunk then
          table.insert(output, line)
        elseif idx == 20 then
          table.insert(output, "...")
        end
      end

      table.insert(output, "")
      table.insert(output, "# Output ")
      table.insert(output, "")
      load(table.concat(block, "\n"))()
    end)

    -- Restore the original print function
    print = original_print

    local temp_buf = open_temp_float()
    vim.bo[temp_buf].filetype = "markdown"
    vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = temp_buf })

    -- ensure we clear the newlines
    output = vim.split(table.concat(output, "\n"), "\n")
    vim.api.nvim_buf_set_lines(temp_buf, 0, -1, false, output)
  else
    print "No markdown block found."
  end
end

---Resize the slide window.
M.resize = function()
  if not state.active then
    return
  end

  if (state.background.win == nil) or (state.slide.win == nil) or (state.footer.win == nil) then
    return
  end

  local window_config = M.get_win_configs()
  vim.api.nvim_win_set_config(state.background.win, window_config.background)
  vim.api.nvim_win_set_config(state.footer.win, window_config.footer)
  vim.api.nvim_win_set_config(state.slide.win, window_config.slide)
end

---@return table
---@private
M.get_win_configs = function()
  local slide_width = config.width
  local width = vim.o.columns
  local height = vim.o.lines
  local offset = math.ceil((width - slide_width) / 2)
  return {
    background = {
      style = "minimal",
      relative = "editor",
      focusable = false,
      width = width,
      height = height,
      row = 0,
      col = 0,
      zindex = 1,
    },
    slide = {
      style = "minimal",
      relative = "editor",
      width = slide_width,
      height = height - 5,
      row = 0,
      col = offset,
      zindex = 10,
    },
    footer = {
      style = "minimal",
      relative = "editor",
      width = slide_width,
      height = 2,
      row = height - 1,
      col = offset,
      focusable = false,
      zindex = 2,
    },
  }
end

---@param lines table
---@return table
---@private
M.parse_slides = function(lines)
  local slides = {}
  local slide = {}
  for _, line in pairs(lines) do
    if line:match(separator) then
      if #slide > 0 then
        table.insert(slides, table.concat(slide, "\n"))
      end
      slide = {}
      local width = config.width
      local remaining = width - #line
      local padding = string.rep(" ", math.floor(remaining / 2))
      table.insert(slide, padding .. line)
    else
      -- table.insert(slide, string.rep(" ", math.floor(config.width / 5)) .. line)
      table.insert(slide, line)
    end
  end
  table.insert(slides, table.concat(slide, "\n"))

  return slides
end

---@param window Present.Window
---@private
M.configure_slide_buffer = function(window)
  local buf = window.buf

  assert(buf, "Must have a slide buffer")
  print(buf)

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = false

  local resets = {}
  resets.cmdheight = 0
  resets.guicursor = "n:NormalFloat"

  for k, v in pairs(resets) do
    resets[k], vim.o[k] = vim.o[k], v
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    callback = function()
      for k, v in pairs(resets) do
        vim.o[k] = v
      end
    end,
  })

  for k, v in pairs {
    ["n"] = M.next,
    ["p"] = M.prev,
    ["q"] = M.quit,
    ["f"] = M.first,
    ["l"] = M.last,
    ["<CR>"] = M.next,
    ["<BS>"] = M.prev,
    ["V"] = M.select_block,
    ["X"] = M.execute_block,
  } do
    vim.keymap.set("n", k, v, { buffer = buf, silent = true })
  end
end

---@param slide integer
---@private
M.set_slide_content = function(slide)
  local buf = state.slide.buf
  state.index = slide

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "", "", "" })
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(state.slides[state.index], "\n"))
  vim.bo[buf].modifiable = false

  local footer_text = state.title .. " | " .. state.index .. "/" .. #state.slides
  vim.api.nvim_buf_set_lines(state.footer.buf, 0, -1, false, { footer_text, "" })
end

return M
