return {
  'folke/flash.nvim',
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
    {
      'S',
      mode = { 'n', 'o' },
      function()
        require('flash').jump {
          -- show labels immediately on word starts
          search = { mode = 'search' },
          pattern = '\\<',
          label = { after = { 0, 0 } },
        }
      end,
      desc = 'Flash (word starts, instant labels)',
    },
    {
      'r',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = 'Remote Flash',
    },
    {
      'R',
      mode = 'o',
      function()
        require('flash').treesitter_search()
      end,
      desc = 'Treesitter Search',
    },
    {
      '<c-s>',
      mode = { 'c' },
      function()
        require('flash').toggle()
      end,
      desc = 'Toggle Flash Search',
    },
  },
  dependencies = {
    {
      'folke/snacks.nvim',
      opts = function(_, opts)
        opts = opts or {}
        opts.picker = opts.picker or {}
        opts.picker.win = opts.picker.win or {}
        opts.picker.win.input = opts.picker.win.input or {}
        opts.picker.win.input.keys = vim.tbl_extend('force', opts.picker.win.input.keys or {}, {
          ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
          ['s'] = { 'flash', mode = { 'n' } },
        })

        opts.picker.actions = opts.picker.actions or {}
        opts.picker.actions.flash = function(picker)
          require('flash').jump {
            pattern = '^',
            label = { after = { 0, 0 } },
            search = {
              mode = 'search',
              exclude = {
                function(win)
                  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
                end,
              },
            },
            action = function(match)
              local idx = picker.list:row2idx(match.pos[1])
              picker.list:_move(idx, true, true)
            end,
          }
        end

        return opts
      end,
    },
  },
}
