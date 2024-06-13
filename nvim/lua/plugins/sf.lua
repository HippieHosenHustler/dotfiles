return {
  "xixiaofinland/sf.nvim",
  branch = "dev", -- use `main` if you want the more stable version

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "ibhagwan/fzf-lua", -- no need if you don't use listing metadata feature
  },

  config = function()
    require("sf").setup() -- Important to call setup() to initialize the plugin!
  end,
}
