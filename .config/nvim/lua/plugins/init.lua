return {
	-- Disable/enable plugins
	-- { "folke/noice.nvim", enabled = false },
	-- { "rcarriga/nvim-notify", enabled = false },

	-- Custom config
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			transparent_background = true,
		},
	},

	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			filesystem = {
				filtered_items = {
					visible = true,
					show_hidden_count = true,
					hide_dotfiles = false,
				},
			},
			window = {
				mappings = {
					["<space>"] = "none",
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "+",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_z = {},
			},
		},
	},

	-- add PHP to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "php" })
			end
		end,
	},

	-- add phpactor to lspconfig
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- make sure mason installs the server
			servers = {
				phpactor = {},
			},
		},
	},

	{
		-- LazyExtras
		{ import = "lazyvim.plugins.extras.ui.edgy" },
		{ import = "lazyvim.plugins.extras.util.dot" },
		{ import = "lazyvim.plugins.extras.coding.yanky" },
		{ import = "lazyvim.plugins.extras.editor.symbols-outline" },
		{ import = "lazyvim.plugins.extras.formatting.prettier" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.yaml" },
		{ import = "lazyvim.plugins.extras.lang.markdown" },
	},
}
