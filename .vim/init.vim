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

call plug#begin()

" --- Folding ---
set foldmethod=indent
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


" --- Language features (autocomplete and go to definition) ---
" if !isdirectory("/google")
"   Plug 'Valloric/YouCompleteMe'
" endif
" " install: https://github.com/Valloric/YouCompleteMe/blob/master/README.md#full-installation-guide
" " NOTE DO NOT INSTALL USING AN ANACONDA PYTHON!!
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_collect_identifiers_from_tags_files = 1
" " let g:ycm_server_keep_logfiles = 1
" " let g:ycm_server_log_level = 'debug'
" let g:ycm_confirm_extra_conf = 0
" nmap gd :YcmCompleter GoTo<CR>
" nmap gc :YcmCompleter GetDoc<CR>
" CoC and settings
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_user_config = {}
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


" Highlight current word with cursor on it across whole buffer
" Plug 'RRethy/vim-illuminate'
" Snippits!
" THIS WILL NOT WORK UNLESS THE NEOVIM PYTHON3 LIBRARY IS INSTALLED
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger="<c-h>"
let g:UltiSnipsJumpForwardTrigger="<c-tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-s-tab>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


" --- Linting ---
Plug 'dense-analysis/ale'
let g:ale_linters = {}
" move between errors
nnoremap ]e :ALENextWrap<CR>
nnoremap [e :ALEPreviousWrap<CR>


" --- Python ---
Plug 'neoclide/coc-python'
Plug 'davidhalter/jedi-vim'
let g:jedi#completions_enabled = 0
let g:jedi#goto_command = ""
let g:jedi#goto_assignments_command = "ga"
let g:jedi#goto_definitions_command = "gd"
let g:jedi#documentation_command = "gc"
let g:jedi#usages_command = "ga"
let g:jedi#completions_command = ""
let g:jedi#rename_command = "gr"
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-python/python-syntax'
let g:python_highlight_all = 1
let g:python_highlight_class_vars = 1
" folding
Plug 'kalekundert/vim-coiled-snake'
Plug 'Konfekt/FastFold'
let g:ale_linters.python = ['flake8']
" E306 requires blank line before inline function definition
" E402 requires all imports be at top of file
" E302 requires blank lines before module-level functions
" let g:ale_python_flake8_options = ' --ignore=E306,E402,E302 '

" --- Clojure ---
" Check out this init.vim for inspiration on configuration options:
" https://github.com/nirrub/dotfiles/blob/master/init.vim
Plug 'guns/vim-sexp'
" remap vim-sexp commands that conflict with my other mappings
let g:sexp_mappings = {'sexp_swap_list_backward': '<M-w>',
                     \ 'sexp_swap_list_forward' : '<M-e>'}
autocmd FileType g:sexp_filetypes unmap <M-j>
autocmd FileType g:sexp_filetypes unmap <M-k>
let g:sexp_enable_insert_mode_mappings = 0
Plug 'tpope/vim-sexp-mappings-for-regular-people'
" Plug 'tpope/vim-fireplace'
" use this until my PR is merged
Plug 'kovasap/vim-fireplace'
" clojure goto declarations
autocmd FileType clojure nnoremap <buffer> gd :normal [<c-d><cr>
" clojure reload into repl on save
autocmd BufWritePost *.clj silent !Require
autocmd BufWritePost *.cljc silent !Require
autocmd BufWritePost *.cljs silent !Require
" treat joke files are clojure files
autocmd BufEnter *.joke :setlocal filetype=clojure
" Plug 'tpope/vim-salve'
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-clojure-highlight'
let g:ale_linters.clojure = 'all'

" --- Markdown ---
" folding
Plug 'masukomi/vim-markdown-folding'
autocmd Filetype markdown setlocal spell spelllang=en_us
autocmd FileType markdown set foldmethod=expr

" --- LaTeX ---
autocmd Filetype latex setlocal spell spelllang=en_us
au BufNewFile *.tex 0r ~/.vim/tex.skel

" --- General Writing ---
Plug 'ron89/thesaurus_query.vim'
" curl http://www.gutenberg.org/files/3202/files/mthesaur.txt >
" ~/.vim/thesaurus/mthesaur.txt
" to get offline thesaurus
nnoremap zt :ThesaurusQueryReplaceCurrentWord<CR>

" --- GLSL ---
Plug 'tikhomirov/vim-glsl'

" --- Dart ---
Plug 'dart-lang/dart-vim-plugin'

" --- YAML ---
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

" --- Bazel ---
autocmd FileType bzl setlocal shiftwidth=4 tabstop=4



" --- Autoformatting ---
" line wrapping
set wrap
set linebreak
set nolist  " list disables linebreak
set textwidth=80
set wrapmargin=0
set formatoptions+=l
set formatoptions+=t  " should wrap lines after 80 characters
" make new lines indent automatically
set autoindent
" should reformat paragraphs whenever typing in them (not just at the end)
command AutoWrapToggle if &fo =~ 'a' | set fo-=a | else | set fo+=a | endif
nnoremap <C-a> :AutoWrapToggle<CR>
filetype plugin indent on
" Make tabs create 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab
" show tabs as actual characters
set list
set listchars=tab:>-
" trim all trailing whitespace in the file
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction
command! TrimWhitespace call TrimWhitespace()

Plug 'tpope/vim-abolish'


" --- File Indent Type Detection ---
Plug 'tpope/vim-sleuth'


" --- UI ---
Plug 'vim-airline/vim-airline'
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
set background=dark
syntax enable
" makes vim faster when making new lines after long lines by preventing syntax
" highlighting after a certain width
:set synmaxcol=200
" show line numbers
set nu
" defined in ~/.vim/colors
colorscheme terminal
" make line at 80 characters in to avoid making lines too long
set colorcolumn=80
" refresh syntax whenever entering a buffer, useful to fix problems by just
" flipping between buffers
autocmd BufEnter * :syntax sync fromstart
" map to show what highlight group is under the cursor when key is pressed,
" useful for debugging colorscheme issues
map <C-S> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" don't show scrollbars in macvim
set guioptions=
" use mouse in terminal
set mouse=a
" line numbering
set number
set relativenumber


" --- Navigation ---
noremap j gj
noremap k gk
" this mapping makes it so that the screen moves with the cursor (toggle)
set scrolloff=0
nnoremap <C-g> :let &scrolloff=999-&scrolloff<CR>
" use ctrl-j/k to scroll quickly, and recenter the screen before and after each
" scroll.  do not change the jumplist when doing this, since it is supposed to
" emulate scrolling
nnoremap <C-j> :keepjumps normal 10jzz<CR>
vnoremap <C-j> 10jzz
nnoremap <C-k> :keepjumps normal 10kzz<CR>
vnoremap <C-k> 10kzz

nnoremap <C-b> <C-v>


" --- Clipboard ---
" use system clipboard for everything by default
" see https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
set clipboard=unnamedplus
" copy filename of current buffer to clipboard
nnoremap cp :let @+ = expand("%:p")<CR>


" --- Buffer management ---
" make it so that when a buffer is deleted, the window stays
Plug 'qpkorr/vim-bufkill'
" easier buffer management
Plug 'xolox/vim-misc'
" switch between buffers without saving
set hidden
" use alt-shift-j/k to go between buffers (ctrl-w closes buffers)
nmap <A-K> :bp<CR>
nmap <A-J> :bn<CR>
nmap <C-w> :BDandquit<CR>
" once the last buffer is closed, quit vim
" TODO this doesn't always work yet...
fun! s:quitiflast()
    BD
    let bufcnt = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if bufcnt < 1
        echo 'shutting everything down'
        quit
    endif
endfun
command! BDandquit :call s:quitiflast()
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None


" --- Window Management ---
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


" --- Searching ---
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
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

" Search through all files in the current buffer's directory
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

" Search current buffer names (to switch buffers) and recently opened files
command! FZFMru call fzf#run({
\ 'source':  reverse(s:all_files()),
\ 'sink':    'edit',
\ 'options': '-m -x --tiebreak=end',
\ 'down':    '40%' })
nnoremap <A-/> :FZFMru<CR>

