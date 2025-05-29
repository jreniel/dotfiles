-- lua/jrcalzada/plugins/nvim-treesitter.lua
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { 
					"c", 
					"lua", 
					"vim", 
					"vimdoc", 
					"query", 
					"javascript", 
					"html", 
					"python",
					"java",        -- Java support
					"groovy",      -- Gradle build scripts (build.gradle)
					"kotlin",      -- Gradle Kotlin DSL (build.gradle.kts)
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}