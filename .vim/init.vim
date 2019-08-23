" TO USE NEOVIM run these commands
" mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
" ln -s ~/.vim $XDG_CONFIG_HOME/nvim
" ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim

" TO DEBUG SLOW PLUGINS
" :profile start profile.log
" :profile func *
" :profile file *
" " At this point do slow actions
" :profile pause
" :noautocmd qall!

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" TODO check this out  https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db


" autocomplete
" install: https://github.com/Valloric/YouCompleteMe/blob/master/README.md#full-installation-guide
" NOTE DO NOT INSTALL USING AN ANACONDA PYTHON!!
if isdirectory("/google")
  Plugin 'prabirshrestha/async.vim'
  Plugin 'prabirshrestha/vim-lsp'
  " gotten by doing git clone sso://user/mcdermottm/vim-csearch
  Plugin 'file:///usr/local/google/home/kovas/vim-csearch'
else
  Plugin 'Valloric/YouCompleteMe'
  " vim autocomplete and RENAMING!
  Plugin 'davidhalter/jedi-vim'
  " Plugin 'autozimu/LanguageClient-neovim'
  " Plugin 'Shougo/deoplete.nvim'
endif
" go to definition tags
" Plugin 'ludovicchabant/vim-gutentags'
" directory tree
" Plugin 'scrooloose/nerdtree'
" Plugin 'PhilRunninger/nerdtree-buffer-ops'
" " mercurial integration with nerdtree
" Plugin 'f4t-t0ny/nerdtree-hg-plugin'
" netrw enhancement - TODO decide between nerdtree and this
" Plugin 'tpope/vim-vinegar'
Plugin 'justinmk/vim-dirvish'
" syntax check 
Plugin 'w0rp/ale'
" useful to go between errors - may not be necessary any more with ale!
" Plugin 'tpope/vim-unimpaired'
" python indentation
Plugin 'Vimjas/vim-python-pep8-indent'
" status bar
Plugin 'vim-airline/vim-airline'
" Plugin 'bling/vim-bufferline'
" make it so that when a buffer is deleted, the window stays
Plugin 'qpkorr/vim-bufkill'
" easier buffer management
" Plugin 'jlanzarotta/bufexplorer'
Plugin 'xolox/vim-misc'
" mercurial integration
Plugin 'ludovicchabant/vim-lawrencium'
" show changed lines
Plugin 'mhinz/vim-signify'
" python highlighing
Plugin 'vim-python/python-syntax'
" startup screen
" Plugin 'mhinz/vim-startify'
" indent detection
Plugin 'tpope/vim-sleuth'
" sorting shortcuts
Plugin 'christoomey/vim-sort-motion'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

" hex color highlighting - this is currently slow
" Plugin 'chrisbra/Colorizer'
" let g:colorizer_auto_color = 1
" faster version?
Plugin 'RRethy/vim-hexokinase'

" python folding
" Plugin 'tmhedberg/SimpylFold'
Plugin 'kalekundert/vim-coiled-snake'
Plugin 'Konfekt/FastFold'

" Plugin 'benknoble/vim-auto-origami'
" augroup autofoldcolumn
"   au!
"   " Or whatever autocmd-events you want
"   au CursorHold,BufWinEnter,WinEnter * AutoOrigamiFoldColumn
" augroup END

" markdown folding
Plugin 'masukomi/vim-markdown-folding'

" attempt to make folding more persistant
Plugin 'zhimsel/vim-stay'
" stay/view will annoyingly remember to change working dirs when opening files
" sometimes, this should prevent that
set noautochdir

" clojure stuff
Plugin 'guns/vim-sexp'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'
" Plugin 'tpope/vim-fireplace'
" use this until my PR is merged
Plugin 'kovasap/vim-fireplace'
" Plugin 'tpope/vim-salve'
Plugin 'guns/vim-clojure-static'
Plugin 'guns/vim-clojure-highlight'
Plugin 'kien/rainbow_parentheses.vim'

Plugin 'RRethy/vim-illuminate'

" auto pair parens
" Plugin 'jiangmiao/auto-pairs'
" this version does not auto-pair if the next character is non-whitespace (with
" given option below)
" Plugin 'eapache/auto-pairs'
" let g:AutoPairsOnlyWhitespace = 1
" let g:AutoPairsMultilineClose = 0
" let g:AutoPairsWildClosedPair = ''
Plugin 'cohama/lexima.vim'
Plugin 'tpope/vim-surround'

