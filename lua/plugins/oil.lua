return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"refractalize/oil-git-status.nvim",
	},
	lazy = false,
	keys = {
		{
			"-",
			function()
				require("oil").open_float()
			end,
			desc = "Open parent dir (oil float)",
		},
	},
	opts = {
		default_file_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = false,

		view_options = {
			show_hidden = true,
			is_always_hidden = function(name, _)
				return name == ".."
			end,
		},

		float = {
			padding = 2,
			max_width = 100,
			max_height = 30,
			border = "rounded",
			win_options = { winblend = 0 },
		},

		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<leader>v"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
			["<leader>s"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
			["<leader>t"] = { "actions.select", opts = { tab = true }, desc = "Open in new tab" },
			["<leader>p"] = "actions.preview",
			["q"] = "actions.close",
			["R"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},
	},
	config = function(_, opts)
		require("oil").setup(opts)
		require("oil-git-status").setup()
	end,
}
