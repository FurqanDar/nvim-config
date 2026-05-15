return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = "BufReadPost",

	init = function()
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
	end,

	config = function()
		-- Filetypes/buftypes where ufo should never attach. Used both by the
		-- provider_selector (attach-time check) and by the detach autocmd below
		-- (post-mutation safety net).
		local function should_skip(bufnr, filetype, buftype)
			if buftype ~= "" then
				return true
			end -- terminal, prompt, nofile, quickfix
			local skip_ft = {
				["minifiles"] = true,
				["minifiles-window"] = true,
				["undotree"] = true,
				["diff"] = true,
				["neo-tree"] = true,
				["oil"] = true,
				["help"] = true,
				["lazy"] = true,
				["mason"] = true,
				["fugitive"] = true,
				["TelescopePrompt"] = true,
				["TelescopeResults"] = true,
				["noice"] = true,
				["Trouble"] = true,
				["qf"] = true,
				["which-key"] = true,
				["snacks_picker_input"] = true,
				["snacks_picker_list"] = true,
			}
			if skip_ft[filetype] then
				return true
			end
			if filetype:match("^dapui") then
				return true
			end
			if filetype:match("^minifiles") then
				return true
			end
			return false
		end

		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				if should_skip(bufnr, filetype, buftype) then
					return ""
				end
				-- {'lsp', 'indent'} not {'lsp', 'treesitter'}: indent ALWAYS succeeds,
				-- so the fallback chain can't bottom out as UnhandledPromiseRejection.
				-- The plan's {'lsp', 'treesitter'} explodes whenever a buffer's
				-- filetype has no treesitter parser AND LSP didn't return folds.
				return { "lsp", "indent" }
			end,
			preview = {
				win_config = {
					border = "rounded",
					winhighlight = "Normal:Folded",
					winblend = 0,
				},
				mappings = {
					scrollU = "<C-u>",
					scrollD = "<C-d>",
				},
			},
		})

		-- Fold open/close keymaps
		vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
		vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
		vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with level" })

		-- Smart K: peek fold if on closed fold; else fall through to LSP hover.
		-- vim.lsp.buf.hover() is safe no-op when no LSP attached.
		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if winid then
				return
			end
			vim.lsp.buf.hover()
		end, { desc = "Peek fold / LSP hover" })

		-- Safety net: detach ufo on special buffers whose filetype/buftype only
		-- resolves AFTER ufo attached (terminal post-`:terminal`, dap-ui panes,
		-- telescope previews, fidget popups). provider_selector's result is
		-- cached, so it can't catch these post-attach state mutations.
		-- detach() alone is the documented disable mechanism — foldenable is
		-- window-local, not buffer-local, so trying to set it via vim.bo errors.
		vim.api.nvim_create_autocmd({ "FileType", "TermOpen" }, {
			group = vim.api.nvim_create_augroup("user-ufo-detach-special", { clear = true }),
			callback = function(args)
				local buf = args.buf
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end
				if should_skip(buf, vim.bo[buf].filetype, vim.bo[buf].buftype) then
					pcall(require("ufo").detach, buf)
				end
			end,
		})
	end,
}