" attmpts to make vim better when reading terminal data from kitty TODO finish
" making this owrk
Plugin 'powerman/vim-plugin-AnsiEsc'
Plugin 'rkitover/vimpager'

Plugin 'dart-lang/dart-vim-plugin'

Plugin 'tikhomirov/vim-glsl'

" OSX stupid backspace fix
set backspace=indent,eol,start

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

if isdirectory("/google")
  " google specific stuff
  source /usr/share/vim/google/google.vim
  Glug youcompleteme-google
  Glug codefmt
  Glug codefmt-google
  Glug corpweb
  " see https://user.git.corp.google.com/lerm/glint-ale/?pli=1
  Glug glug sources+=`$HOME . '/.vim/local'`
  Glug glint-ale
  " Glug csearch
  " Fix BUILD dependencies when writing file
  " not sure why this doesn't work and i have to call
  " build_cleaner myself
  " Glug blazedeps
  augroup FixBuild
    autocmd FileType go,java,c,cpp,python
        \ autocmd! FixBuild BufWritePost <buffer> silent !build_cleaner %:p &> /tmp/build_cleaner.log &
  augroup END
  " Autoformat files on write
  augroup autoformat_settings
    " autocmd FileType borg,gcl,patchpanel AutoFormatBuffer gclfmt
    autocmd FileType bzl AutoFormatBuffer buildifier
    " autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
    " autocmd FileType proto AutoFormatBuffer clang-format
    " autocmd FileType dart AutoFormatBuffer dartfmt
    " autocmd FileType go AutoFormatBuffer gofmt
    " autocmd FileType java AutoFormatBuffer google-java-format
    " autocmd FileType jslayout AutoFormatBuffer jslfmt
    " autocmd FileType markdown AutoFormatBuffer mdformat
    " autocmd FileType ncl AutoFormatBuffer nclfmt
    " autocmd FileType python AutoFormatBuffer pyformat
    " autocmd FileType textpb AutoFormatBuffer text-proto-format
    " autocmd FileType html,css,json AutoFormatBuffer js-beautify
  augroup END
  let g:signify_skip_filename_pattern = ['\.pipertmp.*']

  " open all buffers that have changed since the root fig revision
  function OpenFigFiles()
    bufdo bwipeout
    let base_cl_cmd = 'hg log -r p4base --template "{node}\n"'
    let files_to_open_cmd = 'hg st -n --rev $(eval '''.base_cl_cmd.''') | sed ''s/^google3\///'''
    let files_to_open = system(files_to_open_cmd)
    echo files_to_open_cmd
    for i in split(files_to_open)
      execute "e ".i
    endfor
  endfunction
  command! OpenFigFiles call OpenFigFiles()
  nnoremap <C-a> :OpenFigFiles<CR>
endif


" update signify whenever we get focus, not just on save
" let g:signify_update_on_focusgained = 1
let g:signify_realtime = 1
let g:signify_cursorhold_insert = 0
let g:signify_cursorhold_normal = 0

" TODO store the current hg revision in target_commit
" make it easy to diff again last committed revision for google stuff, as found
" by this command:
" hg log -r smart --template '{node}\n' | tail -1

" diff against older revision for signify gutter
let g:target_commit = 0
command! SignifyOlder call ChangeTargetCommit('older')
command! SignifyNewer call ChangeTargetCommit('younger')
nnoremap ]r :SignifyOlder<CR>
nnoremap [r :SignifyNewer<CR>
" TODO supply specific revision
" command! -nargs=1 SignifyRev call ChangeTargetCommit(<args>)

" taken from https://github.com/mhinz/vim-signify/issues/284
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

" toggle hg diff
function HgDiffTarget()
  let l:cur_rev_cmd = printf('hg log --rev .~%d --template ''{node}''', g:target_commit)
  let l:cur_rev = system(l:cur_rev_cmd)
  execute 'Hgvdiff' l:cur_rev
endfunction
command! HgDiffTargetCmd call HgDiffTarget()
nnoremap <C-d> :HgDiffTargetCmd<CR>

" make obtain/put commands in diff mode auto jump to the next change
nnoremap do do]c
nnoremap dp dp]c

" see https://github.com/mhinz/vim-startify/issues/149
" let g:startify_enable_unsafe = 1

" NERDTree options
let g:NERDTreeWinSize=50

