return {
  -- add any tools you want to have installed below
  { "williamboman/mason.nvim" },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {},
  },
  -- add LSP Server  to lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("lazyvim.util").has("nvim-cmp")
        end,
      },
    },
    opts = {},
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "diagnosticls",
          "emmet_ls",
          "jsonls",
          "lua_ls",
          "pyright",
          "texlab",
        },
      })

      require("plugins.lsp.config.lua_ls").setup()
      require("plugins.lsp.config.emmet_ls").setup()
      require("plugins.lsp.config.jsonls").setup()
      require("plugins.lsp.config.pyright").setup()
      require("plugins.lsp.config.texlab").setup()
    end,
  },
  -- mason-null-ls
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    opts = {},
  },
  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    config = function()
      local nls = require("null-ls")
      local lsp_format_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      local nls_on_attach = function(current_client, bufnr)
        -- to setup format on save
        if current_client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = lsp_format_augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = lsp_format_augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                filter = function(client) -- luacheck: ignore
                  --  only use null-ls for formatting instead of lsp server
                  return client.name == "null-ls"
                end,
                bufnr = bufnr,
              })
            end,
          })
        end
      end

      require("mason-null-ls").setup({
        ensure_installed = {
          "stylua",
          "prettier",
          -- "autopep8",
          "pylint",
          "pydocstyle",
          "flake8",
          "isort",
          "black",
          "djhtml",
          "djlint",
          "markdownlint",
          "zsh",
          "shellcheck",
          "shfmt",
          "jq",
        },
        automatic_installation = false,
        handlers = {},
      })
      nls.setup({
        on_attach = nls_on_attach,
        sources = {
          -- YAML/JSON
          nls.builtins.diagnostics.spectral,
          nls.builtins.diagnostics.yamllint,
          nls.builtins.formatting.jq,
          nls.builtins.formatting.fixjson,
          -- Lua Script
          nls.builtins.formatting.stylua,
          -- Shell / ZSH
          nls.builtins.diagnostics.zsh,
          nls.builtins.diagnostics.shellcheck,
          nls.builtins.formatting.shfmt,
          -- Python
          nls.builtins.diagnostics.flake8,
          nls.builtins.diagnostics.pylint.with({
            -- extra_args = { "--load-plugins", "pylint_django" },
            -- init_options = {
            --     "init-hook='import sys; import os; from pylint.config import find_pylintrc; sys.path.append(os.path.dirname(find_pylintrc()))'",
            -- },
          }),
          nls.builtins.diagnostics.pydocstyle.with({
            extra_args = { "--config=$ROOT/setup.cfg" },
          }),
          nls.builtins.diagnostics.mypy.with({
            extra_args = { "--config-file", "pyproject.toml" },
          }),
          nls.builtins.formatting.isort,
          nls.builtins.formatting.black,
          nls.builtins.formatting.djhtml,
          nls.builtins.formatting.djlint,
          -- Markdown
          nls.builtins.formatting.markdown_toc,
          nls.builtins.formatting.markdownlint,
          -- Web Tools
          nls.builtins.diagnostics.stylelint,
          nls.builtins.formatting.eslint,
          nls.builtins.formatting.prettier.with({
            filetypes = {
              "html",
              "css",
              "scss",
              "less",
              "javascript",
              "typescript",
              "vue",
              "json",
              "jsonc",
              "yaml",
              "markdown",
              "handlebars",
            },
            extra_filetypes = {},
          }),
        },
      })
    end,
  },
}
