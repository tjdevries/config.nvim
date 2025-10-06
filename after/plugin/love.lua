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
