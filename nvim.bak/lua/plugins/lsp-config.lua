return {
  {
    "williamboman/mason.nvim",
    lazy = false,
  },
  {
    "williamboman/mason-lspconfig.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "apex_ls", "tsserver" },
      })

      local on_attach = function(_, bufnr)
        local toggleInlay = function()
          local current_value = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
          vim.lsp.inlay_hint.enable(not current_value, { bufnr = 0 })
        end

        local nmap = function(keys, func, desc)
          if desc then
            desc = desc .. " [LSP]"
          end

          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        vim.keymap.set("n", "D", vim.diagnostic.open_float, {})
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
        vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
      end

      -- Enable the following language servers in Mason
      local servers = {
        rust_analyzer = {},
        lua_ls = {
          Lua = {
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
            diagnostics = {
              globals = { "vim" },
              -- disable = { 'missing-fields' }
            },
          },
        },
      }
      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
          })
        end,
      })

      -- `mason_lspconfig.setup_handlers` doesn't handle apex_ls automaticlally (why not?), we need to manually attach below actions
      local lspconfig = require("lspconfig")
      local mason_registry = require("mason-registry")
      local apex_server = mason_registry.get_package("apex-language-server")
      local jar_path = apex_server:get_install_path() .. "/extension/dist/apex-jorje-lsp.jar"

      lspconfig.apex_ls.setup({
        cmd = {
          "java",
          "-jar",
          jar_path,
          "apex_language_server",
        },
        apex_enable_semantic_errors = false,
        apex_enable_completion_statistics = false,
        filetypes = { "apex", "apexcode" },
        root_dir = lspconfig.util.root_pattern("sfdx-project.json"),

        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
  },
}
