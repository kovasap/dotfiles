" https://sive.rs/1s
" https://vi.stackexchange.com/a/28620
"
" set textwidth=0
" 
" function! OneSentencePerLine()
"   if mode() =~# '^[iR]'
"     return
"   endif
"   let start = v:lnum
"   let end = start + v:count - 1
"   execute start.','.end.'join'
"   s/[.!?]\zs\s*\ze\S/\r/g
" endfunction
" 
" set formatexpr=OneSentencePerLine()

syntax on
set textwidth=0
set colorcolumn=80
set formatoptions=n

" See https://github.com/whonore/vim-sentencer/issues/3#issuecomment-1193397610
" https://blog.siddharthkannan.in/vim/configuration/2019/11/02/format-list-pat-and-vim/
let &formatlistpat='^\s*\d\+\.\s\+\|^\s*[-*+]\s\+\|^\[^\ze[^\]]\+\]:'

let g:sentencer_textwidth = 80
let g:sentencer_overflow = 0
set formatexpr=sentencer#Format()

echo 'Use ctrl+a to auto reformat sentences!'
let g:reformat_sentences = 0
nnoremap <buffer> <C-a> :let g:reformat_sentences = !get(g:, 'reformat_sentences', 1)<cr>
autocmd InsertLeave * if get(g:, 'reformat_sentences', 1) | execute "normal gqip}b$" | endif
nnoremap <buffer> <localleader>f :execute "normal gqip}b$"<CR>
" This keeps the cursor in the same place but doesn't use formatexpr.
" autocmd InsertLeave * execute "normal gwap"
