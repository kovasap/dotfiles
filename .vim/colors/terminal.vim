set background=dark
hi clear

let g:colors_name = 'terminal'
if exists('syntax_on')
  syntax reset
endif

hi Normal ctermfg=7
hi Comment ctermfg=8
hi default link shComment Comment
hi default link vimLineComment Comment
hi Constant ctermfg=7
hi String ctermfg=2
hi link @string.regexp String
hi link @string.special String
hi link @string.special.symbol String
hi link @string.special.path String
hi link @lsp.type.keyword.clojure String
hi Character ctermfg=10
hi Number ctermfg=3
hi Boolean ctermfg=3
hi Float ctermfg=3

hi Identifier cterm=none ctermfg=7
hi Function ctermfg=6

hi Statement ctermfg=3
hi Conditional ctermfg=1
hi default link Repeat Statement
hi default link Label Statement
hi default link Keyword Statement
hi default link Exception Statement
hi default link Operator Statement

hi PreProc ctermfg=2
hi Include ctermfg=11
hi Define ctermfg=11
hi Macro ctermfg=11
hi PreCondit ctermfg=11

hi Type ctermfg=6
hi StorageClass ctermfg=6
hi Typedef ctermfg=6
hi Structure ctermfg=6

hi Special ctermfg=6
hi SpecialChar ctermfg=1
hi Tag ctermfg=1
hi Delimiter ctermfg=1
hi SpecialComment ctermfg=1
hi Debug ctermfg=1

hi TabLine ctermfg=0 ctermbg=1
hi TabLineFill ctermfg=0 ctermbg=1
hi TabLineSel cterm=bold ctermfg=1
hi Visual ctermbg=8
hi default link VisualNOS Visual
hi Underlined cterm=underline
hi Error ctermbg=1
hi WarningMsg ctermfg=3
hi WildMenu  ctermbg=1
hi Todo cterm=underline ctermfg=15 ctermbg=none
hi DiffAdd cterm=none ctermfg=14 ctermbg=none
hi DiffChange cterm=none ctermfg=12 ctermbg=none
hi DiffDelete cterm=none ctermfg=9 ctermbg=none
hi DiffText cterm=none ctermfg=12 ctermbg=none
hi DiffFile cterm=none ctermfg=6 ctermbg=none
hi DiffNewFile cterm=none ctermfg=6 ctermbg=none
hi default link DiffRemoved DiffDelete
hi DiffLine cterm=none ctermfg=4 ctermbg=none
hi default link DiffAdded DiffAdd
hi default link ErrorMsg Error
hi default link FullSpace Error
hi Ignore ctermbg=none
hi ModeMsg ctermfg=none

" LSP highlights
hi LspDiagnosticsDefaultError cterm=bold ctermfg=1
hi LspDiagnosticsDefaultWarning cterm=bold ctermfg=3
hi LspDiagnosticsDefaultInformation cterm=bold ctermfg=3
hi LspDiagnosticsDefaultHint cterm=bold ctermfg=3

hi LspDiagnosticsUnderlineError cterm=underline ctermbg=0
hi LspDiagnosticsUnderlineWarning cterm=underline ctermbg=0
hi LspDiagnosticsUnderlineInformation cterm=underline ctermbg=0
hi LspDiagnosticsUnderlineHint cterm=underline ctermbg=0


hi IlluminatedWordText cterm=underline
hi IlluminatedWordRead cterm=underline
hi IlluminatedWordWrite cterm=underline

hi default link MiniMapSymbolLine Comment
hi default link MiniMapSymbolView Comment

" this is what gets overlaid on the bad text
hi ALEError cterm=underline ctermbg=0
hi ALEWarning cterm=underline ctermbg=0
hi ALEInfo cterm=underline ctermbg=0
hi ALEStyleError cterm=underline ctermbg=5
hi ALEStyleWarning cterm=underline ctermbg=0

" this is what gets put in the gutter on the left of the line numbers
hi ALEErrorSign cterm=bold ctermfg=5 ctermbg=8
hi ALEWarningSign cterm=bold ctermfg=3 ctermbg=8
hi ALEInfoSign cterm=bold ctermfg=3 ctermbg=8
hi ALEStyleErrorSign cterm=bold ctermfg=5 ctermbg=8
hi ALEStyleWarningSign cterm=bold ctermfg=3 ctermbg=8

" what will be used to hi similar words
hi illuminatedWord cterm=bold

hi default link PathfinderPopup Comment

hi default link ScrollViewSearch Character

" Kitty color 17 is set to be ALMOST the background color of the terminal
hi WinSeparator ctermfg=17 ctermbg=17 cterm=none

hi Folded ctermfg=6 ctermbg=none
hi FoldColumn ctermfg=8 ctermbg=none
hi SignColumn ctermfg=8 ctermbg=none
hi SpecialKey term=underline ctermfg=8
hi NonText ctermfg=0
hi StatusLine ctermfg=6 ctermbg=15 cterm=none
hi StatusLineNC ctermfg=6 ctermbg=15 cterm=none
hi CursorLine cterm=none ctermbg=17
hi CursorColumn cterm=none ctermbg=17
" uncomment if you want a cursorline
hi CursorLine cterm=none ctermbg=17
" hi CursorLineNr term=underline cterm=bold ctermfg=148 ctermbg=235
hi CursorLineNr term=NONE ctermbg=NONE

" Kitty color 17 is set to be ALMOST the background color of the terminal
hi ColorColumn ctermbg=17 ctermfg=none cterm=none
hi Cursor term=reverse cterm=reverse
hi LineNr ctermfg=8
hi MatchParen ctermbg=8
hi NormalFloat ctermfg=8 ctermbg=0
hi Pmenu ctermfg=8 ctermbg=0 cterm=none
hi PmenuSel ctermfg=8 ctermbg=6 cterm=none
hi PmenuSbar ctermfg=8 ctermbg=5 cterm=none
hi PmenuThumb ctermfg=8 ctermbg=7 cterm=none
hi FoldColumn ctermfg=3
hi Search ctermbg=2 cterm=underline
hi IncSearch cterm=reverse ctermbg=2

" For TinyGlimmer
hi CurSearch ctermbg=8

hi SpellBad cterm=none ctermfg=5 ctermbg=none cterm=underline
hi SpellCap cterm=none ctermfg=5 ctermbg=none cterm=underline
hi SpellLocal cterm=none ctermfg=5 ctermbg=none cterm=underline
hi SpellRare cterm=none ctermfg=5 ctermbg=none cterm=underline

hi default link vimCmplxRepeat Normal

" for vimshell, vimfiler, unite.vim
hi default link Command Function
hi default link GitCommand Constant
hi default link Arguments Type
hi default link PdfHtml Function
hi default link Archive Special
hi default link Image Type
hi default link Multimedia SpecialComment
hi default link System Comment
hi default link Text Constant
hi default link Link Constant
hi default link Exe Statement
hi default link Prompt PreCondit
hi default link Icon LineNr
hi Time ctermfg=2 ctermbg=none
hi Date ctermfg=2 ctermbg=none
hi default link DateToday Special
hi default link DateWeek Identifier
hi default link DateOld Comment
hi default link Path Preproc
hi default link Marked StorageClass
hi default link Title Identifier
hi default link markdownH1 Identifier
hi default link markdownH2 String
hi default link markdownH3 Type

hi default link LeapBackdrop Comment
hi LeapMatch ctermfg=1 term=bold
hi LeapLabel ctermfg=1 term=bold

" Conceal
" CursorIM
hi Directory ctermfg=2 ctermbg=none
" ModeMsg
" MoreMsg
" Question
