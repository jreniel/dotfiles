-- lua/jrcalzada/plugins/nvim-dap-java.lua
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
  },
  ft = "java",
  config = function()
    local dap = require("dap")
    
    -- Java debug adapter configuration
    dap.configurations.java = {
      {
        type = 'java',
        request = 'attach',
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 5005,
      },
      {
        type = 'java',
        request = 'launch',
        name = "Debug (Launch) - Current File",
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        mainClass = function()
          -- Try to find the main class
          local root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'})
          local fname = vim.fn.expand('%:p')
          -- Remove the root directory and .java extension, then replace / with .
          local main_class = fname:gsub(root_dir .. '/', ''):gsub('src/main/java/', ''):gsub('/', '.'):gsub('%.java$', '')
          return main_class
        end,
        projectName = function()
          return vim.fn.fnamemodify(require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}), ':t')
        end,
        args = '',
        vmArgs = '',
        console = 'integratedTerminal',
      },
    }
    
    -- Setup virtual text for debugging
    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      filter_references_pattern = '<module',
      virt_text_pos = 'eol',
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil
    })

    -- Additional keymaps for Java debugging
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set("n", "<leader>dc", function()
          require("jdtls").test_class()
        end, { desc = "Debug Test Class", buffer = event.buf })
        
        vim.keymap.set("n", "<leader>dm", function()
          require("jdtls").test_nearest_method()
        end, { desc = "Debug Test Method", buffer = event.buf })
      end,
    })
  end,
}