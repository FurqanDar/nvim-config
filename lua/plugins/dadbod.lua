return {
	"tpope/vim-dadbod",
	dependencies = {
		"kristijanhusak/vim-dadbod-ui",
		"kristijanhusak/vim-dadbod-completion",
	},
	cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
	keys = {
		{ "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle [D]B UI" },
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"
		vim.g.db_ui_show_database_icon = 1
		vim.g.db_ui_force_echo_notifications = 1
		vim.g.db_ui_win_position = "left"
		vim.g.db_ui_winwidth = 35

		-- Supabase local dev: Postgres on port 54322 (NOT default 5432)
		vim.g.dbs = {
			["agent-query (supabase local)"] = "postgresql://postgres:postgres@127.0.0.1:54322/postgres",
			-- Add more connections here as needed
		}
	end,
}
