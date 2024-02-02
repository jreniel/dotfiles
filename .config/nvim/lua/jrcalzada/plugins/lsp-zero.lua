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
		-- py_lsp
		-- {'HallerPatrick/py_lsp.nvim'},
	},
	config = function()
		local lsp_zero = require("lsp-zero")

		lsp_zero.extend_lspconfig()

		lsp_zero.on_attach(function(client, bufnr)
			-- see :help lsp-zero-keybindings
			-- to learn the available actions
			lsp_zero.default_keymaps({ buffer = bufnr })
		end)
		-- lsp_zero.setup_servers({'lua_ls', 'rust_analyzer'})
		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = {},
			handlers = {
				lsp_zero.default_setup,
				lua_ls = function()
					local lua_opts = lsp_zero.nvim_lua_ls()
					require("lspconfig").lua_ls.setup(lua_opts)
				end,
				rust_analyzer = function()
					return true
					-- require("lspconfig").rust_analyzer.setup({
					-- 	cmd = {
					-- 		"rustup",
					-- 		"run",
					-- 		"stable",
					-- 		"rust-analyzer",
					-- 	},
					-- 	diagnostics = {
					-- 		enable = false,
					-- 	},
					-- 	checkOnSave = {
					-- 		allFeatures = true,
					-- 		overrideCommand = {
					-- 			"cargo",
					-- 			"clippy",
					-- 			"--workspace",
					-- 			"--message-format=json",
					-- 			"--all-targets",
					-- 			"--all-features",
					-- 		},
					-- 	},
					-- })
				end,
			},
		})

		local cmp = require("cmp")
		local cmp_format = lsp_zero.cmp_format()

		cmp.setup({
			formatting = cmp_format,
			mapping = cmp.mapping.preset.insert({
				-- scroll up and down the documentation window
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
			}),
		})

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- require("py_lsp").setup()

		--     local lsp = require('lsp-zero').preset({})

		--     lsp.on_attach(function(client, bufnr)
		--       -- see :help lsp-zero-keybindings
		--       -- to learn the available actions
		--       lsp.default_keymaps({buffer = bufnr})
		--     end)

		--     -- (Optional) Configure lua language server for neovim
		--     require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

		--     lsp.setup()
	end,
}
