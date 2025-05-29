-- lua/jrcalzada/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local conform = require("conform")

    -- Create a flag for tracking if we're in an undo operation
    local in_undo_operation = false
    
    -- Create a command observer to detect undo operations
    vim.api.nvim_create_autocmd("CmdlineLeave", {
      pattern = "*",
      callback = function()
        local cmd = vim.fn.getcmdline()
        if cmd == "u" or cmd == "undo" then
          in_undo_operation = true
          -- Schedule the reset of the flag to ensure it happens after undo is processed
          vim.defer_fn(function()
            in_undo_operation = false
          end, 100) -- Short delay to ensure it happens after undo completes
        end
      end,
    })
    
    -- Create a BufWritePre hook to prevent on-save formatting during undo
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = {"*.rs", "*.java"},
      callback = function(args)
        -- If we're in an undo operation, temporarily disable format on save
        if in_undo_operation then
          -- Store the current formatexpr setting
          vim.b.orig_formatexpr = vim.bo.formatexpr
          -- Temporarily disable formatting
          vim.bo.formatexpr = ""
          
          -- Reset after the write completes
          vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = args.buf,
            once = true,
            callback = function()
              -- Restore original formatexpr if it existed
              if vim.b.orig_formatexpr then
                vim.bo.formatexpr = vim.b.orig_formatexpr
                vim.b.orig_formatexpr = nil
              end
            end,
          })
        end
      end
    })

    conform.setup({
      formatters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt" },
        java = { "google-java-format" }, -- Java formatting
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set("n", "<leader>f", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file" })
  end,
}