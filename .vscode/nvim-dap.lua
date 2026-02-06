-- Project-specific nvim-dap configuration for sd-copilot
-- This file is automatically loaded by nvim-dap if present in .vscode/

return function(dap)
  -- Helper function to load .env file and merge with PYTHONPATH
  local function load_env_with_pythonpath()
    local cwd = vim.fn.getcwd()
    local env = {}
    
    -- Load .env file if it exists
    local env_file = cwd .. '/.env'
    if vim.fn.filereadable(env_file) == 1 then
      for line in io.lines(env_file) do
        -- Skip comments and empty lines
        if line:match '^%s*[^#]' then
          local key, value = line:match '^%s*([%w_]+)%s*=%s*(.+)%s*$'
          if key and value then
            -- Remove quotes if present
            value = value:gsub('^["\']', ''):gsub('["\']$', '')
            env[key] = value
          end
        end
      end
    end
    
    -- Always set PYTHONPATH to workspace root
    env.PYTHONPATH = cwd
    
    return env
  end

  -- Configure Python debugging to match VS Code settings
  table.insert(dap.configurations.python, {
    type = 'python',
    request = 'launch',
    name = 'Launch Current File (with src in PYTHONPATH)',
    program = '${file}',
    console = 'integratedTerminal',
    cwd = '${workspaceFolder}',
    env = load_env_with_pythonpath,
  })

  -- Add configuration for SD Copilot App
  table.insert(dap.configurations.python, {
    type = 'python',
    request = 'launch',
    name = 'SD Copilot App',
    program = function()
      local cwd = vim.fn.getcwd()
      return cwd .. '/src/sdcopilot_app/app.py'
    end,
    console = 'integratedTerminal',
    cwd = function()
      return vim.fn.getcwd()
    end,
    env = load_env_with_pythonpath,
  })
end
