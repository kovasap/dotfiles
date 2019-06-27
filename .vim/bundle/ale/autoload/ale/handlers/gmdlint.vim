" Author: Kovas Palunas <kovas@google.com>
" Description: Adds support for Google's internal tricorder MdLint

function! ale#handlers#gmdlint#Handle(buffer, lines) abort
    let l:pattern='.*:\(\d*\):.*'
    let l:output=[]
    " last line we encountered had information about what line the linter
    " spotted a problem with
    let l:last_was_line=0

    for l:line in a:lines
        let l:match = matchlist(l:line, l:pattern)

        if !empty(l:match)
            call add(l:output, {
            \ 'lnum': l:match[1] + 0,
            \ 'type': 'W',
            \})
            let l:last_was_line=1
        elseif l:last_was_line
            let l:output[-1].text = l:line
        endif
    endfor

    return l:output
endfunction
