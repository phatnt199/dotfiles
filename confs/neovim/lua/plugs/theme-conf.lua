local mod = {
	"phatnt199/devglow",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd([[ colorscheme devglow ]])
	end,
}

return mod