" NERDTree mercurial options
" original
" let g:NERDTreeIndicatorMapCustom = {
"     \ "Modified"  : "✹",
"     \ "Staged"    : "✚",
"     \ "Untracked" : "✭",
"     \ "Renamed"   : "➜",
"     \ "Unmerged"  : "═",
"     \ "Deleted"   : "✖",
"     \ "Dirty"     : "✗",
"     \ "Clean"     : "✔︎",
"     \ "Unknown"   : "?"
"     \ }
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "mod",
    \ "Staged"    : "✚",
    \ "Untracked" : "unt",
    \ "Renamed"   : "ren",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "del",
    \ "Dirty"     : "dir",
    \ "Clean"     : "cln",
    \ "Unknown"   : "?"
    \ }
" map <C-n> :NERDTreeToggle<CR>

" you complete me options
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
" let g:ycm_server_keep_logfiles = 1
" let g:ycm_server_log_level = 'debug'
let g:ycm_confirm_extra_conf = 0
nmap gd :YcmCompleter GoTo<CR>
nmap gc :YcmCompleter GetDoc<CR>

if isdirectory("/google")
  au User lsp_setup call lsp#register_server({
      \ 'name': 'Kythe Language Server',
      \ 'cmd': {server_info->['/google/bin/releases/grok/tools/kythe_languageserver', '--google3']},
      \ 'whitelist': ['python', 'go', 'java', 'cpp', 'proto', 'bzl'],
      \})

  nnoremap gd :<C-u>LspDefinition<CR>
  nnoremap ga :<C-u>LspReferences<CR>
  autocmd Filetype python nmap <buffer> gd :YcmCompleter GoTo<CR>
endif

" disable all jedi vim stuff except renaming (since YCM does it all)
if !isdirectory("/google")
  let g:jedi#completions_enabled = 0
  let g:jedi#goto_command = ""
  let g:jedi#goto_assignments_command = "ga"
  let g:jedi#goto_definitions_command = "gd"
  let g:jedi#documentation_command = "gc"
  let g:jedi#usages_command = "ga"
  let g:jedi#completions_command = ""
  let g:jedi#rename_command = "gr"
endif

" add airline specification
" let g:airline#extensions#bufferline#enabled = 1
" let g:bufferline_show_bufnr = 0
" let g:bufferline_rotate = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#displayed_head_limit = 15
let g:airline#extensions#ale#enabled = 1
" in ~/.vim/autoload/airline/themes/terminal.vim
let g:airline_theme='terminal'
" use :help statusline for customization options here
let g:airline_section_c = '%f%m'
" play with this if filename is too long
" let g:airline#extensions#default#section_truncate_width =
let g:airline_section_z = ''
" disables whitespace warnings in bottom right corner
" let g:airline#extensions#whitespace#enabled = 0
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#buffer_nr_show = 1

" enable theme
set background=dark
let g:python_highlight_all = 1
let g:python_highlight_class_vars = 1
syntax enable
" refresh syntax whenever entering a buffer, useful to fix problems by just
" flipping between buffers
autocmd BufEnter * :syntax sync fromstart
set colorcolumn=80
" do not change terminal background
" highlight NonText ctermbg=none
" highlight Normal ctermbg=none
colorscheme terminal
" map to show what highlight group is under the cursor when key is pressed,
" useful for debugging colorscheme issues
map <C-S> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" file specific stuff
autocmd Filetype markdown setlocal spell spelllang=en_us
autocmd Filetype latex setlocal spell spelllang=en_us

" switch between buffers without saving
set hidden

" show line numbers
set nu

" highlight current line
" hi clear CursorLine
" hi CursorLineNR term=bold cterm=bold guibg=Grey40
" set cursorline

" highlight word occurances
" :autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

" don't show scrollbars in macvim
set guioptions=

" use mouse in terminal
set mouse=a

" use system clipboard for everything by default
" see https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
set clipboard=unnamedplus

" copy filename to clipboard shortcut
if isdirectory("/google")
  " get path relative to google3 root
  function GetGoogle3RelativePath(path)
    let split_path = split(a:path, "google3/")
    if len(split_path) == 2
      return split_path[1]
    else
      return a:path
    endif
  endfunction
  nnoremap cp :let @+ = GetGoogle3RelativePath(expand("%:p"))<CR>
else
  nnoremap cp :let @+ = expand("%:p")<CR>
endif

" wrap lines on word
set wrap
set linebreak
set nolist  " list disables linebreak
set textwidth=80
set wrapmargin=0
set formatoptions+=l
set formatoptions+=t  " should wrap lines after 80 characters
au BufNewFile *.tex 0r ~/.vim/tex.skel

