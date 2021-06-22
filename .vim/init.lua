
--                          /// Utilities ///

-- Taken from https://oroques.dev/notes/neovim-init
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


--                          /// Plugin Management ///

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

-- Smooth scrolling, ctrl-j to go down, ctrl-k to go up.
paq 'yuttie/comfortable-motion.vim'
vim.g.comfortable_motion_no_default_key_mappings = true
map('n', '<C-j>', ':call comfortable_motion#flick(50)<CR>10j', { silent = true })
map('n', '<C-u>', '<tab>')
map('n', '<C-k>', ':call comfortable_motion#flick(-50)<CR>10k', { silent = true })
map('v', '<C-j>', ':call comfortable_motion#flick(50)<CR>10j', { silent = true })
map('v', '<C-u>', '<tab>')
map('v', '<C-k>', ':call comfortable_motion#flick(-50)<CR>10k', { silent = true })

-- Space to search, to encourage more frequent use for navigation.
map('n', '<space>', '/')


--                          /// Editing and Formatting ///

-- Rename word and prime to replace other occurances
-- Can also search for something then use 'cgn' to "change next searched occurance".
map('v', '//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])
map('n', 'ct', '*Ncw<C-r>"')
map('n', 'cT', '*Ncw')

-- Rename word across file
map('n', 'cW', ':%s/\\<<C-r><C-w>\\>/')

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
vim.wo.wrap = true
vim.wo.linebreak = true
vim.bo.textwidth = 79
vim.bo.wrapmargin = 0
vim.bo.formatoptions = vim.o.formatoptions .. 'l'
vim.bo.formatoptions = vim.o.formatoptions .. 't'

-- Make new lines indent automatically.
vim.bo.autoindent = true

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

-- Repeatable hotkeys to surround text objects with quotes/parens/etc.
paq 'pope/vim-surround'
paq 'tpope/vim-repeat'

-- Automatically close parens.
paq 'windwp/nvim-autopairs'
local npairs = require('nvim-autopairs')
npairs.setup()

-- Automatically align code.
paq 'junegunn/vim-easy-align'


--                          /// Visuals ///

-- Show tabs as actual characters.
vim.wo.list = true
vim.wo.listchars = 'tab:>-'

-- Highlight current word with cursor on it across whole buffer.
paq 'RRethy/vim-illuminate'

-- My custom colorscheme defined in ~/.vim/colors.
vim.cmd('colorscheme terminal')
vim.o.background = 'dark'

-- Highlights the line the cursor is currently on.
vim.wo.cursorline = true

-- Creates a line to show the max desired line length.
vim.wo.colorcolumn = '+1'

-- Makes vim faster when making new lines after long lines by preventing syntax
-- highlighting after a certain width.
vim.o.synmaxcol = 2000

-- Show relative line numbers on left side of buffer.
vim.wo.number = true
vim.wo.relativenumber = true

-- Animates window resizing.
paq 'camspiers/animate.vim'

-- Adds indentation line hints.
paq 'Yggdroot/indentLine'
vim.g.indentLine_color_term = 17
vim.g.indentLine_char_list = {'|', '¦', '┆', '┊'}
vim.g.indentLine_setConceal = false


--                          /// User Interface ///

-- Allow mouse usage in the terminal.
vim.o.mouse = 'a'

-- Set title of (e.g. X11) window vim is in.  See :h statusline for info about
-- how to customize this.
vim.o.title = true
vim.o.titlestring = "%t (%{expand('%:~:.:h')}) - NVIM"

-- Add scrollbars.
paq { 'dstein64/nvim-scrollview', branch = 'main' }

-- Add bottom bar with various info.
paq 'vim-airline/vim-airline'
-- Uncomment to get top bar with all buffer names.
-- let g:airline#extensions#tabline#enabled = 1
-- Last section determines the max width for different parts of the bottom bar.
-- See https://github.com/vim-airline/vim-airline/issues/694 for some
-- explanation.
vim.cmd(
[[
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#displayed_head_limit = 15
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#default#section_truncate_width = { 'a': 40, 'b': 40, 'c': 50, 'x': 110, 'y': 110, 'z': 110, }
]]
)

-- Theme located in ~/.vim/autoload/airline/themes/terminal.vim.
vim.g.airline_theme = 'terminal'
-- Use :help statusline for customization options here.
vim.g.airline_section_c = '%f%m'
-- Remove the last bottom bar section.
vim.g.airline_section_z = ''

-- Use the system clipboard for everything by default. See
-- https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim.
vim.o.clipboard = 'unnamedplus'
-- Copy filename of current buffer to clipboard
map('n', 'cp', ':let @+ = expand("%:p")<CR>')

-- Persist settings between sessions
paq 'zhimsel/vim-stay'
-- stay/view will annoyingly remember to change working dirs when opening files
-- sometimes, this should prevent that
vim.o.autochdir = false

-- Better directory browsing.  Access the directory the current file is in with
-- the - key.
paq 'justinmk/vim-dirvish'
paq 'tpope/vim-eunuch'

-- Use alt-j/k to switch between split windows.
map('n', '<A-k>', '<C-w>W')
map('n', '<A-j>', '<C-w>w')

-- Make vertical split with alt-v, moving the next split.
map('n', '<A-v>', ':vsplit | wincmd w<CR>')

-- Close windows with alt-w.
map('n', '<A-w>', '<C-w>c')

-- Reset window sizings to be the same with alt-=.
map('n', '<A-=>', '<C-w>=')


--                          /// Buffers and Files ///

-- Make it so that when a buffer is deleted, the window stays.
paq 'qpkorr/vim-bufkill'

-- Switch between buffers without saving.
vim.o.hidden = true

-- Use alt-h/l to go between buffers, and ctrl-w to close buffers.
map('n', '<A-h>', ':bp<CR>')
map('n', '<A-l>', ':bn<CR>')
map('n', '<C-w>', 'BD:bn<CR>')

-- Do not automatically reload files if working on Google code, otherwise read
-- files automatically if they change.
if vim.fn.filereadable(vim.fn.expand('~/.vim/google.vim')) then
  vim.o.autoread = false
else 
  vim.o.autoread = true
  -- Trigger `autoread` when files changes on disk
  -- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
  -- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
  vim.cmd('autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if !bufexists("[Command Line]") | checktime | endif')
  -- Notification after file change
  -- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
  vim.cmd('autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')
end

-- Switch between h/cc files (and other related files) with alt-shift-h/l.
paq 'kana/vim-altr'
map('n', '<A-L>', '<Plug>(altr-forward)')
map('n', '<A-H>', '<Plug>(altr-back)')

-- Goes to current filename string in the current directory's BUILD file.
map('n', 'gb', ":execute 'e +/' . escape(escape(expand('%:t'), '.'), '.') . ' %:h/BUILD'<CR>")

-- Create directories on write if they don't already exist.
vim.cmd(
[[
function g:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call g:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
]]
)

-- Open files at specified lines using file:line syntax.
paq 'wsdjeg/vim-fetch'

-- Save all buffers with ctrl-s.
map('n', '<C-S>', ':wa<CR>')


--                          /// Searching ///

paq {'junegunn/fzf', run = vim.fn['fzf#install']}
paq { 'junegunn/fzf.vim' }
vim.g.fzf_history_dir = '~/.local/share/fzf-history'
vim.g.fzf_layout = {
    window = 'new | wincmd J | resize 1 | call animate#window_percent_height(0.5)'
}

-- Search in files starting from directory with current buffer and working way
-- up with a maximum of 100 files using the , key.
vim.cmd(
[[
let g:types = { 'dict': type({}), 'funcref': type(function('call')), 'string': type(''), 'list': type([]) }
function! g:Warn(message)
  echohl WarningMsg
  echom a:message
  echohl None
  return 0
endfunction
function! g:Myag(query, ...)
  if type(a:query) != g:types.string
    return g:Warn('Invalid query argument')
  endif
  let query = empty(a:query) ? '^(?=.)' : a:query
  let args = copy(a:000)
  let ag_opts = len(args) > 1 && type(args[0]) == g:types.string ? remove(args, 0) : ''
  let command = ag_opts . ' ' . fzf#shellescape(query) . ' ' .
        \ printf('$(find_up.bash %s -type f | head -n 100)',
        \        expand('%:h')) 
  return call('fzf#vim#ag_raw', insert(args, command, 0))
endfunction
command! -bang -nargs=* MyAg call g:Myag(<q-args>, <bang>0)
]]
)
map('n', ',', ':MyAg ')

-- Search through all files in the current buffer's directory with ; when in a
-- vim-dirvish directory buffer.
vim.cmd(
[[
function! g:Dirag(query, ...)
  if type(a:query) != g:types.string
    return g:Warn('Invalid query argument')
  endif
  let query = empty(a:query) ? '^(?=.)' : a:query
  let args = copy(a:000)
  echo args
  let ag_opts = len(args) > 1 && type(args[0]) == g:types.string ? remove(args, 0) : ''
  let command = ag_opts . ' ' . fzf#shellescape(query) . ' ' . expand('%:h')
  return call('fzf#vim#ag_raw', insert(args, command, 0))
endfunction
command! -bang -nargs=* DirAg call g:Dirag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
autocmd FileType dirvish nnoremap <buffer> ; :DirAg<CR>
]]
)

-- Search in all buffer lines with the ; key. 
map('n', ';', ':Lines<CR>')

-- Search through most recently used files with the ' key.
paq 'pbogut/fzf-mru.vim'
vim.g.fzf_mru_max = 100000
-- This is used instead of 'google3' because when fig uses vimdiff it puts the
-- vim instance at the root of the CitC client (the dir _containing_ google3).
vim.g.fzf_mru_store_relative_dirs = {'/google/src/cloud/'}
-- Exclude files with google3 in them - these will be opened only when things are
-- merged via vimdiff.
vim.g.fzf_mru_exclude = '/tmp/\\|google3'
map('n', "'", ":FZFMru -m -x --tiebreak=index --nth=-1,.. --delimiter=/ --preview 'bat --color=always --style=plain --theme=base16 {}'<CR>")
-- The '1000 part of this will make it so that 1000 oldfiles are remembered (the
-- last 1000 files will be available with the FZFMru command)
vim.o.shada = "!,'1000,<50,s10,h"


