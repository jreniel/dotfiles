-- lua/jrcalzada/core/autocmd.lua
-----------------------------------------------------------
-- Autocommand functions
-----------------------------------------------------------

-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup

local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

-- General settings:
--------------------

-- Highlight on yank
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '1000' })
  end
})

-- Remove whitespace on save
autocmd('BufWritePre', {
  pattern = '',
  command = ":%s/\\s\\+$//e"
})

-- Disable line length marker
augroup('setLineLength', { clear = true })
autocmd('Filetype', {
  group = 'setLineLength',
  pattern = { 'text', 'markdown', 'html', 'xhtml', 'javascript', 'typescript' },
  command = 'setlocal cc=0'
})

-- Set indentation to 2 spaces
augroup('setIndent', { clear = true })
autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
    'yaml', 'lua'
  },
  command = 'setlocal shiftwidth=2 tabstop=2'
})

-- local autocmd_group = vim.api.nvim_create_augroup("Custom auto-commands", { clear = true })

-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--     pattern = { "*.yaml", "*.yml" },
--     desc = "Auto-format YAML files after saving",
--     callback = function()
--         local fileName = vim.api.nvim_buf_get_name(0)
--         vim.cmd(":silent !yamlfmt " .. fileName)
--     end,
--     group = autocmd_group,
-- })


-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--     pattern = { "*.py" },
--     desc = "Auto-format Python files after saving",
--     callback = function()
--         local fileName = vim.api.nvim_buf_get_name(0)
--         vim.cmd(":silent !black --preview -q " .. fileName)
--         vim.cmd(":silent !isort --profile black --float-to-top -q " .. fileName)
--         vim.cmd(":silent !docformatter --in-place --black " .. fileName)
--     end,
--     group = autocmd_group,
-- })


-- local augroup_lsp = vim.api.nvim_create_augroup("LspFormatting", {})
-- require("none-ls").setup({
--     -- you can reuse a shared lspconfig on_attach callback here
--     on_attach = function(client, bufnr)
--         if client.supports_method("textDocument/formatting") then
--             vim.api.nvim_clear_autocmds({ group = augroup_lsp, buffer = bufnr })
--             vim.api.nvim_create_autocmd("BufWritePre", {
--                 group = augroup_lsp,
--                 buffer = bufnr,
--                 callback = function()
--                     -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
--                     -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
--                     vim.lsp.buf.formatting_sync()
--                 end,
--             })
--         end
--     end,
-- })
