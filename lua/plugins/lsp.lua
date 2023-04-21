return {
  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        'lua_ls',
        "stylua",
        "prettier",
        -- "autopep8",
        "pylint",
        "pydocstyle",
        "flake8",
        "isort",
        "black",
        "djlint",
        "markdownlint",
        "shellcheck",
        "shfmt",
        "jq",
        -- "djhtml",
        -- "zsh",
      },
    },
  },
  -- add LSP Server  to lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = { },
    config = function ()
      require('mason').setup()
      require('mason-lspconfig').setup()

      require('lspconfig').lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "hs" },
            },
          },
        },
      })

      require('lspconfig').pyright.setup({
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      require('lspconfig').emmet_ls.setup({
        filetypes = {
          "htmldjango",
          "html",
          "css",
          "scss",
          "typescriptreact",
          "javascriptreact",
          "markdown",
        },
        init_options = {
          html = {
            options = {
              ["bem.enabled"] = true,
            },
          },
        },
      })

      require('lspconfig').jsonls.setup({
        filetypes = { "json", "jsonc" },
        commands = {
          Format = {
            function()
              vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
            end,
          },
        },
        init_options = {
          provideFormatter = true,
        },
        single_file_support = true,
      })

      require('lspconfig').texlab.setup({
        settings = {
          texlab = {
            auxDirectory = ".",
            bibtexFormatter = "texlab",
            build = {
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              executable = "latexmk",
              forwardSearchAfter = false,
              onSave = false,
            },
            chktex = {
              onEdit = false,
              onOpenAndSave = false,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
              args = {},
            },
            latexFormatter = "latexindent",
            latexindent = {
              modifyLineBreaks = false,
            },
          },
        },
      })
    end
  },
  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    -- dependencies = { "mason.nvim" },
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
