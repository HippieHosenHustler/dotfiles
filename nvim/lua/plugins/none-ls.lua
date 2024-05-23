return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,

        null_ls.builtins.formatting.prettier.with({
          filetypes = { "apex" },
          extra_args = { "--plugin=prettier-plugin-apex", "--write" },
        }),

        null_ls.builtins.diagnostics.eslint_d,

        null_ls.builtins.diagnostics.pmd.with({
          filetypes = { "apex" },
          args = { "check", "--dir", "$ROOT", "--format", "json" },
          extra_args = { "--rulesets", "apex_ruleset.xml" },
        }),
      },
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format)
  end,
}
