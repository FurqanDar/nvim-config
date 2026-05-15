return {
	"chomosuke/typst-preview.nvim",
	ft = "typst",
	version = "1.*",
	opts = {},
	config = function(_, opts)
		require("typst-preview").setup(opts)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "typst",
			callback = function(args)
				vim.keymap.set("n", "<leader>p", vim.cmd.TypstPreview, {
					buffer = args.buf,
					desc = "Toggle Typst [P]review",
				})
			end,
		})
	end,
}
