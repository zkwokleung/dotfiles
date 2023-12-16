require("lazy").setup({
	-- Package Manager
	{
		"williamboman/mason.nvim",
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},

	-- LSP
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		lazy = false,
	},

	-- DAP
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"Pocco81/DAPInstall.nvim",
		},
	},

	-- Lint
	{
		"mfussenegger/nvim-lint",
	},
	{
		"dense-analysis/ale",
	},

	-- Formatter
	{
		"mhartington/formatter.nvim",
	},
	{
		"vim-autoformat/vim-autoformat",
	},

	-- UI
	{
		"goolord/alpha-nvim",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
	},
	{
		"rcarriga/nvim-notify",
	},
	{
		"nvim-lualine/lualine.nvim",
	},

	-- Completion
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"jiangmiao/auto-pairs",
	},
	{
		"neoclide/coc.nvim",
		branch = "release",
	},

	-- Snippet
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/cmp-cmdline",
			"neovim/nvim-lspconfig",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	},

	-- Theme
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},

	-- Make your life easier
	{
		"preservim/nerdcommenter",
	},
	{
		"mg979/vim-visual-multi",
		branch = "master",
	},
	{
		"junegunn/fzf",
	},
	{
		"romgrk/barbar.nvim",
	},
	{
		"github/copilot.vim",
	},
})
