return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  keys = {
    { '-', '<cmd>Oil<CR>', desc = 'Open parent directory with oil' },
  },
  view_options = {
    show_hidden = true,
    is_hidden_file = function(name, bufnr)
      local m = name:match '^%.'
      return m ~= nil
    end,
    -- This function defines what will never be shown, even when `show_hidden` is set
    is_always_hidden = function(name, bufnr)
      return false
    end,
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
}
