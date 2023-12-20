local keymap = vim.keymap

-- Toggle mouse with F3
keymap.set("n", "<F3>", [[<ESC>:exec &mouse!=""? "set mouse=" : "set mouse=nv"<CR>]])
