return {
  {
    'milanglacier/minuet-ai.nvim',
    config = function()
      require('minuet').setup {
        provider_options = {
          openai_compatible = {
            api_key = function()
              local handle = io.popen 'op read op://Personal/OpenAI/API_Key --no-newline'
              if handle then
                local result = handle:read '*a'
                handle:close()
                return result:gsub('%s+$', '')
              else
                return nil
              end
            end,
          },
        },
      }
    end,
  },
  { 'nvim-lua/plenary.nvim' },
}
