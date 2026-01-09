require('lazy').setup {
	require 'plugins/theme',
	require 'plugins/lsp',
	require 'plugins/treesitter',
  require 'plugins/treesitter-context',
	require 'plugins/completion',
	require 'plugins/telescope',
	require 'plugins/git-signs',
	require 'plugins/which-key',
	require 'plugins/obsidian',
	require 'plugins/render-markdown',
	require 'plugins/zen-mode',
  -- require 'plugins/lualine',

	require 'plugins/custom',
}
