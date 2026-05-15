return {
	"folke/which-key.nvim",
	event = "VimEnter",
	opts = {
		icons = {
			mappings = vim.g.have_nerd_font,
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.add({
			{ "<leader>c", group = "[C]ode (LSP)" },
			{ "<leader>d", group = "[D]ebug (DAP)" },
			{ "<leader>g", group = "[G]it (repo-level via telescope)" },
			{ "<leader>h", group = "Git [H]unk (gitsigns)" },
			{ "<leader>n", group = "[N]eotest" },
			{ "<leader>r", group = "[R]ename (LSP)" },
			{ "<leader>s", group = "[S]earch (telescope)" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>w", group = "[W]orkspace (LSP)" },
		})
	end,
}
