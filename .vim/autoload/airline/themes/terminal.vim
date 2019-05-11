scriptencoding utf-8

" see
" https://github.com/vim-airline/vim-airline/blob/master/autoload/airline/themes/terminal.vim
" for explanation
let g:airline#themes#terminal#palette = {}

" these arrays are guifg, guibg, ctermfg, ctermbg, opts (like underline, bold)
let s:airline_a_normal   = [ '', '', 7, 8 ]
let s:airline_b_normal   = [ '', '', 7, 0 ]
let s:airline_c_normal   = [ '', '', 7, 0 ]
let g:airline#themes#terminal#palette.normal = airline#themes#generate_color_map(s:airline_a_normal, s:airline_b_normal, s:airline_c_normal)
let g:airline#themes#terminal#palette.normal_modified = {
      \ 'airline_c': [ '', '', 7, 0, 'bold'] ,
      \ }

let g:airline#themes#terminal#palette.insert = copy(g:airline#themes#terminal#palette.normal)
let g:airline#themes#terminal#palette.insert.airline_a = [ '', '', 7, 6 ]
let g:airline#themes#terminal#palette.insert_modified = g:airline#themes#terminal#palette.normal_modified

let g:airline#themes#terminal#palette.replace = copy(g:airline#themes#terminal#palette.normal)
let g:airline#themes#terminal#palette.replace.airline_a = [ '', '', 7, 5 ]
let g:airline#themes#terminal#palette.replace_modified = g:airline#themes#terminal#palette.normal_modified


let g:airline#themes#terminal#palette.visual = copy(g:airline#themes#terminal#palette.normal)
let g:airline#themes#terminal#palette.visual.airline_a = [ '', '', 7, 4 ]
let g:airline#themes#terminal#palette.visual_modified = g:airline#themes#terminal#palette.normal_modified

let g:airline#themes#terminal#palette.inactive = copy(g:airline#themes#terminal#palette.normal)
let g:airline#themes#terminal#palette.inactive.airline_a = [ '', '', 7, 0 ]
let g:airline#themes#terminal#palette.inactive_modified = g:airline#themes#terminal#palette.normal_modified

let g:airline#themes#terminal#palette.commandline = copy(g:airline#themes#terminal#palette.normal)
let g:airline#themes#terminal#palette.commandline.airline_a = [ '', '', 7, 0 ]
let g:airline#themes#terminal#palette.commandline_modified = g:airline#themes#terminal#palette.normal_modified
