local set = vim.o
set.number = true
set.relativenumber = true
set.encoding = "UTF-8"
set.clipboard = "unnamed"

-- 在copy后高亮
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({
			timeout = 500,
		})
	end,
})

-- keybindings
local opt = { noremap = true, silent = true }
vim.g.mapleader = " "
-- 插入模式下 -> 普通模式
vim.keymap.set("i", "jj", "<Esc>", opt)
-- 插入模式下 光标上下左右移动
vim.keymap.set("i", "<C-k>", "<up>", opt)
vim.keymap.set("i", "<C-j>", "<down>", opt)
vim.keymap.set("i", "<C-h>", "<left>", opt)
vim.keymap.set("i", "<C-l>", "<right>", opt)
-- 设置全局搜索当前单词
vim.api.nvim_set_keymap('n', '<leader>g',
	[[<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })<CR>]], opt)

vim.keymap.set("v", "<Tab>", ">", opt)
vim.keymap.set("n", "<Tab>", ">", opt)
vim.keymap.set("n", "<Leader>v", "<C-w>v", opt)
vim.keymap.set("n", "<Leader>s", "<C-w>s", opt)
vim.keymap.set("n", "<Leader>l", "<C-w>l", opt)
vim.keymap.set("n", "<Leader>h", "<C-w>h", opt)
vim.keymap.set("n", "<Leader>j", "<C-w>j", opt)
vim.keymap.set("n", "<Leader>k", "<C-w>k", opt)
vim.keymap.set("n", "<Leader>[", "<C-o>", opt)
vim.keymap.set("n", "<Leader>]", "<C-i>", opt)
-- https://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
vim.keymap.set("n", "j", [[v:count ? 'j' : 'gj']], { noremap = true, expr = true })
vim.keymap.set("n", "k", [[v:count ? 'k' : 'gk']], { noremap = true, expr = true })
-- lazy.nvim 安装：
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- base16
	{
		"RRethy/nvim-base16",
		lazy = true,
	},
	-- which-key
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},
	-- telescope
	--	{
	--		cmd = "Telescope",
	--		keys = {
	--			{ "<leader>p",  ":Telescope find_files<CR>", desc = "find files" },
	--			{ "<leader>P",  ":Telescope live_grep<CR>",  desc = "grep file" },
	--			{ "<leader>rs", ":Telescope resume<CR>",     desc = "resume" },
	--			{ "<leader>q",  ":Telescope oldfiles<CR>",   desc = "oldfiles" },
	--		},
	--		'nvim-telescope/telescope.nvim',
	--		tag = '0.1.1',
	--		-- or                              , branch = '0.1.1',
	--		dependencies = { 'nvim-lua/plenary.nvim' }
	--	},
	{
		'nvim-telescope/telescope.nvim',
		requires = { { 'nvim-lua/plenary.nvim' } },
		tag = '0.1.8',
		keys = {
			{ "<leader>p",  ":Telescope find_files<CR>", desc = "find files" },
			{ "<leader>P",  ":Telescope live_grep<CR>",  desc = "grep file" },
			{ "<leader>rs", ":Telescope resume<CR>",     desc = "resume" },
			{ "<leader>q",  ":Telescope oldfiles<CR>",   desc = "oldfiles" },
		},
	},
	{
		event = "VeryLazy",
		"tpope/vim-fugitive",
		cmd = "Git",
		config = function()
			vim.cmd.cnoreabbrev([[git Git]])
			vim.cmd.abbreviate("ture", "true")
			vim.cmd.cnoreabbrev([[gp Git push]])
			vim.cmd.cnoreabbrev([[Gbrowse GBrowse]])
		end
	},
	{
		"folke/neodev.nvim",
	},
	-- persistence
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		config = function()
			require("persistence").setup()
		end,
		lazy = false,
	},
	{
		"tpope/vim-rhubarb",
		event = "VeryLazy"
	},
	{
		'rhysd/conflict-marker.vim',
		event = 'VeryLazy',
		config = function()
		end
	},
	{
		"preservim/nerdtree",
		cmd = {
			"NERDTreeToggle", "NERDTree", "NERDTreeFind"
		},
		keys = {
			{ "<leader>t", ":NERDTreeToggle<CR>", desc = "toggle nerdtree" },
			{ "<leader>n", ":NERDTreeFind<CR>",   desc = "nerdtree find" },
		},
		config = function()
			-- nerdtree不显示pyc文件
			vim.g.NERDTreeIgnore = { ".pyc$" }
			vim.cmd([[
			let NERDTreeShowLineNumbers=1
			autocmd FileType nerdtree setlocal relativenumber
			]])
		end,
		dependencies = {
			"Xuyuanp/nerdtree-git-plugin",
			"ryanoasis/vim-devicons"
		}
	},
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		dependencies = {
			'neovim/nvim-lspconfig',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/nvim-cmp',
			'L3MON4D3/LuaSnip',
		}
	},
	{
		"ggandor/leap.nvim",
		event = "VeryLazy",
		config = function()
			require('leap').add_default_mappings()
		end,
	},
	{
		event = "VeryLazy",
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		config = function()
			require("mason").setup()
		end
	},
	{
		event = "VeryLazy",
		"neovim/nvim-lspconfig",
		dependencies = { 'williamboman/mason-lspconfig.nvim' }
	},
	{
		event = "VeryLazy",
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		event = "VeryLazy",
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { 'plenary.nvim' },
		config = function()
			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.black,
				},
				-- you can reuse a shared lspconfig on_attach callback here
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "python", "vim", 'go', "json", "html" },
				sync_install = false,
				auto_install = true,
				ignore_install = { "javascript" },
				modules = {},
				indent = { enable = true, disable = { 'python' } },
				incremental_selection = {
					enable = true,
					keymaps = {
						node_incremental = "v",
						node_decremental = "<BS>",
					},
				},
				highlight = {
					enable = true,
				},
				-- folding = {
				-- 	enable = true,
				-- 	-- 设置可折叠的代码元素
				-- 	foldmethod = 'expr',
				-- 	foldexpr = 'nvim_treesitter#foldexpr()'
				-- }
			})
		end
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",
		config = function()
			require 'nvim-treesitter.configs'.setup {
				modules = {},
				sync_install = false,
				auto_install = true,
				ensure_installed = { "lua", "python", "vim", 'go', "json", "html" },
				ignore_install = { "javascript" },
				textobjects = {
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["ac"] = "@class.outer",
							-- You can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							["ic"] = { query = "@class.inner", desc =
							"Select inner part of a class region" },
							-- You can also use captures from other query groups like `locals.scm`
							["as"] = { query = "@scope", query_group = "locals", desc =
							"Select language scope" },
						},
						-- You can choose the select mode (default is charwise 'v')
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * method: eg 'v' or 'o'
						-- and should return the mode ('v', 'V', or '<c-v>') or a table
						-- mapping query_strings to modes.
						selection_modes = {
							['@parameter.outer'] = 'v', -- charwise
							['@function.outer'] = 'V', -- linewise
							['@class.outer'] = '<c-v>', -- blockwise
						},
						-- If you set this to `true` (default is `false`) then any textobject is
						-- extended to include preceding or succeeding whitespace. Succeeding
						-- whitespace has priority in order to act similarly to eg the built-in
						-- `ap`.
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * selection_mode: eg 'v'
						-- and should return true of false
						include_surrounding_whitespace = true,
					},
				},
			}
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter"
		}
	},
	{
		event = "VeryLazy",
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup()
		end
	},
	{
		'kyazdani42/nvim-tree.lua',
	},
	{
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		'nvim-lualine/lualine.nvim',
		event = "VeryLazy",
		config = function()
			require('lualine').setup {
				--options = { theme = require 'lualine.themes.gruvbox' },
			}
		end
	},
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons'
	},
	{
		'RRethy/vim-illuminate',
		event = "BufReadPost",
		config = function()
			require("illuminate").configure({
				delay = 100,
				filetypes_denylist = {
					"NvimTree",
					"toggleterm",
					"TelescopePrompt",
				},
			})
		end,
		keys = {
			{
				"]r",
				function()
					require("illuminate").goto_next_reference(false)
				end,
				desc = "illuminate Next Reference",
			},
			{
				"[r",
				function()
					require("illuminate").goto_prev_reference(false)
				end,
				desc = "illuminate Prev Reference",
			},
		},
	},
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		cmd = { 'ToggleTerm' },
		config = function()
			require('toggleterm').setup({
				size = function(term)
					if term.direction == 'horizontal' then
						return 15
					elseif term.direction == 'vertical' then
						return vim.o.columns * 0.4
					end
				end
			})
			-- set keymaps to easily move between buffers and terminal
			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
				vim.keymap.set('t', 'jk', [[<C-\><C-n><Cmd>ToggleTerm<CR>]], opts)
			end

			vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
		end
	},
	-- 竖列线
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {}
	},
	-- 柔和滑动
	{
		"karb94/neoscroll.nvim",
		config = function()
			require('neoscroll').setup({
				{
					mappings = { -- Keys to be mapped to their corresponding default scrolling animation
						'<C-u>', '<C-d>',
						'<C-b>', '<C-f>',
						'<C-y>', '<C-e>',
						'zt', 'zz', 'zb',
					},
					hide_cursor = true, -- Hide cursor while scrolling
					stop_eof = true, -- Stop at <EOF> when scrolling downwards
					respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
					cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
					easing = 'linear', -- Default easing function
					pre_hook = nil, -- Function to run before the scrolling animation starts
					post_hook = nil, -- Function to run after the scrolling animation ends
					performance_mode = false, -- Disable "Performance Mode" on all buffers.
				}
			})
		end
	}
})


