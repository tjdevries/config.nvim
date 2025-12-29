local uv = vim.loop

local love_handle = nil
local love_pid = nil

local function run_love()
  if love_handle then
    if love_pid then
      uv.kill(love_pid, "sigterm")
    end
    love_handle:close()
    love_handle = nil
    love_pid = nil
  end

  local handle, pid = uv.spawn("love", {
    args = { "." },
    cwd = vim.fn.getcwd(),
  }, function(code, signal)
    love_handle = nil
    love_pid = nil
  end)

  if handle then
    love_handle = handle
    love_pid = pid
  end
end

vim.keymap.set("n", "<leader>rl", run_love, { desc = "Run love" })

local function ripgrep_to_qf(search)
  local output = vim.fn.system(string.format("rg --vimgrep --hidden --smart-case %q", search))
  -- ripgrep + --vimgrep prints: file:line:col:match
  local items = vim.split(output, "\n", { trimempty = true })

  local qf = {}
  for _, line in ipairs(items) do
    local file, lnum, col, text = line:match "([^:]+):(%d+):(%d+):(.*)"
    if file then
      table.insert(qf, {
        filename = file,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = text,
      })
    end
  end

  vim.fn.setqflist(qf, "r")
  vim.cmd "copen"
end

vim.keymap.set("n", "<leader>rm", function()
  local file = vim.fn.expand "%:."

  -- Replace slashes with dots
  file = file:gsub("/", ".")

  -- Remove .lua extension
  file = file:gsub(".lua$", "")

  -- Now search for the module in the project
  ripgrep_to_qf(file)
end, { desc = "is this module unused?" })
