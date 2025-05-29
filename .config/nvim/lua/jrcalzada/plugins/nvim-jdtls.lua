-- lua/jrcalzada/plugins/nvim-jdtls.lua
-- Updated with enhanced Gradle support

return {
  "mfussenegger/nvim-jdtls",
  dependencies = {
    "folke/which-key.nvim",
  },
  ft = { "java" },
  config = function()
    local jdtls = require("jdtls")
    local mason_registry = require("mason-registry")

    -- Determine OS to pick correct config directory
    local config = "config_win"
    if vim.fn.has("macunix") == 1 then
      config = "config_mac"
    elseif vim.fn.has("unix") == 1 then
      config = "config_linux"
    end

    -- Enhanced root markers for better Gradle support
    local root_markers = { 
      ".git", 
      "mvnw", 
      "gradlew", 
      "pom.xml", 
      "build.gradle", 
      "build.gradle.kts",
      "settings.gradle",
      "settings.gradle.kts"
    }
    local root_dir = require("jdtls.setup").find_root(root_markers)
    if root_dir == "" then
      return
    end

    -- Detect project type (Maven vs Gradle)
    local is_gradle_project = vim.fn.glob(root_dir .. "/build.gradle*") ~= "" or 
                             vim.fn.glob(root_dir .. "/gradlew*") ~= "" or
                             vim.fn.glob(root_dir .. "/settings.gradle*") ~= ""

    -- Eclipse JDTLS paths (installed via Mason)
    local jdtls_pkg = mason_registry.get_package("jdtls")
    local jdtls_path = jdtls_pkg:get_install_path()
    local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    local JDTLS_LOCATION = jdtls_path .. "/" .. config

    -- Workspace path
    local workspace_folder = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. workspace_folder

    -- Get the current project name for better workspace organization
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

    -- Capabilities for autocompletion
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Extended capabilities for Java
    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    -- Key mappings
    local function lsp_keymaps(bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      local keymap = vim.keymap

      -- Standard LSP mappings (consistent with your lspconfig.lua)
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

      -- Java-specific mappings
      keymap.set("n", "<leader>jo", jdtls.organize_imports, { desc = "Organize Imports", buffer = bufnr })
      keymap.set("n", "<leader>jv", jdtls.extract_variable, { desc = "Extract Variable", buffer = bufnr })
      keymap.set("n", "<leader>jc", jdtls.extract_constant, { desc = "Extract Constant", buffer = bufnr })
      keymap.set("v", "<leader>jm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], { desc = "Extract Method", buffer = bufnr })
      keymap.set("n", "<leader>jt", jdtls.test_class, { desc = "Test Class", buffer = bufnr })
      keymap.set("n", "<leader>jn", jdtls.test_nearest_method, { desc = "Test Nearest Method", buffer = bufnr })
    end

    -- on_attach function
    local function on_attach(client, bufnr)
      lsp_keymaps(bufnr)
      
      -- Enable which-key descriptions for Java-specific mappings
      local wk = require("which-key")
      wk.register({
        ["<leader>j"] = {
          name = "Java",
          o = "Organize Imports",
          v = "Extract Variable",
          c = "Extract Constant",
          m = "Extract Method",
          t = "Test Class",
          n = "Test Nearest Method",
        },
      }, { buffer = bufnr })

      -- Auto-organize imports on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { "source.organizeImports" } }
          local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
        end,
      })
    end

    local config = {
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", launcher,
        "-configuration", JDTLS_LOCATION,
        "-data", workspace_dir,
      },

      -- The root directory of your Java project
      root_dir = root_dir,

      -- Language server `initializationOptions`
      settings = {
        java = {
          eclipse = {
            downloadSources = true,
          },
          configuration = {
            updateBuildConfiguration = "interactive",
            runtimes = {
              -- Add your Java runtimes here if you have multiple versions
              -- {
              --   name = "JavaSE-11",
              --   path = "/usr/lib/jvm/java-11-openjdk/",
              -- },
              -- {
              --   name = "JavaSE-17",
              --   path = "/usr/lib/jvm/java-17-openjdk/",
              -- },
            },
          },
          -- Enhanced Gradle support
          gradle = {
            enabled = is_gradle_project,
            wrapper = {
              enabled = true,
            },
            version = nil, -- Let JDTLS auto-detect
            home = nil,   -- Let JDTLS auto-detect
            java = {
              home = nil, -- Use default Java
            },
            offline = false,
            arguments = "", -- Additional Gradle arguments
            jvmArguments = "", -- JVM arguments for Gradle
            user = {
              home = nil, -- Use default Gradle user home
            },
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          format = {
            enabled = true,
            settings = {
              url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
              profile = "GoogleStyle",
            },
          },
        },
        signatureHelp = { enabled = true },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*",
          },
          importOrder = {
            "java",
            "javax",
            "com",
            "org"
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          useBlocks = true,
        },
      },

      flags = {
        allow_incremental_sync = true,
      },

      capabilities = capabilities,
      on_attach = on_attach,
      
      -- Language server `initializationOptions`
      init_options = {
        bundles = {},
        extendedClientCapabilities = extendedClientCapabilities,
      },
    }

    -- Start JDTLS
    jdtls.start_or_attach(config)
  end,
}