function! s:all_files()
  return extend(
  \ filter(copy(v:oldfiles),
  \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

" The '1000 part of this will make it so that 1000 oldfiles are remembered (the
" last 1000 files will be available with the FZFMru command)
set shada=!,'1000,<50,s10,h

" search for files starting from directory with current buffer and working way
" up, limiting search to 1000 files
" strangely, C-/ gets recognized as C-_ by vim in the terminal
nnoremap <C-_> :Files<CR>
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'source': printf('find_up.bash %s -type f | head -n 10000', expand('%:h')),
  \                               'options': '--tiebreak=index'}, <bang>0)

" --- Persistance ---
Plug 'zhimsel/vim-stay'
" stay/view will annoyingly remember to change working dirs when opening files
" sometimes, this should prevent that
set noautochdir


" --- File Browsing ---
Plug 'justinmk/vim-dirvish'
autocmd FileType dirvish nnoremap <buffer> <C-p> :DirAg<CR>


" --- Showing Changes and Diffing ---
Plug 'ludovicchabant/vim-lawrencium'
Plug 'mhinz/vim-signify'
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
"
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

" get diff between current buffer and what is saved to disk
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()


" --- Motions ---
Plug 'christoomey/vim-sort-motion'
Plug 'justinmk/vim-sneak'


" --- Parenthesis ---
Plug 'kien/rainbow_parentheses.vim'
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
Plug 'tpope/vim-surround'
Plug 'cohama/lexima.vim'
let g:lexima_enable_basic_rules = 0


" --- Color Code Highlighting ---
"  requires termguicolors
" Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
" hex color highlighting - this is currently slow
" Plug 'chrisbra/Colorizer'
" let g:colorizer_auto_color = 1


" --- Reading Terminal Output ---
" attmpts to make vim better when reading terminal data from kitty
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'rkitover/vimpager'


" --- Bugfixes ---
" OSX stupid backspace fix
set backspace=indent,eol,start
" neovim E667: Fsync failed: operation not supported on socket
" solved by running :set nofsync
set nofsync


" -- Create directories on write if they don't already exist --
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END


" --- Google ---
source ~/.vim/google.vim


" All of your Plugins must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required
