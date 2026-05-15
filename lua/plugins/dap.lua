return {
	"mfussenegger/nvim-dap",

	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
		"jay-babu/mason-nvim-dap.nvim",
		"mfussenegger/nvim-dap-python",
	},

	keys = {
		-- Stepping (leader-based; no F-keys)
		{
			"<leader>dC",
			function()
				require("dap").continue()
			end,
			desc = "Debug: [C]ontinue / start",
		},
		{
			"<leader>do",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: step [O]ver",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: step [I]nto",
		},
		{
			"<leader>dO",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: step [O]ut (capital)",
		},

		-- Breakpoints
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: [B]reakpoint toggle",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Conditional [B]reakpoint",
		},

		-- UI / session
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "[D]ebug [U]I toggle",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.toggle()
			end,
			desc = "[D]ebug [R]EPL toggle",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "[D]ebug run [L]ast",
		},
		{
			"<leader>de",
			function()
				require("dapui").eval()
			end,
			mode = { "n", "v" },
			desc = "[D]ebug [E]val expression",
		},

		-- Python pytest test debugging
		{
			"<leader>dn",
			function()
				require("dap-python").test_method()
			end,
			desc = "[D]ebug [N]earest test method",
		},
		{
			"<leader>dc",
			function()
				require("dap-python").test_class()
			end,
			desc = "[D]ebug nearest test [C]lass",
		},
		{
			"<leader>ds",
			function()
				require("dap-python").debug_selection()
			end,
			mode = "v",
			desc = "[D]ebug [S]election",
		},
	},

	config = function()
		local dap, dapui = require("dap"), require("dapui")

		-- Mason already has codelldb + debugpy in tool-installer's ensure_installed
		require("mason-nvim-dap").setup({
			ensure_installed = { "python", "codelldb" },
			automatic_installation = true,
			handlers = {},
		})

		-- Python: use 'uv run debugpy' to respect project's uv environment
		require("dap-python").setup("uv")

		-- ============== codelldb adapter (Zig, C, C++, Rust) ==============
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
				args = { "--port", "${port}" },
			},
		}

		local native_configs = {
			{
				name = "Launch executable",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				terminal = "integrated",
				runInTerminal = false,
				args = {},
			},
			{
				name = "Attach to running process",
				type = "codelldb",
				request = "attach",
				pid = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
		}

		dap.configurations.zig = native_configs
		dap.configurations.c = native_configs
		dap.configurations.cpp = native_configs
		dap.configurations.rust = native_configs

		-- ============== UI ==============
		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		dap.listeners.after.event_initialized["user-dapui"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["user-dapui"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["user-dapui"] = function()
			dapui.close()
		end

		-- ============== Inline variable values ==============
		require("nvim-dap-virtual-text").setup({
			enabled = true,
			commented = false,
			virt_text_pos = "eol",
		})

		-- ============== Breakpoint signs ==============
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" }
		)
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = "○", texthl = "DiagnosticHint", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual", numhl = "" })
	end,
}