" folding
" set foldmethod=syntax
set foldmethod=indent
autocmd FileType markdown set foldmethod=expr
" set foldcolumn=1
" unfolded by default
set foldlevelstart=99
set foldnestmax=2
" no dashed lines for folds (spaces instead - note space after backslash)
set fillchars=fold:\ 
" capital A/F makes unfolding/folding recursive
" normal mode bind
nnoremap <space> za
nnoremap <C-space> zA
" visual mode bind
vnoremap <space> zf
vnoremap <C-space> zF
" do not refold when saving file
" augroup remember_folds
"   autocmd!
"   au BufWinLeave ?* mkview 1
"   au BufWinEnter ?* silent! loadview 1
" augroup END

" key rebindings
noremap j gj
noremap k gk
set scrolloff=0
nnoremap <C-g> :let &scrolloff=999-&scrolloff<CR>

" fzf options
" search in files starting from directory with current buffer and working way up
" query, [[ag options], options]
let s:TYPE = {'dict': type({}), 'funcref': type(function('call')),
      \       'string': type(''), 'list': type([])}
function! s:warn(message)
  echohl WarningMsg
  echom a:message
  echohl None
  return 0
endfunction
function! s:myag(query, ...)
  if type(a:query) != s:TYPE.string
    return s:warn('Invalid query argument')
  endif
  let query = empty(a:query) ? '^(?=.)' : a:query
  let args = copy(a:000)
  let ag_opts = len(args) > 1 && type(args[0]) == s:TYPE.string ? remove(args, 0) : ''
  let command = ag_opts . ' ' . fzf#shellescape(query) . ' ' .
        \ printf('$(find_up.bash %s -type f | head -n 100)',
        \        expand('%:h')) 
  return call('fzf#vim#ag_raw', insert(args, command, 0))
endfunction
command! -bang -nargs=* MyAg call s:myag(<q-args>, <bang>0)
nnoremap <C-p> :MyAg 

function! s:dirag(query, ...)
  if type(a:query) != s:TYPE.string
    return s:warn('Invalid query argument')
  endif
  let query = empty(a:query) ? '^(?=.)' : a:query
  let args = copy(a:000)
  let ag_opts = len(args) > 1 && type(args[0]) == s:TYPE.string ? remove(args, 0) : ''
  let command = ag_opts . ' ' . fzf#shellescape(query) . ' ' . expand('%:h')
  return call('fzf#vim#ag_raw', insert(args, command, 0))
endfunction
command! -bang -nargs=* DirAg call s:dirag(<q-args>, <bang>0)
autocmd FileType dirvish nnoremap <buffer> <C-p> :DirAg<CR>


if isdirectory("/google")
  nnoremap <C-A-p> :CSearch 
  nnoremap <C-p> :Lines<CR>
endif

nnoremap <A-/> :Buffers<CR>

" search for files starting from directory with current buffer and working way
" up, limiting search to 1000 files
" strangely, C-/ gets recognized as C-_ by vim in the terminal
nnoremap <C-_> :Files<CR>
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'source': printf('find_up.bash %s -type f | head -n 10000', expand('%:h')),
  \                               'options': '--tiebreak=index'}, <bang>0)

" use alt-j/k to switch between split windows
nnoremap <A-k> <C-w>W
nnoremap <A-j> <C-w>w
" use alt-h/l to resize vertial split windows
nnoremap <A-h> :vertical resize +1<CR>
nnoremap <A-l> :vertical resize -1<CR>
" make vertical split with alt-v and move to next split
nnoremap <A-v> :vsplit \| wincmd w<CR>
" close windows with alt-w
nnoremap <A-w> <C-w>c

" use ctrl-j/k to scroll quickly, and recenter the screen before and after each
" scroll.  do not change the jumplist when doing this, since it is supposed to
" emulate scrolling
nnoremap <C-j> :keepjumps normal 10jzz<CR>
vnoremap <C-j> 10jzz
nnoremap <C-k> :keepjumps normal 10kzz<CR>
vnoremap <C-k> 10kzz

" remap vim-sexp commands that conflict with my alt mappings
let g:sexp_mappings = {'sexp_swap_list_backward': '<M-w>',
                     \ 'sexp_swap_list_forward' : '<M-e>'}
autocmd FileType g:sexp_filetypes unmap <M-j>
autocmd FileType g:sexp_filetypes unmap <M-k>
let g:sexp_enable_insert_mode_mappings = 0

" use alt-shift-j/k to go between buffers (ctrl-w closes buffers)
nmap <A-K> :bp<CR>
nmap <A-J> :bn<CR>
nmap <C-w> :BDandquit<CR>