-- 滑动
local neoscroll = require('neoscroll')
local keymap = {
	["<leader>u"] = function() neoscroll.ctrl_u({ duration = 250 }) end,
	["<leader>d"] = function() neoscroll.ctrl_d({ duration = 250 }) end,
	["<leader>b"] = function() neoscroll.ctrl_b({ duration = 450 }) end,
	["<leader>f"] = function() neoscroll.ctrl_f({ duration = 450 }) end,
	["<leader>y"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 }) end,
	["<leader>e"] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 100 }) end,
	["zt"]        = function() neoscroll.zt({ half_win_duration = 250 }) end,
	["zz"]        = function() neoscroll.zz({ half_win_duration = 250 }) end,
	["zb"]        = function() neoscroll.zb({ half_win_duration = 250 }) end,
}
local modes = { 'n', 'v', 'x' }
for key, func in pairs(keymap) do
	vim.keymap.set(modes, key, func)
end
-- 加载base16-tender
vim.cmd.colorscheme("base16-tender")

-- lsp
local lspconfig = require('lspconfig')
require("mason").setup()
require("mason-lspconfig").setup()
require('nvim-tree').setup {}
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<leader>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<leader>F', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})
-- Set up nvim-cmp.
local cmp = require('cmp')
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
local luasnip = require("luasnip")
local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
				-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
				-- they way you will only jump inside the snippet region
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = 'buffer' },
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- python  pyright
lspconfig.pyright.setup {
	capabilities = capabilities
}


