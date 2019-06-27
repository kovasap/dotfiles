" Author: Kovas Palunas <kovas@google.com>
" Description: Adds support for Google's internal tricorder MdLint

call ale#linter#Define('markdown', {
\   'name': 'gmdlint',
\   'executable': '/google/data/ro/teams/tricorder/tricorder',
\   'lint_file': 1,
\   'output_stream': 'stdout',
\   'command': '/google/data/ro/teams/tricorder/tricorder analyze -log_to_sponge=false -categories MdLint %s',
\   'callback': 'ale#handlers#gmdlint#Handle',
\})