--                          /// Version Control ///

paq 'ludovicchabant/vim-lawrencium'
paq 'mhinz/vim-signify'
vim.g.signify_realtime = true
vim.g.signify_cursorhold_insert = false
vim.g.signify_cursorhold_normal = false
-- Go back and forth in history with ]r or [r.
-- taken from https://github.com/mhinz/vim-signify/issues/284
vim.g.target_commit = 0
vim.cmd(
[[
function ChangeTargetCommit(older_or_younger)
  if a:older_or_younger ==# 'older'
    let g:target_commit += 1
  elseif g:target_commit==#0
    echom 'No timetravel! Cannot diff against HEAD~-1'
    return
  else
    let g:target_commit -= 1
  endif
  let g:signify_vcs_cmds.git = printf('%s%d%s', 'git diff --no-color --no-ext-diff -U0 HEAD~', g:target_commit, ' -- %f')
  let g:signify_vcs_cmds.hg = printf('%s%d%s', 'hg diff --config extensions.color=! --config defaults.diff= --nodates -U0 --rev .~', g:target_commit, ' -- %f')
  let g:signify_vcs_cmds_diffmode.hg = printf('%s%d %s', 'hg cat --rev .~', g:target_commit, '%f')
  let l:cur_rev_cmd = printf('hg log --rev .~%d --template ''{node|short} {fill(desc, "50")|firstline}\n''', g:target_commit)
  let l:cur_rev = system(l:cur_rev_cmd)
  let l:output_msg = printf('%s%d %s', 'Now diffing against HEAD~', g:target_commit, l:cur_rev)
  echom l:output_msg
  :SignifyRefresh
endfunction
]]
)
vim.cmd("command! SignifyOlder call ChangeTargetCommit('older')")
vim.cmd("command! SignifyNewer call ChangeTargetCommit('younger')")
map('n', ']r', ':SignifyOlder<CR>')
map('n', '[r', ':SignifyNewer<CR>')

-- Toggle mercurial diff of current file with alt-d.
-- TODO Add this for git too.
vim.cmd(
[[
function HgDiffTarget()
  let l:cur_rev_cmd = printf('hg log --rev .~%d --template ''{node}''', g:target_commit)
  let l:cur_rev = system(l:cur_rev_cmd)
  execute 'Hgvdiff' l:cur_rev
endfunction
command! HgDiffTargetCmd call HgDiffTarget()
]]
)
map('n', '<A-d>', ':HgDiffTargetCmd<CR>')


--                          /// Diffing ///

-- Make obtain/put commands in diff mode auto jump to the next change.
map('n', 'do', 'do]c')
map('n', 'dp', 'dp]c')

-- Get diff between current buffer and what is saved to disk using the
-- DiffSaved command.
vim.cmd(
[[
function! g:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call g:DiffWithSaved()
]]
)


--                          /// Completion and Snippets ///

paq {'rafamadriz/friendly-snippets'}
paq {'hrsh7th/vim-vsnip'}
paq {'hrsh7th/vim-vsnip-integ'}

paq {'hrsh7th/nvim-compe'}
vim.o.completeopt = "menuone,noselect"
require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
    emoji = true,
    -- ultisnips = true,
    spell = true,
  },
}
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end
map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- Integration with nvim-autopairs.
_G.MUtils= {}  -- skip it, if you use another global object
vim.g.completion_confirm_key = ""
MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"](npairs.esc("<cr>"))
    else
      return npairs.esc("<cr>")
    end
  else
    return npairs.autopairs_cr()
  end
