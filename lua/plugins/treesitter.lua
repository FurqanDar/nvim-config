return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main", -- master branch is archived (April 2026)
	lazy = false,
	build = ":TSUpdate",

	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {
				max_lines = 3,
				min_window_height = 20,
				trim_scope = "outer",
				mode = "cursor",
			},
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
		},
	},

	config = function()
		local parsers = {
			-- Editor / config
			"bash",
			"lua",
			"luadoc",
			"vim",
			"vimdoc",
			"query",
			"regex",
			-- Languages
			"python",
			"typescript",
			"tsx",
			"javascript",
			"c",
			-- Markup / data
			"markdown",
			"markdown_inline",
			"json",
			"yaml",
			"toml",
			"html",
			"css",
			"scss",
			-- Tooling / DS / agent-query stack
			"dockerfile",
			"sql",
			"csv",
			"typst",
			-- Git
			"diff",
			"gitcommit",
			"gitignore",
			"gitattributes",
			"git_config",
			"git_rebase",
		}

		-- Idempotent install (no-op if already installed)
		require("nvim-treesitter").install(parsers)

		-- Enable highlighting + folding + indent per buffer on FileType
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
			callback = function(args)
				local buf = args.buf
				local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
				if not lang then
					return
				end
				if not pcall(vim.treesitter.start, buf, lang) then
					return
				end

				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo.foldmethod = "expr"

				-- nvim-treesitter main-branch indent returns wildly wrong values when
				-- the AST has errors (constant mid-typing). Worst on python: hitting :
				-- inside a hanging-paren method signature jumps indent to 12 spaces.
				-- Fall back to $VIMRUNTIME/indent/python.vim, which is mature.
				-- Keep treesitter indent for other languages until proven broken.
				if vim.bo[buf].filetype ~= "python" then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})

		-- Textobjects: main branch removed declarative config; wire keymaps manually
		local select = function(query)
			return function()
				require("nvim-treesitter-textobjects.select").select_textobject(query)
			end
		end
		local move_next = function(query)
			return function()
				require("nvim-treesitter-textobjects.move").goto_next_start(query)
			end
		end
		local move_prev = function(query)
			return function()
				require("nvim-treesitter-textobjects.move").goto_previous_start(query)
			end
		end

		for _, mode in ipairs({ "x", "o" }) do
			vim.keymap.set(mode, "af", select("@function.outer"), { desc = "[A]round [F]unction" })
			vim.keymap.set(mode, "if", select("@function.inner"), { desc = "[I]nside [F]unction" })
			vim.keymap.set(mode, "ac", select("@class.outer"), { desc = "[A]round [C]lass" })
			vim.keymap.set(mode, "ic", select("@class.inner"), { desc = "[I]nside [C]lass" })
			vim.keymap.set(mode, "aa", select("@parameter.outer"), { desc = "[A]round p[A]rameter" })
			vim.keymap.set(mode, "ia", select("@parameter.inner"), { desc = "[I]nside p[A]rameter" })
		end

		-- ]f / [f for function motion. NOT ]c / [c (gitsigns owns those for hunks).
		vim.keymap.set("n", "]f", move_next("@function.outer"), { desc = "Next function" })
		vim.keymap.set("n", "[f", move_prev("@function.outer"), { desc = "Previous function" })

		vim.keymap.set("n", "<leader>tc", function()
			require("treesitter-context").toggle()
		end, { desc = "[T]oggle Treesitter [C]ontext" })
	end,
}
