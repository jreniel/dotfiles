-- lua/jrcalzada/plugins/vim-monokai-tasty.lua
return {
	"patstockwell/vim-monokai-tasty",
	priority = 1000,
	config = function ()
		vim.cmd([[colorscheme vim-monokai-tasty]])
	end,
}
