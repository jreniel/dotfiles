-- lua/jrcalzada/plugins/nvim-dap.lua
return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		-- 		{
		-- 			"jbyuki/one-small-step-for-vimkind",
		--       -- stylua: ignore
		-- 		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup()
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		dap.adapters.lldb = {
			type = "executable",
			command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
			name = "lldb",
		}

		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<Leader>dc", dap.continue, {})
		dap.configurations.rust = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
				initCommands = function()
					local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

					local script_import = 'command script import "'
						.. rustc_sysroot
						.. '/lib/rustlib/etc/lldb_lookup.py"'
					local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

					local commands = {}
					local file = io.open(commands_file, "r")
					if file then
						for line in file:lines() do
							table.insert(commands, line)
						end
						file:close()
					end
					table.insert(commands, 1, script_import)

					return commands
				end,
				-- ...,
			},
		}
		-- dap.adapters.nlua = function(callback, conf)
		-- 	local adapter = {
		-- 		type = "server",
		-- 		host = conf.host or "127.0.0.1",
		-- 		port = conf.port or 8086,
		-- 	}
		-- 	if conf.start_neovim then
		-- 		local dap_run = dap.run
		-- 		dap.run = function(c)
		-- 			adapter.port = c.port
		-- 			adapter.host = c.host
		-- 		end
		-- 		require("osv").run_this()
		-- 		dap.run = dap_run
		-- 	end
		-- 	callback(adapter)
		-- end
		-- dap.configurations.lua = {
		-- 	{
		-- 		type = "nlua",
		-- 		request = "attach",
		-- 		name = "Run this file",
		-- 		start_neovim = {},
		-- 	},
		-- 	{
		-- 		type = "nlua",
		-- 		request = "attach",
		-- 		name = "Attach to running Neovim instance (port = 8086)",
		-- 		port = 8086,
		-- 	},
		-- }
	end,
}
