if isdirectory("/google")
  Plugin 'prabirshrestha/async.vim'
  Plugin 'prabirshrestha/vim-lsp'
  " gotten by doing git clone sso://user/mcdermottm/vim-csearch
  Plugin 'file:///usr/local/google/home/kovas/vim-csearch'

  set runtimepath-=~/.vim/bundle/YouCompleteMe
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
  " nnoremap <C-a> :OpenFigFiles<CR>

  au User lsp_setup call lsp#register_server({
      \ 'name': 'Kythe Language Server',
      \ 'cmd': {server_info->['/google/bin/releases/grok/tools/kythe_languageserver', '--google3']},
      \ 'whitelist': ['python', 'go', 'java', 'cpp', 'proto', 'bzl'],
      \})
  nnoremap gd :<C-u>LspDefinition<CR>
  nnoremap ga :<C-u>LspReferences<CR>
  autocmd Filetype python nmap <buffer> gd :YcmCompleter GoTo<CR>
  " disable jedi features in google land
  let g:jedi#completions_enabled = 0
  let g:jedi#goto_command = ""
  let g:jedi#goto_assignments_command = ""
  let g:jedi#goto_definitions_command = ""
  let g:jedi#documentation_command = ""
  let g:jedi#usages_command = ""
  let g:jedi#completions_command = ""
  let g:jedi#rename_command = ""

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


  nnoremap <C-A-p> :CSearch 
  nnoremap <C-p> :Lines<CR>

  " auto-correct imports
  " trim trailing whitespace
  " collapse any excessive blank lines to a maximum of 2
  function Fiximports ()
    let save_cursor = getpos(".")
    silent %!/google/bin/releases/python-team/public/importorder --reformat_imports --filein %:p
    %s/\\s\\+$//e
    %s/\n\\{4,}/\\r\\r\\r/e
    call setpos('.', save_cursor)
  endfunction
  command Fiximports call Fiximports ()
  " Fiximports just before the buffer is written
  autocmd BufWritePost *.py call Fiximports ()

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


  " see https://yaqs.googleplex.com/eng/q/5883314352685056 for golang 8 width
  " tab issue
endif


