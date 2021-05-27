
--                          /// Utilities ///

-- Taken from https://oroques.dev/notes/neovim-init
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


--                          /// paqin Management ///

-- TODO make this install automatically if the file is not found.
-- git clone https://github.com/savq/paq-nvim.git \
--     "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
vim.cmd 'packadd paq-nvim'
local paq = require'paq-nvim'.paq
paq { 'savq/paq-nvim', opt=true }


--                          /// Navigation ///

-- Nicer up/down movement on long lines.
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- Smooth scrolling, space to go down, tab to go up.
paq 'yuttie/comfortable-motion.vim'
vim.g.comfortable_motion_no_default_key_mappings = true
map('n', '<space>', ':call comfortable_motion#flick(50)<CR>10j', { silent = true })
map('n', '<C-u>', '<tab>')
map('n', '<tab>', ':call comfortable_motion#flick(-50)<CR>10k', { silent = true })
map('v', '<space>', ':call comfortable_motion#flick(50)<CR>10j', { silent = true })
map('v', '<C-u>', '<tab>')
map('v', '<tab>', ':call comfortable_motion#flick(-50)<CR>10k', { silent = true })


--                          /// Editing and Formatting ///

-- Rename word and prime to replace other occurances
map('n', 'ct', '*Ncw<C-r>"')
map('n', 'cT', '*Ncw')

-- Rename word across file
map('n', 'cW', ':%s/\<<C-r><C-w>\>/')

-- Transform single line code blocks to multi-line ones and vice-versa.
paq 'AndrewRadev/splitjoin.vim'
vim.g.splitjoin_split_mapping = ''
vim.g.splitjoin_join_mapping = ''
map('n', 'SJ', ':SplitjoinJoin<cr>')
map('n', 'SS', ':SplitjoinSplit<cr>')

-- Automatically delete extra characters (like quotes) when joining lines.
paq 'flwyd/vim-conjoin'

-- Delete until the next 'closing' character (quote or brace)
map('n', "d'", 'd/[\\]\\}\\)\'"]<CR>:let @/ = ""<CR>')

-- Keep visual selection when indenting or dedenting.
-- https://superuser.com/questions/310417/how-to-keep-in-visual-mode-after-identing-by-shift-in-vim
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Wrap lines automatically at 79 characters.
vim.o.wrap = true
vim.o.linebreak = true
vim.o.textwidth = 79
vim.o.wrapmargin = 0
vim.o.formatoptions .. 'l'
vim.o.formatoptions .. 't'

-- Make new lines indent automatically.
vim.o.autoindent = true

-- Reformat paragraphs when typing anywhere in them (not just when adding to
-- their end).
vim.cmd("command AutoWrapToggle if &fo =~ 'a' | set fo-=a | else | set fo+=a | endif")
map('n', '<C-a>', ':AutoWrapToggle<CR>')
vim.cmd('filetype plugin indent on')

-- Make tabs create 2 spaces.
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Automatically set tabstop/shiftwidth based on current file or nearby files.
paq 'tpope/vim-sleuth'

-- Command to trim all trailing whitespace in the file.
vim.cmd(
[[
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction
command! TrimWhitespace call TrimWhitespace()
]]
)

-- Change cases using e.g. cru for upper case.
paq 'tpope/vim-abolish'



--                          /// Visuals ///

-- Show tabs as actual characters.
vim.o.list = true
vim.o.listchars = 'tab:>-'

-- Highlight current word with cursor on it across whole buffer.
paq 'RRethy/vim-illuminate'

-- My custom colorscheme defined in ~/.vim/colors.
vim.cmd('colorscheme terminal')
vim.o.background = 'dark'

-- Highlights the line the cursor is currently on.
set cursorline

-- Creates a line to show the max desired line length.
vim.o.colorcolumn = '+1'

-- Makes vim faster when making new lines after long lines by preventing syntax
-- highlighting after a certain width.
vim.o.synmaxcol = 2000

-- Show relative line numbers on left side of buffer.
vim.o.number = true
vim.o.relativenumber = true

-- Animates window resizing.
paq 'camspiers/animate.vim'

-- Adds indentation line hints.
paq 'Yggdroot/indentLine'
vim.g.indentLine_color_term = 17
vim.g.indentLine_char_list = ['|', '¦', '┆', '┊']
vim.g.indentLine_setConceal = false


--                          /// User Interface ///

-- Allow mouse usage in the terminal.
vim.o.mouse = 'a'

-- Set title of (e.g. X11) window vim is in.  See :h statusline for info about
-- how to customize this.
vim.o.title = true
vim.o.titlestring = "%t\ (%{expand('%:~:.:h')})\ -\ NVIM"

-- Add scrollbars.
paq { 'dstein64/nvim-scrollview', branch = 'main' }

-- Add bottom bar with various info.
paq 'vim-airline/vim-airline'
-- Uncomment to get top bar with all buffer names.
-- vim.g.airline#extensions#tabline#enabled = true
vim.g.airline#extensions#branch#enabled = true
vim.g.airline#extensions#branch#displayed_head_limit = 15
vim.g.airline#extensions#ale#enabled = true
-- Theme located in ~/.vim/autoload/airline/themes/terminal.vim.
vim.g.airline_theme = 'terminal'
-- Use :help statusline for customization options here.
vim.g.airline_section_c = '%f%m'
-- Determines the max width for different parts of the bottom bar. See
-- https://github.com/vim-airline/vim-airline/issues/694 for some explanation.
vim.g.airline#extensions#default#section_truncate_width = {
    'a': 40,
    'b': 40,
    'c': 50,
    'x': 110,
    'y': 110,
    'z': 110,
}
-- Remove the last bottom bar section.
vim.g.airline_section_z = ''

-- Use the system clipboard for everything by default. See
-- https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim.
vim.o.clipboard = 'unnamedplus'
-- Copy filename of current buffer to clipboard
map('n', 'cp', ':let @+ = expand("%:p")<CR>')



--                          /// Language - CSV ///

paq 'mechatroner/rainbow_csv'
vim.cmd('autocmd FileType csv autocmd BufWritePre <buffer> :RainbowAlign')


--                          /// Language - Markdown ///

paq 'masukomi/vim-markdown-folding'
vim.cmd('autocmd Filetype markdown setlocal spell spelllang=en_us')
vim.cmd('autocmd FileType markdown set foldmethod=expr')


--                          /// Language - LaTeX ///

vim.cmd('autocmd Filetype latex setlocal spell spelllang=en_us')
vim.cmd('au BufNewFile *.tex 0r ~/.vim/tex.skel')


--                          /// Language - English ///

paq 'ron89/thesaurus_query.vim'
-- To get offline thesaurus
-- curl http://www.gutenberg.org/files/3202/files/mthesaur.txt >
-- ~/.vim/thesaurus/mthesaur.txt
map('n', 'zt', ':ThesaurusQueryReplaceCurrentWord<CR>')


--                          /// Language - GLSL ///

paq 'tikhomirov/vim-glsl'


--                          /// Language - Dart ///

paq 'dart-lang/dart-vim-plugin'


--                          /// Language - YAML ///

vim.cmd('autocmd FileType yaml setlocal shiftwidth=2 tabstop=2')


--                          /// Language - Bazel ///

vim.cmd('autocmd FileType bzl setlocal shiftwidth=4 tabstop=4')




paq 'neovim/nvim-lspconfig'
paq 'nvim-lua/completion-nvim'
paq 'nvim-lua/lsp_extensions.nvim'
