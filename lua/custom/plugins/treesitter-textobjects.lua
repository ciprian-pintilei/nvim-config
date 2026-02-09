return {
  { -- Extend nvim-treesitter opts with textobjects config.
    -- Lazy.nvim merges opts from all specs for the same plugin,
    -- so this is applied alongside the treesitter opts in init.lua.
    'nvim-treesitter/nvim-treesitter',
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- Function textobjects with different mappings to avoid conflicts with mini.ai
            ['aF'] = '@function.outer',
            ['iF'] = '@function.inner',
            -- Class textobjects
            ['aC'] = '@class.outer',
            ['iC'] = '@class.inner',
          },
          selection_modes = {
            ['@function.outer'] = 'V', -- linewise
            ['@function.inner'] = 'v', -- characterwise for better control
            ['@class.outer'] = 'V', -- linewise
            ['@class.inner'] = 'v', -- characterwise
          },
          include_surrounding_whitespace = false,
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']C'] = '@class.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[C'] = '@class.outer',
          },
        },
      },
    },
  },
  { -- Declare the textobjects plugin itself as a dependency of treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
}
