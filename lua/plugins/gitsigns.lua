return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },

	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},

		current_line_blame = false,
		current_line_blame_opts = {
			virt_text_pos = "eol",
			delay = 500,
		},

		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			-- Hunk navigation: ]c / [c PLUS leader-aliases <leader>hn / <leader>hN
			local function next_hunk()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end
			local function prev_hunk()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end

			map("n", "]c", next_hunk, "Jump to next git [c]hange")
			map("n", "[c", prev_hunk, "Jump to previous git [c]hange")
			map("n", "<leader>hn", next_hunk, "Git [h]unk [n]ext")
			map("n", "<leader>hN", prev_hunk, "Git [h]unk previous (capital [N])")

			-- Hunk actions
			map("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Git [s]tage hunk (visual range)")

			map("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Git [r]eset hunk (visual range)")

			-- stage_hunk now toggles (modern API); no separate undo binding
			map("n", "<leader>hs", gitsigns.stage_hunk, "Git [s]tage hunk (toggles)")
			map("n", "<leader>hr", gitsigns.reset_hunk, "Git [r]eset hunk")
			map("n", "<leader>hS", gitsigns.stage_buffer, "Git [S]tage entire buffer")
			map("n", "<leader>hR", gitsigns.reset_buffer, "Git [R]eset entire buffer")
			map("n", "<leader>hp", gitsigns.preview_hunk, "Git [p]review hunk")
			map("n", "<leader>hb", gitsigns.blame_line, "Git [b]lame line")
			map("n", "<leader>hd", gitsigns.diffthis, "Git [d]iff against index")
			map("n", "<leader>hD", function()
				gitsigns.diffthis("@")
			end, "Git [D]iff against last commit")

			-- Toggles under <leader>t namespace
			map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "[T]oggle git [b]lame line")
			map("n", "<leader>tD", gitsigns.toggle_deleted, "[T]oggle git show [D]eleted")
		end,
	},
}
