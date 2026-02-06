return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  lazy = false,
  priority = 1000, -- Load before mini.ai to take precedence
  config = function()
    require('nvim-treesitter.configs').setup {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- Function textobjects with different mappings to avoid conflicts
            ['aF'] = '@function.outer',
            ['iF'] = '@function.inner',
            -- Class textobjects
            ['aC'] = '@class.outer',
            ['iC'] = '@class.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
          selection_modes = {
            ['@function.outer'] = 'V', -- linewise
            ['@function.inner'] = 'v', -- characterwise for better control
            ['@class.outer'] = 'V', -- linewise
            ['@class.inner'] = 'v', -- characterwise
          },
          include_surrounding_whitespace = false, -- Disable globally
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
        },
      },
    }

    -- Python-specific fix for inner function selection
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'python',
      callback = function()
        -- Override 'if' for Python to handle indentation properly
        vim.keymap.set({ 'o', 'x' }, 'if', function()
          -- Save current position
          local cursor = vim.api.nvim_win_get_cursor(0)

          -- Try the textobject selection
          vim.cmd 'normal! vif'

          -- Get the selected region
          local start_pos = vim.fn.getpos "'<"
          local end_pos = vim.fn.getpos "'>"

          -- Check if we're in visual mode and have a selection
          if vim.fn.mode():match '[vV]' then
            -- Adjust the end position to not include trailing blank lines
            local end_line = end_pos[2]
            local buf = vim.api.nvim_get_current_buf()
            local lines = vim.api.nvim_buf_get_lines(buf, end_line - 1, end_line, false)

            -- If the last selected line is empty or the next line after selection starts with def/class
            if end_line > start_pos[2] then
              local next_lines = vim.api.nvim_buf_get_lines(buf, end_line - 1, math.min(end_line + 2, vim.api.nvim_buf_line_count(buf)), false)
              for i, line in ipairs(next_lines) do
                if line:match '^%s*$' then
                  -- Empty line, continue checking
                elseif line:match '^def%s' or line:match '^class%s' or line:match '^%S' then
                  -- Found start of next function/class or unindented line
                  end_line = end_line + i - 2
                  break
                else
                  -- Non-empty line that's part of the function
                  break
                end
              end

              -- Update selection
              vim.fn.setpos("'>", { end_pos[1], end_line, vim.fn.col { end_line, '$' }, 0 })
              vim.cmd 'normal! gv'
            end
          end
        end, { buffer = true, desc = 'Select inside function (Python-specific)' })
      end,
    })
  end,
}

