-- lua/jrcalzada/plugins/lsp-zero.lua
return {
	"VonHeikemen/lsp-zero.nvim",
	branch = "v3.x",
	dependencies = {
		-- LSP Support
		{ "neovim/nvim-lspconfig" }, -- Required
		{ "williamboman/mason.nvim" }, -- Optional
		{ "williamboman/mason-lspconfig.nvim" }, -- Optional

		-- Autocompletion
		{ "hrsh7th/nvim-cmp" }, -- Required
		{ "hrsh7th/cmp-nvim-lsp" }, -- Required
		{ "L3MON4D3/LuaSnip" }, -- Required
	},
	config = function()
		local lsp_zero = require("lsp-zero")

		lsp_zero.extend_lspconfig()

		lsp_zero.on_attach(function(client, bufnr)
			-- Default keymaps
			lsp_zero.default_keymaps({ buffer = bufnr })
			
			-- Add your custom keymaps here
			local opts = { noremap = true, silent = true, buffer = bufnr }
			local keymap = vim.keymap

			-- Custom keymaps (from your lspconfig.lua)
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			keymap.set("n", "K", vim.lsp.buf.hover, opts)
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
		end)

		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = {
				"rust_analyzer",
				"tsserver", 
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				-- Note: jdtls is handled separately by nvim-jdtls
			},
			automatic_installation = true,
			handlers = {
				-- Default handler
				lsp_zero.default_setup,
				
				-- Lua specific setup
				lua_ls = function()
					local lua_opts = lsp_zero.nvim_lua_ls()
					require("lspconfig").lua_ls.setup(lua_opts)
				end,
				
				-- Skip rust_analyzer (handled by rustaceanvim)
				rust_analyzer = function()
					return true
				end,
				
				-- Skip jdtls (handled by nvim-jdtls)
				jdtls = function()
					return true
				end,
			},
		})

		-- Setup completion
		local cmp = require("cmp")
		local cmp_format = lsp_zero.cmp_format()

		cmp.setup({
			formatting = cmp_format,
			mapping = cmp.mapping.preset.insert({
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
			}),
		})

		-- Diagnostic signs
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
	end,
}