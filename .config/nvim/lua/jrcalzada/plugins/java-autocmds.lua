-- lua/jrcalzada/plugins/java-autocmds.lua
-- Additional Java-specific configurations and autocommands

return {
  "mfussenegger/nvim-jdtls", -- We depend on jdtls being loaded
  ft = "java",
  config = function()
    -- Create Java-specific autocommands
    local java_augroup = vim.api.nvim_create_augroup("JavaSettings", { clear = true })
    
    -- Set Java-specific options
    vim.api.nvim_create_autocmd("FileType", {
      group = java_augroup,
      pattern = "java",
      callback = function()
        -- Set Java-specific indentation (2 spaces to match your config pattern)
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        
        -- Enable line numbers (if not already set globally)
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
        
        -- Set colorcolumn for Java files (optional - uncomment if desired)
        -- vim.opt_local.colorcolumn = "120"
        
        -- Configure folding for Java
        vim.opt_local.foldmethod = "syntax"
        vim.opt_local.foldlevel = 99 -- Don't fold by default
      end,
    })

    -- Auto-format Java files on save (integrated with JDTLS)
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = java_augroup,
      pattern = "*.java",
      callback = function()
        -- Only format if JDTLS is attached
        local clients = vim.lsp.get_active_clients({ name = "jdtls" })
        if #clients > 0 then
          vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
        end
      end,
    })

    -- Set up Java-specific keymaps when JDTLS is ready
    vim.api.nvim_create_autocmd("LspAttach", {
      group = java_augroup,
      pattern = "*.java",
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "jdtls" then
          local opts = { buffer = args.buf }
          
          -- Additional Java-specific shortcuts
          vim.keymap.set("n", "<leader>ji", function()
            require("jdtls").organize_imports()
          end, { desc = "Organize Imports", buffer = args.buf })
          
          vim.keymap.set("n", "<leader>jc", function()
            require("jdtls").compile("incremental")
          end, { desc = "Compile Project", buffer = args.buf })
          
          vim.keymap.set("n", "<leader>jC", function()
            require("jdtls").compile("full")
          end, { desc = "Full Compile", buffer = args.buf })
          
          vim.keymap.set("n", "<leader>jr", function()
            require("jdtls").update_project_config()
          end, { desc = "Refresh Project", buffer = args.buf })
        end
      end,
    })

    -- Configure snippet support for Java
    vim.api.nvim_create_autocmd("FileType", {
      group = java_augroup,
      pattern = "java",
      callback = function()
        -- Enable additional snippet triggers
        local cmp = require("cmp")
        cmp.setup.buffer({
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer", keyword_length = 3 },
            { name = "path" },
          }),
        })
      end,
    })
  end,
}