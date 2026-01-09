return {
	{
		dir = vim.fn.stdpath('config') .. '/lua/custom/deployer.nvim',
		cmd = "Deploy",
		keys = {
			{
				"<leader>d",
				function()
					require("deployer").deploy()
				end,
				desc = "Deploy project with rsync",
			},
		}
	},
}
