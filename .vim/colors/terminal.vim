set background=dark
highlight clear

let g:colors_name = 'terminal'
if exists('syntax_on')
  syntax reset
endif

highlight Normal ctermfg=7
highlight Comment ctermfg=8
highlight default link shComment Comment
highlight default link vimLineComment Comment
highlight Constant ctermfg=4
highlight String ctermfg=6
highlight Character ctermfg=10
highlight Number ctermfg=12
highlight Boolean ctermfg=5
highlight Float ctermfg=12

highlight Identifier ctermfg=3
highlight Function ctermfg=2

highlight Statement ctermfg=13
highlight Conditional ctermfg=13
highlight default link Repeat Statement
highlight default link Label Statement
highlight default link Keyword Statement
highlight default link Exception Statement
highlight Operator ctermfg=13

highlight PreProc ctermfg=2
highlight Include ctermfg=11
highlight Define ctermfg=11
highlight Macro ctermfg=11
highlight PreCondit ctermfg=11

highlight Type ctermfg=6
highlight StorageClass ctermfg=5
highlight Typedef ctermfg=5
highlight Structure ctermfg=5

highlight Special ctermfg=10
highlight SpecialChar ctermfg=1
highlight Tag ctermfg=1
highlight Delimiter ctermfg=1
highlight SpecialComment ctermfg=1
highlight Debug ctermfg=1

highlight TabLine ctermfg=0 ctermbg=1
highlight TabLineFill ctermfg=0 ctermbg=1
highlight TabLineSel cterm=bold ctermfg=1
highlight Visual ctermbg=8
highlight default link VisualNOS Visual
highlight Underlined cterm=underline
highlight Error ctermfg=1 ctermbg=1   
highlight WarningMsg ctermfg=3 ctermbg=1
highlight WildMenu  ctermbg=1
highlight Todo cterm=underline ctermfg=15 ctermbg=none
highlight DiffAdd cterm=none ctermfg=14 ctermbg=none
highlight DiffChange cterm=none ctermfg=11 ctermbg=none
highlight DiffDelete cterm=none ctermfg=9 ctermbg=none
highlight DiffText cterm=none ctermfg=7 ctermbg=none
highlight DiffFile cterm=none ctermfg=6 ctermbg=none  
highlight DiffNewFile cterm=none ctermfg=6 ctermbg=none  
highlight default link DiffRemoved DiffDelete
highlight DiffLine cterm=none ctermfg=4 ctermbg=none  
highlight default link DiffAdded DiffAdd
highlight default link ErrorMsg Error
highlight default link FullSpace Error
highlight Ignore ctermbg=none  
highlight ModeMsg ctermfg=none  

" this is what gets overlaid on the bad text
highlight ALEError cterm=underline ctermbg=5
highlight ALEWarning cterm=underline ctermbg=0
highlight ALEInfo cterm=underline ctermbg=0
highlight ALEStyleError cterm=underline ctermbg=5
highlight ALEStyleWarning cterm=underline ctermbg=0

" this is what gets put in the gutter on the left of the line numbers
highlight ALEErrorSign cterm=bold ctermfg=5 ctermbg=8
highlight ALEWarningSign cterm=bold ctermfg=3 ctermbg=8
highlight ALEInfoSign cterm=bold ctermfg=3 ctermbg=8
highlight ALEStyleErrorSign cterm=bold ctermfg=5 ctermbg=8
highlight ALEStyleWarningSign cterm=bold ctermfg=3 ctermbg=8

highlight VertSplit ctermfg=0 ctermbg=0
highlight Folded ctermfg=8 ctermbg=none
highlight FoldColumn ctermfg=8 ctermbg=none
highlight SignColumn ctermfg=8 ctermbg=none
highlight SpecialKey term=underline ctermfg=8
highlight NonText ctermfg=0
highlight StatusLine ctermfg=0 ctermbg=15 cterm=none
highlight StatusLineNC ctermfg=0 ctermbg=15 cterm=none
if version >= 700
  " uncomment if you want a cursorline
  " highlight CursorLine cterm=none ctermbg=235  
  " highlight CursorLineNr term=underline cterm=bold ctermfg=148 ctermbg=235   
  highlight clear CursorLine
  highlight CursorLineNr term=NONE ctermbg=NONE 

  highlight ColorColumn ctermbg=8
  highlight Cursor term=reverse cterm=reverse   
  highlight CursorColumn ctermbg=8
  highlight LineNr ctermfg=8
  highlight MatchParen ctermbg=8
  highlight Pmenu ctermfg=8 ctermbg=0
  highlight PmenuSel ctermfg=8 ctermbg=6
  highlight PmenuSbar ctermfg=8 ctermbg=5
  highlight PmenuThumb ctermfg=8 ctermbg=7
endif
highlight FoldColumn ctermfg=3
highlight Search ctermbg=2 cterm=underline
highlight IncSearch cterm=reverse ctermbg=2

" do not know what this does; should delete if unimportant
" if exists('*getmatches')
" 
"   function! s:newmatch() abort
"     if !get(g:, 'landscape_highlight_todo', 0) && !get(g:, 'landscape_highlight_full_space', 0)
"       return
"     endif
"     for m in getmatches()
"       if m.group ==# 'Todo' || m.group ==# 'FullSpace'
"         silent! call matchdelete(m.id)
"       endif
"     endfor
"     if get(g:, 'landscape_highlight_todo', 0)
"       call matchadd('Todo', '\c\<todo\>', 10)
"     endif
"     if get(g:, 'landscape_highlight_full_space', 0)
"       call matchadd('FullSpace', "\u3000", 10)
"     endif
"   endfunction
" 
"   augroup landscape-newmatch
"     autocmd!
"     autocmd VimEnter,BufNew,WinEnter,FileType,BufReadPost * call s:newmatch()
"   augroup END
" 
" endif

highlight SpellBad cterm=none ctermbg=5
highlight default link SpellCap SpellBad
highlight default link SpellLocal SpellBad
highlight default link SpellRare SpellBad

highlight default link vimCmplxRepeat Normal

" for vimshell, vimfiler, unite.vim
highlight default link Command Function
highlight default link GitCommand Constant
highlight default link Arguments Type
highlight default link PdfHtml Function
highlight default link Archive Special
highlight default link Image Type
highlight default link Multimedia SpecialComment
highlight default link System Comment
highlight default link Text Constant
highlight default link Link Constant
highlight default link Exe Statement
highlight default link Prompt PreCondit
highlight default link Icon LineNr
highlight Time ctermfg=2 ctermbg=none  
highlight Date ctermfg=2 ctermbg=none  
highlight default link DateToday Special
highlight default link DateWeek Identifier
highlight default link DateOld Comment
highlight default link Path Preproc
highlight default link Marked StorageClass
highlight default link Title Identifier

" Conceal
" CursorIM
highlight Directory ctermfg=2 ctermbg=none  
" ModeMsg
" MoreMsg
" Question
