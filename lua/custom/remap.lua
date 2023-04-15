vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "zg", '<cmd>spellgood<cr>')

vim.keymap.set('n', '<Leader>wt', [[:lua vim.lsp.buf.format()<cr> <bar> :%s/\s\+$//e<cr>]])
