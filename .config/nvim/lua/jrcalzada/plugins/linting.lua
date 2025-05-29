-- lua/jrcalzada/plugins/linting.lua
return {
  "mfussenegger/nvim-lint",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local lint = require("lint")

    -- Function to check if a linter is available
    local function linter_exists(name)
      return vim.fn.executable(name) == 1
    end

    -- Configure linters, but only if they're available
    local linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
    }

    -- Only add Java linting if checkstyle is available
    if linter_exists("checkstyle") then
      linters_by_ft.java = { "checkstyle" }
    else
      -- Use JDTLS built-in diagnostics instead
      vim.notify("checkstyle not found, using JDTLS diagnostics for Java", vim.log.levels.INFO)
    end

    lint.linters_by_ft = linters_by_ft

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Only run linting if the linter exists for this filetype
        local ft = vim.bo.filetype
        local linters = lint.linters_by_ft[ft] or {}
        
        for _, linter_name in ipairs(linters) do
          if not linter_exists(linter_name) then
            return -- Skip linting if linter is not available
          end
        end
        
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}