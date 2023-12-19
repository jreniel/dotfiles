
-- Toggle mouse with F3
vim.keymap.set("n", "<F3>", [[<ESC>:exec &mouse!=""? "set mouse=" : "set mouse=nv"<CR>]]) 
