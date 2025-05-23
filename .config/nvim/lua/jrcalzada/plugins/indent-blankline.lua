-- lua/jrcalzada/plugins/indent-blankline.lua
return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
        require("ibl").setup()
    end,
}
