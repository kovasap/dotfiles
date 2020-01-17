" see https://sites.google.com/a/google.com/woodylin/gpylint-buffered-ale for
" modifications to allow linting before saving file to disk

call ale#Set('python_gpylint_executable', 'gpylint3')
call ale#Set('python_gpylint_options', '')
call ale#Set('python_gpylint_use_global', get(g:, 'ale_use_global_executables', 0))
call ale#Set('python_gpylint_change_directory', 1)

function! ale_linters#python#gpylint#GetExecutable(buffer) abort
    return ale#python#FindExecutable(a:buffer, 'python_gpylint', ['gpylint3'])
endfunction

function! ale_linters#python#gpylint#GetCommand(buffer) abort
    let l:cd_string = ale#Var(a:buffer, 'python_gpylint_change_directory')
    \   ? ale#path#BufferCdString(a:buffer)
    \   : ''

    let l:executable = ale_linters#python#gpylint#GetExecutable(a:buffer)

    let l:exec_args = l:executable =~? 'pipenv$'
    \   ? ' run gpylint'
    \   : ''

    return l:cd_string
    \   . ale#Escape(l:executable) . l:exec_args
    \   . ' ' . ale#Var(a:buffer, 'python_gpylint_options')
    \   . ' --output-format=text --msg-template="{path}:{line}:{column}: {msg_id} ({symbol}) {msg}" --reports=n'
    " \   . ' %s'
endfunction

call ale#linter#Define('python', {
\   'name': 'gpylint',
\   'executable_callback': 'ale_linters#python#gpylint#GetExecutable',
\   'command_callback': 'ale_linters#python#gpylint#GetCommand',
\   'callback': 'ale_linters#python#pylint#Handle',
\})
" \   'lint_file': 1,
