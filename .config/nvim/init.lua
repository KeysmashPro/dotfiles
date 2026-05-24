vim.cmd([[set mouse=a]])
vim.cmd([[set noswapfile]])

vim.opt.clipboard=unnamedplus
vim.opt.encoding=utf8

vim.opt.winborder = "rounded"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.pack.add({
  { src = "https://github.com/vague2k/vague.nvim" },
  { src = "https://github.com/rose-pine/neovim" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = "https://github.com/chentoast/marks.nvim" },
  { src = "https://github.com/danishprakash/fff.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-tree/nvim-tree.lua"},
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/mikavilpas/yazi.nvim" },
  { src = "https://github.com/aznhe21/actions-preview.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.8" },
  { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/LinArcX/telescope-env.nvim" },
  { src = "https://github.com/mfussenegger/nvim-jdtls" },
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })

vim.keymap.set('n', 'ff', function() require('fff').find_files() end, { desc = 'FFFind files' })
vim.keymap.set('n', 'fg', function() require('fff').live_grep() end, { desc = 'LiFFFe grep' })
vim.keymap.set('n', 'fz', function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end, { desc = 'Live fffuzy grep' })
vim.keymap.set('n', 'fc', function() require('fff').live_grep({ query = vim.fn.expand("<cword>") }) end, { desc = 'Search current word' })

require "marks".setup {
	builtin_marks = { "<", ">", "^" },
	refresh_interval = 250,
	sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	excluded_filetypes = {},
	excluded_buftypes = {},
	mappings = {}
}

local default_color = "vague"

require "mason".setup()

local telescope = require("telescope")
telescope.setup({
	defaults = {
		preview = { treesitter = false },
		color_devicons = true,
		sorting_strategy = "ascending",
		borderchars = {
			"─", -- top
			"│", -- right
			"─", -- bottom
			"│", -- left
			"┌", -- top-left
			"┐", -- top-right
			"┘", -- bottom-right
			"└", -- bottom-left
		},
		path_displays = { "smart" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		}
	}
})
telescope.load_extension("ui-select")

require("actions-preview").setup {
	backend = { "telescope" },
	extensions = { "env" },
	telescope = vim.tbl_extend(
		"force",
		require("telescope.themes").get_dropdown(), {}
	)
}



vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.cmd [[set completeopt+=menuone,noselect,popup]]

vim.lsp.enable({
	"lua_ls", "cssls", "svelte", "tinymist", "svelteserver",
	"rust_analyzer", "clangd", "ruff",
	"glsl_analyzer", "haskell-language-server", "hlint",
	"intelephense", "biome", "tailwindcss",
	"ts_ls", "emmet_language_server", "emmet_ls", "solargraph"
})

require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = {
		"permissions",
		"icon",
	},
	float = {
		max_width = 0.7,
		max_height = 0.6,
		border = "rounded",
	},
})

require "vague".setup({ transparent = true })
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

require('nvim-tree').setup({
  view = {
    side = "right",
    width = 30,
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
      file = false,
      folder = false,
      folder_arrow = true,
      git = false
    	}
    }
  },
  filters = {
    dotfiles = false,
  },
})


-- ~/.config/nvim/init.lua

local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end

vim.keymap.set("n", "<leader>pc", pack_clean)


local color_group = vim.api.nvim_create_augroup("colors", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = color_group,
	callback = function(args)
    --vim.cmd('highlight StatusLine guifg=#ffffff guibg=#5f87af gui=bold')
    --vim.cmd('highlight StatusLineNC guifg=#a0a0a0 guibg=#2c3e50')
    --vim.cmd('highlight WinSeparator guifg=#e06c75 guibg=NONE gui=bold')
    --vim.cmd('highlight TabLine guifg=#a0a0a0 guibg=#2c3e50')
    --vim.cmd('highlight TabLineSel guifg=#ffffff guibg=#5f87af gui=bold')
    --vim.cmd('highlight TabLineFill guifg=NONE guibg=#1e1e2e')
    --vim.cmd('highlight MsgArea guifg=#ffffff guibg=#3b4261')
		if vim.t.color then
			vim.cmd("colorscheme " .. vim.t.color)
		else
			vim.cmd("colorscheme " .. default_color)
		end
	end,
})

vim.api.nvim_create_autocmd("TabEnter", {
	group = color_group,
	callback = function(args)
		if vim.t.color then
			vim.cmd("colorscheme " .. vim.t.color)
		else
			vim.cmd("colorscheme " .. default_color)
		end
	end,
})

