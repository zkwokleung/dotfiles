require("lazy").setup(
  {
    -- Package Manager
    {
      "williamboman/mason.nvim"
    },

    -- UI
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",         -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      }
    },

    -- Autocomplete
    {
      "gelguy/wilder.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      }
    },

    -- Theme
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
    }
  }
)