" once the last buffer is closed, quit vim
fun! s:quitiflast()
    BD
    let bufcnt = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if bufcnt < 1
        echo 'shutting everything down'
        quit
    endif
endfun
command! BDandquit :call s:quitiflast()

" makes vim faster when making new lines after long lines by preventing syntax
" highlighting after a certain width
:set synmaxcol=200

" trim all trailing whitespace in the file
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction
command! TrimWhitespace call TrimWhitespace()

" get diff between current buffer and what is saved to disk
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" ERROR NOTES
" neovim E667: Fsync failed: operation not supported on socket
" solved by running :set nofsync
set nofsync

set number
set relativenumber

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" ale options
if isdirectory("/google")
  " we are in google land
  let g:ale_linters = {}
  let g:ale_linters.python = ['gpylint']
  let g:ale_linters.java = ['glint']
  let g:ale_linters.markdown = ['gmdlint']
  let g:ale_linters.javascript = ['glint']
  let g:ale_linters.proto = ['glint']
  let g:ale_linters.bzl = ['glint']
  " we use go/ycm and clangd for linting
  let g:ale_linters.c = []
  let g:ale_linters.cpp = []
  let g:ale_linters.go = ['govet']
  " By default, ale attempts to traverse up the file directory to find a
  " virtualenv installation. This can cause high latency (~15s) in citc clients
  " when opening Python files. Setting the following flag to `1` disables that.
  let g:ale_python_gpylint_use_global = 1
  let g:ale_virtualenv_dir_names = []
  " see https://sites.google.com/a/google.com/woodylin/gpylint-buffered-ale
  let g:ale_python_gpylint_executable = 'bash'
  let g:ale_python_gpylint_options = ' -c '."'".'tf=$(mktemp /tmp/tmp.gpylint.XXXXXX) ; trap "rm -rf $tf" 0 ; cat > $tf ; gpylint3 "$@" $tf'."'".' dummycmd --no-docstring-rgx=.'
  " TODO remove this once https://github.com/w0rp/ale/issues/2613 is resolved
  " let g:ale_enabled = 0
  let g:ale_use_global_executables = 1 " https://groups.google.com/a/google.com/d/msg/vi-users/Ib0esClj_5k/1yqQEonwBwAJ
  let g:ale_cache_executable_check_failures = 1
else
  let g:ale_linters = {'python': ['flake8'],
    \                  'clojure': 'all'}
  " TODO revisit mypy when https://github.com/python/mypy/issues/5772 is
  " resolved, or if it is needed for the project
  " let g:ale_linters = {'python': ['flake8', 'mypy']}
  " let flake8 handle syntax checking, mypy only typing
  " let g:ale_python_mypy_ignore_invalid_syntax = 1
  " let g:ale_python_mypy_options = '--ignore-missing-imports'
  " E306 requires blank line before inline function definition
  " E402 requires all imports be at top of file
  " E302 requires blank lines before module-level functions
  " let g:ale_python_flake8_options = ' --ignore=E306,E402,E302 '
endif
" move between errors
nnoremap ]e :ALENextWrap<CR>
nnoremap [e :ALEPreviousWrap<CR>

" make new lines indent automatically
set autoindent
filetype plugin indent on
" show tabs as actual characters
set list
set listchars=tab:>-
set tabstop=4
set shiftwidth=4
set expandtab
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType bzl setlocal shiftwidth=4 tabstop=4
" see https://yaqs.googleplex.com/eng/q/5883314352685056 for golang 8 width tab
" issue

" auto close brackets
" inoremap {      {}<Left>
" inoremap {<CR>  {<CR>}<Esc>O
" inoremap {}     {}
" inoremap [      []<Left>
" inoremap [<CR>  [<CR>]<Esc>O
" inoremap []     []
" inoremap (      ()<Left>
" inoremap (<CR>  (<CR>)<Esc>O
" inoremap ()     ()

" rainbow parens!
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" change order here (format is [termcolor, guicolor])
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['black',       'SeaGreen3'],
    \ ['red',         'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['brown',       'firebrick3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['gray',        'RoyalBlue3'],
    \ ]

" clojure goto declarations
autocmd FileType clojure nnoremap <buffer> gd :normal [<c-d><cr>
" clojure reload into repl on save
autocmd BufWritePost *.clj silent !Require
autocmd BufWritePost *.cljc silent !Require
autocmd BufWritePost *.cljs silent !Require
" treat joke files are clojure files
autocmd BufEnter *.joke :setlocal filetype=clojure

let g:AutoPairsFlyMode = 1
