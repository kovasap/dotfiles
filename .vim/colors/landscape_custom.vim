set background=dark
highlight clear

let g:colors_name = 'landscape'
if exists('syntax_on')
  syntax reset
endif

highlight Normal   
highlight Comment term=none ctermfg=243 ctermbg=none  
highlight Constant term=none ctermfg=111  
" try also 2 (green), 13 (light brown), original was 215
highlight String term=none ctermfg=2 ctermbg=none  
highlight Character term=none ctermfg=214 ctermbg=none  
" try also 81 (blue)
highlight Number term=none ctermfg=12 ctermbg=none  
" try also 227 (yellow)
highlight Boolean term=none ctermfg=12 ctermbg=none  
highlight Float term=none ctermfg=12 ctermbg=none  

highlight Identifier term=none cterm=none ctermfg=117 ctermbg=none  
" highlight Function term=none ctermfg=123 ctermbg=none  
highlight Function term=none ctermfg=39 ctermbg=none  

" try also 10 (bgreen), 202, original was 76
highlight Statement term=none ctermfg=13 ctermbg=none  
highlight Conditional term=none ctermfg=13 ctermbg=none  
" highlight default link Conditional Statement
highlight default link Repeat Statement
highlight default link Label Statement
" highlight Operator term=none ctermfg=220 ctermbg=none  
highlight Operator term=none ctermfg=13 ctermbg=none  
highlight default link Keyword Statement
highlight default link Exception Statement

highlight PreProc term=none ctermfg=39  
" highlight Include term=none ctermfg=38  
highlight Include term=none ctermfg=147  
highlight Define term=none ctermfg=37  
highlight Macro term=none ctermfg=36  
highlight PreCondit term=none ctermfg=35  

highlight Type term=none ctermfg=39 ctermbg=none  
highlight StorageClass term=none ctermfg=130 ctermbg=none  
highlight Typedef term=none ctermfg=199 ctermbg=none  
" highlight Structure term=none ctermfg=200 ctermbg=none  
" highlight Structure term=none ctermfg=115 ctermbg=none  
highlight Structure term=none ctermfg=39 ctermbg=none  

highlight Special term=none ctermfg=178  
highlight SpecialChar term=none ctermfg=208  
highlight Tag term=none ctermfg=180  
highlight Delimiter term=none ctermfg=181  
highlight SpecialComment term=none ctermfg=182  
highlight Debug term=none ctermfg=183  

highlight TabLine ctermfg=253 ctermbg=241  
highlight TabLineFill ctermfg=253 ctermbg=241  
highlight TabLineSel cterm=bold ctermfg=253 
highlight Visual term=none ctermbg=240 
highlight default link VisualNOS Visual
highlight Underlined term=underline ctermfg=45  
highlight Error term=none ctermfg=15 ctermbg=124   
highlight WarningMsg term=none ctermfg=7 ctermbg=0   
highlight WildMenu  ctermbg=214
highlight Todo cterm=underline ctermfg=141 ctermbg=none   
highlight DiffAdd term=none cterm=none ctermfg=none ctermbg=22  
highlight DiffChange term=none cterm=none ctermfg=none ctermbg=52  
highlight DiffDelete term=none cterm=none ctermfg=none ctermbg=88  
highlight DiffText term=none cterm=none ctermfg=none ctermbg=160  
highlight DiffFile term=none cterm=none ctermfg=47 ctermbg=none  
highlight DiffNewFile term=none cterm=none ctermfg=199 ctermbg=none  
highlight default link DiffRemoved DiffDelete
highlight DiffLine term=none cterm=none ctermfg=129 ctermbg=none  
highlight default link DiffAdded DiffAdd
highlight default link ErrorMsg Error
highlight default link FullSpace Error
highlight Ignore ctermbg=none  
highlight ModeMsg ctermfg=none  

highlight ALEError cterm=underline ctermbg=88
highlight ALEWarning cterm=underline ctermbg=0
highlight ALEInfo cterm=underline ctermbg=0
highlight ALEStyleError cterm=underline ctermbg=88
highlight ALEStyleWarning cterm=underline ctermbg=0

highlight ALEErrorSign ctermbg=124
highlight ALEWarningSign ctermbg=4
highlight ALEInfoSign ctermbg=4
highlight ALEStyleErrorSign ctermbg=166
highlight ALEStyleWarningSign ctermbg=166

highlight VertSplit term=none     ctermfg=black ctermbg=darkgray cterm=none
highlight Folded term=none ctermfg=247 ctermbg=235  
highlight FoldColumn term=none ctermfg=247 ctermbg=235  
highlight SignColumn term=none ctermfg=247 ctermbg=235  
highlight SpecialKey term=underline ctermfg=237  
highlight NonText term=none ctermfg=black  
highlight StatusLine term=none     ctermfg=234 ctermbg=255 cterm=none
highlight StatusLineNC term=none     ctermfg=235 ctermbg=240 cterm=none
if version >= 700
  if get(g:, 'landscape_cursorline', 1)
    highlight CursorLine term=none cterm=none ctermbg=235  
    highlight CursorLineNr term=underline cterm=bold ctermfg=148 ctermbg=235   
  else
    highlight clear CursorLine
    highlight CursorLineNr term=NONE ctermbg=NONE 
  endif
  highlight ColorColumn term=none cterm=none ctermbg=239  
  highlight Cursor term=reverse cterm=reverse   
  highlight CursorColumn term=none cterm=none ctermbg=235  
  highlight LineNr term=none ctermfg=58 ctermbg=none  
  highlight MatchParen ctermfg=none ctermbg=238 
  highlight Pmenu ctermfg=233 ctermbg=249   
  highlight PmenuSel ctermfg=233 ctermbg=242   
  highlight PmenuSbar ctermfg=233 ctermbg=244   
  highlight PmenuThumb ctermfg=233 ctermbg=239   
endif
" highlight Search cterm=reverse ctermfg=220 ctermbg=234   
highlight Search ctermfg=none ctermbg=22 cterm=underline
highlight IncSearch cterm=reverse ctermfg=136 ctermbg=236   

if exists('*getmatches')

  function! s:newmatch() abort
    if !get(g:, 'landscape_highlight_todo', 0) && !get(g:, 'landscape_highlight_full_space', 0)
      return
    endif
    for m in getmatches()
      if m.group ==# 'Todo' || m.group ==# 'FullSpace'
        silent! call matchdelete(m.id)
      endif
    endfor
    if get(g:, 'landscape_highlight_todo', 0)
      call matchadd('Todo', '\c\<todo\>', 10)
    endif
    if get(g:, 'landscape_highlight_full_space', 0)
      call matchadd('FullSpace', "\u3000", 10)
    endif
  endfunction

  augroup landscape-newmatch
    autocmd!
    autocmd VimEnter,BufNew,WinEnter,FileType,BufReadPost * call s:newmatch()
  augroup END

endif

highlight SpellBad term=none cterm=none ctermbg=52  
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
highlight Time ctermfg=141 ctermbg=none  
highlight Date ctermfg=140 ctermbg=none  
highlight default link DateToday Special
highlight default link DateWeek Identifier
highlight default link DateOld Comment
highlight default link Path Preproc
highlight default link Marked StorageClass
highlight default link Title Identifier

" Conceal
" CursorIM
highlight Directory term=none ctermfg=2 ctermbg=none  
" ModeMsg
" MoreMsg
" Question