local colors = {}
vim.api.nvim_create_autocmd("ColorScheme", {
	group = color_group,
	callback = function(args)
		-- vim.cmd("hi statusline guibg=NONE")
		-- vim.cmd("hi TabLineFill guibg=NONE")
	end,
})

local ls = require("luasnip")
local builtin = require("telescope.builtin")
local map = vim.keymap.set
local current = 1

vim.g.mapleader = " "

map({ "n", "x" }, "<leader>y", '"+y')
map({ "n", "x" }, "<leader>d", '"+d')
map({ "i", "s" }, "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })
map({ "n", "t" }, "<Leader>t", "<Cmd>tabnew<CR>")
map({ "n", "t" }, "<Leader>x", "<Cmd>tabclose<CR>")

vim.cmd([[
	nnoremap <silent> <C-a> :lua require("nvim-tree.api").tree.toggle()<CR>
  inoremap <silent> <C-a> <Esc>:lua require("nvim-tree.api").tree.toggle()<CR>
	nnoremap g= g+| " g=g=g= is less awkward than g+g+g+
	nnoremap gK @='ddkPJ'<cr>| " join lines but reversed. `@=` so [count] works
	noremap gK <esc><cmd>keeppatterns '<,'>-global/$/normal! ddpkJ<cr>
	noremap! <c-r><c-d> <c-r>=strftime('%F')<cr>
	noremap! <c-r><c-t> <c-r>=strftime('%T')<cr>
	noremap! <c-r><c-f> <c-r>=expand('%:t')<cr>
	noremap! <c-r><c-p> <c-r>=expand('%:p')<cr>
	xnoremap <expr> . "<esc><cmd>'<,'>normal! ".v:count1.'.<cr>'
	"==========================================================================="


	nnoremap <C-h> <C-w><C-h>
	nnoremap <C-l> <C-w><C-l>
	nnoremap <C-j> <C-w><C-j>
	nnoremap <C-k> <C-w><C-k>

	nnoremap S :%s//g<Left><Left>
	nnoremap <Esc> :nohlsearch<CR>

	nnoremap <C-S-k> :w!<CR>:!make<CR>: ...Create window with binary output...
	nnoremap <C-S-x> :w!<CR>:call BuildAndRunCMake()<CR>
	nnoremap <C-S-/> :w!<CR>:!make<CR>:!st-info --probe<CR>:!st-flash --reset write *.bin 0x8000000<CR>

	function! BuildAndRunCMake()
    let l:file_dir = fnamemodify(expand('%:p'), ':h')
    let l:project_dir = fnamemodify(l:file_dir, ':h')
    " Delite previous executable
    silent! call system('rm -rf ' . shellescape(l:project_dir) . '/bin/*')
    " Build
    let l:build_cmd = 'cd ' . shellescape(l:project_dir) . 
                   \ ' && mkdir -p build && cd build && cmake .. && cmake --build .'
    echo "Building..."
    let l:build_output = system(l:build_cmd)
    " Quickfix
    call setqflist([], 'r', {'lines': split(l:build_output, "\n"), 'title': 'Build Output'})
    cclose
    let l:quickfix_height = 10
    execute 'belowright ' . l:quickfix_height . 'copen'
    wincmd p
    " Run executable
    let l:executable = glob(l:project_dir . '/bin/*')
    if !empty(l:executable)
        call jobstart(l:executable, {
            \ 'on_exit': function('s:JobHandler')
            \ })
        echo "Running: " . l:executable
    else
        echohl ErrorMsg
        echom "Error: No executable found"
        echohl None
    endif
endfunction

function! s:JobHandler(job_id, exit_code, event)
    cclose
    echom "Program finished"
endfunction
	"==========================================================================="
]])

for i = 1, 8 do
	map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end
map({ "n", "v", "x" }, ";", ":", { desc = "Self explanatory" })
map({ "n", "v", "x" }, ":", ";", { desc = "Self explanatory" })
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e ~/.config/zsh/.zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm ", { desc = "ENTER NORM COMMAND." })
map({ "n", "v", "x" }, "<leader>o", "<Cmd>source %<CR>", { desc = "Source " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>O", "<Cmd>restart<CR>", { desc = "Restart vim." })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map({ "n" }, "<leader>f", builtin.find_files, { desc = "Telescope live grep" })

function git_files() builtin.find_files({ no_ignore = true }) end

map({ "n" }, "<leader>g", builtin.live_grep)
map({ "n" }, "<leader>sg", git_files)
map({ "n" }, "<leader>sb", builtin.buffers)
map({ "n" }, "<leader>si", builtin.grep_string)
map({ "n" }, "<leader>so", builtin.oldfiles)
map({ "n" }, "<leader>sh", builtin.help_tags)
map({ "n" }, "<leader>sm", builtin.man_pages)
map({ "n" }, "<leader>sr", builtin.lsp_references)
map({ "n" }, "<leader>sd", builtin.diagnostics)
map({ "n" }, "<leader>si", builtin.lsp_implementations)
map({ "n" }, "<leader>sT", builtin.lsp_type_definitions)
map({ "n" }, "<leader>ss", builtin.current_buffer_fuzzy_find)
map({ "n" }, "<leader>st", builtin.builtin)
map({ "n" }, "<leader>sc", builtin.git_bcommits)
map({ "n" }, "<leader>sk", builtin.keymaps)
map({ "n" }, "<leader>se", "<cmd>Telescope env<cr>")
map({ "n" }, "<leader>sa", require("actions-preview").code_actions)
map({ "n" }, "<M-n>", "<cmd>resize +2<CR>")
map({ "n" }, "<M-e>", "<cmd>resize -2<CR>")
map({ "n" }, "<M-i>", "<cmd>vertical resize +5<CR>")
map({ "n" }, "<M-m>", "<cmd>vertical resize -5<CR>")
map({ "n" }, "<leader>e", "<cmd>Oil<CR>")
map({ "n" }, "<leader>c", "1z=")
map({ "n" }, "<C-q>", ":copen<CR>", { silent = true })
map({ "n" }, "<leader>w", "<Cmd>update<CR>", { desc = "Write the current buffer." })
map({ "n" }, "<leader>q", "<Cmd>:quit<CR>", { desc = "Quit the current buffer." })
map({ "n" }, "<leader>Q", "<Cmd>:wqa<CR>", { desc = "Quit all buffers and write." })
map({ "n" }, "<C-f>", "<Cmd>Open .<CR>", { desc = "Open current directory in Finder." })
map({ "n" }, "<leader>a", ":edit #<CR>", { desc = "Open current directory in Finder." })


vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.jsx,*.tsx",
	group = vim.api.nvim_create_augroup("TS", { clear = true }),
	callback = function()
		vim.cmd([[set filetype=typescriptreact]])
	end
})
vim.cmd('colorscheme ' .. default_color)

-- Run gg-repo-sync automatically after saving a PHP file
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.php",
	callback = function()
		vim.fn.jobstart("gg-repo-sync", {
			on_exit = function(_, exit_code, _)
				if exit_code == 0 then
					vim.notify("gg-repo-sync successful", vim.log.levels.INFO)
				else
					vim.notify("gg-repo-sync failed", vim.log.levels.ERROR)
				end
			end,
		})
	end,
})

