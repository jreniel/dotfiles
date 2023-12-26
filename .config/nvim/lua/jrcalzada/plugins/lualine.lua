return {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  config = function()
      require('lualine').setup(
      -- {
      --   sections = {
      --       -- lualine_x = { { 'filename', file_status = false, path = 1 } },
      --       -- lualine_c = {require('auto-session.lib').current_session_name}
      --   },
      -- }
      )
  end
}
