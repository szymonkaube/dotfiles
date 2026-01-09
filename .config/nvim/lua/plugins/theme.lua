return {
		{
			'vague2k/vague.nvim',
			config = function()
				require('vague').setup {
					transparent = true,
					style = {
						comments = 'none',
						strings = 'none',
						keyword_return = 'none',
					},
				}
				vim.cmd 'colorscheme vague'
				vim.cmd ':hi statusline guibg=NONE'
			end
	},
}
