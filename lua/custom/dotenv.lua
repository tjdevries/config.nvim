local function parse_env_file(filepath)
  -- Check if file exists
  local file = io.open(filepath, "r")
  if not file then
    return {}
  end

  local env = {}

  -- Read file line by line
  for line in file:lines() do
    -- Skip empty lines and comments
    if line:match "^%s*[^#]" then
      -- Remove leading/trailing whitespace
      line = line:match "^%s*(.-)%s*$"

      -- Remove optional "export" keyword
      line = line:gsub("^export%s+", "")

      -- Find the first equals sign
      local pos = line:find "="

      if pos then
        local key = line:sub(1, pos - 1):match "^%s*(.-)%s*$"
        local value = line:sub(pos + 1):match "^%s*(.-)%s*$"

        -- Remove quotes if they exist
        if value:match '^".*"$' or value:match "^'.*'$" then
          value = value:sub(2, -2)
        end

        -- Store in environment table
        env[key] = value
      end
    end
  end

  file:close()
  return env
end

return {
  parse = parse_env_file,
  parse_plugin_env = function()
    local str = debug.getinfo(2, "S").source:sub(2)
    local root = vim.fs.root(str, { ".env" })
    if root then
      return parse_env_file(vim.fs.joinpath(root, ".env"))
    end

    return {}
  end,
  eval = function(file, force)
    local parsed = parse_env_file(file)
    for k, v in pairs(parsed) do
      if force or not vim.env[k] then
        vim.env[k] = v
      end
    end
  end,
}
