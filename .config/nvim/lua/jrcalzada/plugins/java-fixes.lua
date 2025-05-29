-- lua/jrcalzada/plugins/java-fixes.lua
-- Fixes for common Java LSP issues

return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    -- Disable automatic linting on BufWritePost for Java files
    -- JDTLS provides much better diagnostics than external linters
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function(args)
        -- Clear any existing linting autocommands for this buffer
        vim.api.nvim_clear_autocmds({
          group = "lint",
          buffer = args.buf,
          event = "BufWritePost"
        })
      end,
    })

    -- Add command to manually trigger diagnostics refresh
    vim.api.nvim_create_user_command("JavaDiagnostics", function()
      vim.diagnostic.reset()
      vim.lsp.buf.format({ async = false })
      vim.defer_fn(function()
        local clients = vim.lsp.get_active_clients({ name = "jdtls" })
        for _, client in ipairs(clients) do
          vim.lsp.diagnostic.on_publish_diagnostics(
            nil,
            vim.lsp.util.make_text_document_params(),
            { client_id = client.id }
          )
        end
      end, 100)
    end, { desc = "Refresh Java diagnostics" })

    -- Better error handling for Java files
    vim.api.nvim_create_autocmd("LspAttach", {
      pattern = "*.java",
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "jdtls" then
          -- Configure diagnostics specifically for Java
          vim.diagnostic.config({
            virtual_text = {
              severity = { min = vim.diagnostic.severity.WARN },
              source = "always",
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
          }, args.buf)
          
          -- Force diagnostic refresh after LSP attach
          vim.defer_fn(function()
            vim.diagnostic.reset(args.buf)
            if client.server_capabilities.diagnosticProvider then
              vim.lsp.diagnostic.on_publish_diagnostics(
                nil,
                vim.lsp.util.make_text_document_params(args.buf),
                { client_id = client.id }
              )
            end
          end, 1000)
        end
      end,
    })
  end,
}