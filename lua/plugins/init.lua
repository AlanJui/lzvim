return {
  "vim-test/vim-test",
  "lewis6991/gitsigns.nvim",
  "preservim/vimux",
  "christoomey/vim-tmux-navigator",
  "tpope/vim-fugitive",
  "folke/which-key.nvim",
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("plugin_config.toggleterm")
    end,
  },
  -- "nvim-treesitter/nvim-treesitter",
  -- "nvim-tree/nvim-tree.lua",
  -- "nvim-tree/nvim-web-devicons",
  -- "nvim-lualine/lualine.nvim",
  -- auto-completion
  -- 'hrsh7th/nvim-cmp',
  -- 'hrsh7th/cmp-nvim-lsp',
  -- 'L3MON4D3/LuaSnip',
  -- 'saadparwaiz1/cmp_luasnip',
  -- "rafamadriz/friendly-snippets",
  -- "github/copilot.vim",
  -- "williamboman/mason.nvim",
  -- "neovim/nvim-lspconfig",
  -- "williamboman/mason-lspconfig.nvim",
  -- "glepnir/lspsaga.nvim",
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   tag = "0.1.0",
  --   dependencies = { { "nvim-lua/plenary.nvim" } },
  -- },
  -- "ellisonleao/gruvbox.nvim",
  -- {
  --   "dracula/vim",
  --   lazy = false,
  -- },
  -- "bluz71/vim-nightfly-colors",
}
