-- lua/jrcalzada/plugins/gradle-support.lua
-- Enhanced Gradle support for your nvim-jdtls configuration

return {
  "mfussenegger/nvim-jdtls",
  ft = { "java", "gradle" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- Create Gradle-specific autocommands
    local gradle_augroup = vim.api.nvim_create_augroup("GradleSettings", { clear = true })
    
    -- Set Gradle file options
    vim.api.nvim_create_autocmd("FileType", {
      group = gradle_augroup,
      pattern = "gradle",
      callback = function()
        -- Set Gradle-specific indentation (2 spaces to match your config pattern)
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
        
        -- Enable syntax highlighting for Gradle files
        vim.opt_local.syntax = "groovy"
      end,
    })

    -- Gradle wrapper detection and commands
    local function find_gradle_wrapper()
      local root_dir = vim.fn.getcwd()
      local gradlew = root_dir .. "/gradlew"
      local gradlew_bat = root_dir .. "/gradlew.bat"
      
      if vim.fn.executable(gradlew) == 1 then
        return gradlew
      elseif vim.fn.executable(gradlew_bat) == 1 then
        return gradlew_bat
      else
        return "gradle" -- fallback to system gradle
      end
    end

    -- Create Gradle commands
    vim.api.nvim_create_user_command("GradleBuild", function()
      local gradle_cmd = find_gradle_wrapper()
      vim.cmd("!" .. gradle_cmd .. " build")
    end, { desc = "Run Gradle build" })

    vim.api.nvim_create_user_command("GradleClean", function()
      local gradle_cmd = find_gradle_wrapper()
      vim.cmd("!" .. gradle_cmd .. " clean")
    end, { desc = "Run Gradle clean" })

    vim.api.nvim_create_user_command("GradleTest", function()
      local gradle_cmd = find_gradle_wrapper()
      vim.cmd("!" .. gradle_cmd .. " test")
    end, { desc = "Run Gradle tests" })

    vim.api.nvim_create_user_command("GradleRun", function()
      local gradle_cmd = find_gradle_wrapper()
      vim.cmd("!" .. gradle_cmd .. " run")
    end, { desc = "Run Gradle application" })

    vim.api.nvim_create_user_command("GradleTasks", function()
      local gradle_cmd = find_gradle_wrapper()
      vim.cmd("!" .. gradle_cmd .. " tasks")
    end, { desc = "List Gradle tasks" })

    -- Enhanced Gradle project detection for JDTLS
    local function enhance_jdtls_root_detection()
      local original_find_root = require("jdtls.setup").find_root
      
      -- Override the find_root function to better handle Gradle projects
      require("jdtls.setup").find_root = function(markers)
        -- First try the original markers
        local root = original_find_root(markers)
        if root and root ~= "" then
          return root
        end
        
        -- If not found, specifically look for Gradle markers
        local gradle_markers = { 
          "build.gradle", 
          "build.gradle.kts", 
          "settings.gradle", 
          "settings.gradle.kts",
          "gradlew"
        }
        
        return vim.fs.dirname(vim.fs.find(gradle_markers, { upward = true })[1])
      end
    end

    -- Set up Gradle-specific keymaps for Java files in Gradle projects
    vim.api.nvim_create_autocmd("FileType", {
      group = gradle_augroup,
      pattern = "java",
      callback = function(event)
        -- Check if we're in a Gradle project
        local root_dir = require("jdtls.setup").find_root({".git", "mvnw", "gradlew", "pom.xml", "build.gradle"})
        local is_gradle_project = vim.fn.glob(root_dir .. "/build.gradle*") ~= "" or 
                                 vim.fn.glob(root_dir .. "/gradlew*") ~= ""
        
        if is_gradle_project then
          local opts = { buffer = event.buf }
          
          -- Gradle-specific keymaps
          vim.keymap.set("n", "<leader>gb", function()
            local gradle_cmd = find_gradle_wrapper()
            vim.cmd("!" .. gradle_cmd .. " build")
          end, { desc = "Gradle Build", buffer = event.buf })
          
          vim.keymap.set("n", "<leader>gt", function()
            local gradle_cmd = find_gradle_wrapper()
            vim.cmd("!" .. gradle_cmd .. " test")
          end, { desc = "Gradle Test", buffer = event.buf })
          
          vim.keymap.set("n", "<leader>gr", function()
            local gradle_cmd = find_gradle_wrapper()
            vim.cmd("!" .. gradle_cmd .. " run")
          end, { desc = "Gradle Run", buffer = event.buf })
          
          vim.keymap.set("n", "<leader>gc", function()
            local gradle_cmd = find_gradle_wrapper()
            vim.cmd("!" .. gradle_cmd .. " clean")
          end, { desc = "Gradle Clean", buffer = event.buf })
        end
      end,
    })

    -- Enhance which-key descriptions for Gradle
    vim.api.nvim_create_autocmd("LspAttach", {
      group = gradle_augroup,
      pattern = "*.java",
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "jdtls" then
          -- Check if we're in a Gradle project
          local root_dir = require("jdtls.setup").find_root({".git", "mvnw", "gradlew", "pom.xml", "build.gradle"})
          local is_gradle_project = vim.fn.glob(root_dir .. "/build.gradle*") ~= "" or 
                                   vim.fn.glob(root_dir .. "/gradlew*") ~= ""
          
          if is_gradle_project then
            local wk = require("which-key")
            wk.register({
              ["<leader>g"] = {
                name = "Gradle",
                b = "Build",
                t = "Test",
                r = "Run",
                c = "Clean",
              },
            }, { buffer = args.buf })
          end
        end
      end,
    })

    -- Apply the enhanced root detection
    enhance_jdtls_root_detection()
  end,
}