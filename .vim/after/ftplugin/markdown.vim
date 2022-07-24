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

set textwidth=0
set colorcolumn=80
set formatoptions=
syntax on
let g:sentencer_textwidth = 80
let g:sentencer_overflow = 0
set formatexpr=sentencer#Format()
autocmd InsertLeave * execute "normal gwap"