end
map('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true})


--                          /// Language - General ///

paq {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
paq 'nvim-treesitter/nvim-treesitter-textobjects'
-- Adds multicolored parenthesis to make it easier to see how they match up.
paq 'p00f/nvim-ts-rainbow'
require('nvim-treesitter.configs').setup {
  -- Install all maintained languages.
  ensure_installed = 'maintained',
  highlight = {enable = true},
  -- TODO Re-enable when this works better for python.
  -- indent = {enable = true},
  rainbow = {
    enable = true,
    extended_mode = true, -- Highlight also non-parentheses delimiters
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines
    termcolors = { '3', '4', '1', '3', '4', '1', '3', '4' }
  },
  textobjects = {
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["gi"] = "@function.outer",
        ["gI"] = "@class.outer",
      },
    },
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.cmd('set foldmethod=expr')
vim.cmd('set foldexpr=nvim_treesitter#foldexpr()')
vim.cmd('set foldlevelstart=99')

local function install_python_ls()
  vim.cmd('!pip install python-language-server[all] yapf')
end
paq { 'neovim/nvim-lspconfig', run=install_python_ls }
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- local opts = { noremap=true, silent=true }
  local opts = { noremap=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'ge', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'gW', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('v', 'gQ', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
end

-- Range formatting 
-- See https://github.com/neovim/neovim/issues/14680
function format_range_operator()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, '[')
    local finish = vim.api.nvim_buf_get_mark(0, ']')
    vim.lsp.buf.range_formatting({}, start, finish)
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = 'v:lua.op_func_formatting'
  vim.api.nvim_feedkeys('g@', 'n', false)
end
vim.api.nvim_set_keymap('n', 'gQ', '<cmd>lua format_range_operator()<CR>', {noremap = true})


--                          /// Language - Python ///
-- This requires: pip install 'python-language-server[all]'
-- See
-- https://github.com/neovim/nvim-lspconfig/commit/9100b3af6e310561167361536fd162bbe588049a
-- for config tips.
nvim_lsp.pyls.setup {
  on_attach = on_attach,
  settings = {
    pyls = {
      plugins = {
        -- This requires: pip install yapf
        yapf = { enabled = true },
        autopep8 = { enabled = false },
        pylint = { enabled = true },
        pycodestyle = { enabled = false },
      }
    }
  }
}
-- Auto add imports from file ~/.vim/python-imports.cfg
paq 'mgedmin/python-imports.vim'
map('n', 'gai', ':ImportName<CR>')

--                          /// Language - Clojure ///

paq 'eraserhd/parinfer-rust'


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


--                          /// Language - Terminal ///
-- Attmpts to make vim better when reading terminal data from kitty
-- TODO FIX
-- paq 'powerman/vim-plugin-AnsiEsc'
paq 'rkitover/vimpager'


--                          /// Language - GDScript ///
paq 'habamax/vim-godot'
nvim_lsp.gdscript.setup {
  on_attach = on_attach
}

--                          /// Machine Specific Config Files ///
if vim.fn.filereadable(vim.fn.expand('~/google_dotfiles/google.lua')) ~= 0 then
  require('google_dotfiles/google')
  nvim_lsp.ciderlsp.setup{on_attach = on_attach}
end