vim.keymap.set('v', '<A-h>', '<Left>',  { noremap = true, silent = true })
vim.keymap.set('v', '<A-j>', '<Down>',  { noremap = true, silent = true })
vim.keymap.set('v', '<A-k>', '<Up>',    { noremap = true, silent = true })
vim.keymap.set('v', '<A-l>', '<Right>', { noremap = true, silent = true })


local function make_clean_run()
    vim.cmd('wa')
    local cmd = 'make clean && make run'
    vim.cmd('belowright new')
    vim.cmd('resize ' .. math.floor(vim.o.lines * 0.15))
    local job_id = vim.fn.termopen(cmd, {
        on_exit = function()
            vim.cmd('close!')
        end
    })
    vim.cmd('startinsert')
    vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', '<C-\\><C-n>:close!<CR>', { noremap = true, silent = true })
end

vim.api.nvim_create_user_command('MakeCleanRun', make_clean_run, {})
vim.keymap.set('n', '<leader><CR>', make_clean_run, { noremap = true, silent = true })

vim.opt.fillchars = {
    horiz = '─',
    horizup = '┬',
    horizdown = '┴',
    vert = '│',
    vertleft = '┤',
    vertright = '├',
    verthoriz = '┼'
}

vim.cmd('highlight WinSeparator ctermfg=9 ctermbg=none cterm=bold')

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show error under cursor' })

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Show references' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })

-- Auto fix
vim.keymap.set('n', '<leader>qf', function()
    vim.lsp.buf.code_action({ apply = true })
end, { desc = 'Apply first code action' })

