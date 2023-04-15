local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	debug = false,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					-- vim.lsp.buf.formatting_sync()
					-- vim.lsp.buf.format({
					-- 	bufnr = bufnr,
					-- 	filter = function(client)
					-- 		return client.name == "null-ls"
					-- 	end,
					-- })
				end,
			})
		end
	end,
	sources = {
		-- lua
		null_ls.builtins.formatting.stylua,

		-- frontend: css,js,yaml etc
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.diagnostics.eslint,

		-- python
		null_ls.builtins.diagnostics.pylint,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
	},
})
