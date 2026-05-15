return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" },
	keys = {
		{ "<leader>st", "<cmd>TodoTelescope<CR>", desc = "[S]earch [T]odo comments" },
	},
	opts = { signs = false },
}
