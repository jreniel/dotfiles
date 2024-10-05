local cmd = vim.cmd

-- Resolves :E ambiguity
vim.cmd('command! -nargs=0 E Explore')