require("neodev").setup({})
-- lua
require("lspconfig").lua_ls.setup {}
require("lspconfig").rust_analyzer.setup {}
require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "hs" },
			},
			workspace = {
				checkThirdParty = false,
				-- Make the server aware of Neovim runtime files
				library = {
					vim.api.nvim_get_runtime_file("", true),
					"/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
					vim.fn.expand("~/lualib/share/lua/5.4"),
					vim.fn.expand("~/lualib/lib/luarocks/rocks-5.4"),
					"/opt/homebrew/opt/openresty/lualib",
				},
			},
			completion = {
				callSnippet = "Replace",
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

-- convert
vim.cmd.cnoreabbrev([[git Git]])
vim.cmd.abbreviate("ture", "true")
vim.cmd.cnoreabbrev([[gp Git push]])
vim.cmd.cnoreabbrev([[gco Git checkout]])
vim.cmd.cnoreabbrev([[Gbrowse GBrowse]])

vim.cmd([[
	let g:conflict_marker_highlight_group = ''
	" Include text after begin and end markers
	let g:conflict_marker_begin = '^<<<<<<< .*$'
	let g:conflict_marker_end   = '^>>>>>>> .*$'

	highlight ConflictMarkerBegin guibg=#2f7366
	highlight ConflictMarkerOurs guibg=#2e5049
	highlight ConflictMarkerTheirs guibg=#344f69
	highlight ConflictMarkerEnd guibg=#2f628e
	highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
]])


-- 启动nvim配置
local args = vim.api.nvim_get_vvar("argv")
-- embed
if #args > 2 then
else
	require("persistence").load({ last = true })
end

vim.api.nvim_set_hl(0, "@lsp.type.variable.lua", { link = "Normal" })
vim.api.nvim_set_hl(0, "Identifier", { link = "Normal" })
vim.api.nvim_set_hl(0, "TSVariable", { link = "Normal" })

-- neovide
vim.g.neovide_scale_factor = 0.8
vim.opt.linespace = 0
vim.o.mouse = ""
vim.g.neovide_underline_automatic_scaling = true
vim.g.neovide_fullscreen = true
vim.g.neovide_remember_window_size = true

-- vim.o.guifont = "Source Code Pro:h14"

-- 当前行高亮
vim.o.cursorline = true
-- tab 4个空格
vim.o.tabstop = 4
-- 换行自动缩进4个空格
vim.o.shiftwidth = 4

-- 代码折叠
vim.o.foldenable = true
vim.o.foldmethod = 'indent'
vim.o.foldlevel = 99


vim.cmd [[colorscheme tokyonight]]

-- bufferline 安装
vim.opt.termguicolors = true
require("bufferline").setup {}

for i = 1, 9 do
	vim.keymap.set('n', '<leader>' .. i, function() require("bufferline").go_to(i, true) end)
end

vim.keymap.set('n', '<leader>H', '<Cmd>BufferLineCyclePrev<CR>')
vim.keymap.set('n', '<leader>L', '<Cmd>BufferLineCycleNext<CR>')
vim.keymap.set('n', 'gT', '<Cmd>BufferLineCyclePrev<CR>')
vim.keymap.set('n', 'gt', '<Cmd>BufferLineCycleNext<CR>')
vim.keymap.set('n', '<C-j>', '<Cmd>BufferLineMovePrev<CR>')
vim.keymap.set('n', '<C-k>', '<Cmd>BufferLineMoveNext<CR>')
vim.keymap.set('n', 'ZZ', function()
	if vim.bo.modified then
		vim.cmd.write()
	end
	local buf = vim.fn.bufnr()
	require("bufferline").cycle(-1)
	vim.cmd.bdelete(buf)
end)

vim.g.python_host_prog = '/Users/fox_three/miniconda3/envs/blended_learning/bin/python'
vim.g.python3_host_prog = '/Users/fox_three/miniconda3/envs/doc_processor/bin/python'

-- 使用 neovim-remote 调用 Python 2 插件
vim.cmd [[
  function! RunPython2Plugin(...)
    call system('~/path/to/python2_plugin.sh ' . join(a:000, ' '))
  endfunction
]]

-- 绑定一个命令或快捷键来调用这个函数
vim.api.nvim_set_keymap('n', '<leader>r', ':call RunPython2Plugin("your_python2_plugin.py")<CR>',
	{ noremap = true, silent = true })
