return {
  {
    "stevearc/conform.nvim",
    config = function()
      require "configs.conform"
    end,
  },
  {
  	"williamboman/mason.nvim",
    config = function()
      require('mason').setup()
    end,
    opts = {
  		ensure_installed = {
  			"lua-language-server", "stylua", "prettier", "ts_ls"
  		},
  	},
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css"
  		},
  	},
  },
}
