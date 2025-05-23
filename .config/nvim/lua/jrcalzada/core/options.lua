-- lua/jrcalzada/core/options.lua
local opt = vim.opt

-- opt.guicursor = ""

opt.nu = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- opt.hlsearch = false
-- opt.incsearch = true

opt.termguicolors = true

-- opt.scrolloff = 8
-- opt.signcolumn = "yes"
-- opt.isfname:append("@-@")

-- opt.updatetime = 50

-- opt.colorcolumn = "80"
opt.splitbelow = true
opt.splitright = true
-- opt.syntax = "enable"
--
--
--
local function isempty(s)
	return s == nil or s == ""
end
local function use_if_defined(val, fallback)
	return val ~= nil and val or fallback
end

local conda_prefix = os.getenv("CONDA_PREFIX")
if not isempty(conda_prefix) then
	vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, conda_prefix .. "/bin/python")
	vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, conda_prefix .. "/bin/python")
else
	vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, "python")
	vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, "python3")
end

-- ensure :E maps to :Explore
vim.api.nvim_create_user_command("E", "Explore", {})
