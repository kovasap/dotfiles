--                          /// Utilities ///

-- Taken from https://oroques.dev/notes/neovim-init
function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Debug print a lua datastructure
function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. tostring(k) .. '"' end
      s = s .. '[' .. tostring(k) .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

--                          /// Plugin Management ///

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.maplocalleader = " "

local plugins_spec = {
  { 'eandrju/cellular-automaton.nvim' },
  { 'yuttie/comfortable-motion.vim' },
  { 'ggvgc/vim-fuzzysearch' },
  { 'AndrewRadev/splitjoin.vim' },
  -- Automatically delete extra characters (like quotes) when joining lines.
  { 'flwyd/vim-conjoin' },
  -- Automatically set tabstop/shiftwidth based on current file or nearby files.
  { 'tpope/vim-sleuth' },
  -- Change cases using e.g. cru for upper case.
  { 'tpope/vim-abolish' },
  { 'kylechui/nvim-surround' },
  { 'tpope/vim-repeat' },
  { 'windwp/nvim-autopairs' },
  -- Automatically align code.
  { 'junegunn/vim-easy-align' },
  -- Highlight current word with cursor on it across whole buffer.
  { 'RRethy/vim-illuminate' },
  -- Animates window resizing.
  { 'camspiers/animate.vim' },
  { 'lukas-reineke/indent-blankline.nvim' },
  -- Add scrollbars.
  { 'dstein64/nvim-scrollview',           branch = 'main' },
  { 'vim-airline/vim-airline' },
  -- Persist settings between sessions
  { 'zhimsel/vim-stay' },
  -- Better directory browsing.  Access the directory the current file is in with
  -- the - key.
  { 'stevearc/oil.nvim' },
  { 'tpope/vim-eunuch' },
  -- Make it so that when a buffer is deleted, the window stays.
  { 'qpkorr/vim-bufkill' },
  { 'kana/vim-altr' },
  -- Open files at specified lines using file:line syntax.
  { 'wsdjeg/vim-fetch' },
  {
    'junegunn/fzf',
    build = function(plugin)
      vim.fn['fzf#install']()
    end
  },
  { 'junegunn/fzf.vim' },
  { 'pbogut/fzf-mru.vim' },
  { 'ludovicchabant/vim-lawrencium' },
  { 'mhinz/vim-signify' },
  { 'rafamadriz/friendly-snippets' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-emoji' },
  { 'hrsh7th/cmp-calc' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-nvim-lua' },
  { 'f3fora/cmp-spell' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'L3MON4D3/LuaSnip' },
  'saadparwaiz1/cmp_luasnip',
  { 'hrsh7th/nvim-cmp' },
  { 'nvim-treesitter/nvim-treesitter',            lazy = false,             branch = 'master', build = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'nvim-treesitter/nvim-treesitter-context' },
  { 'nvim-treesitter/playground' },
  { 'HiPhish/rainbow-delimiters.nvim' },
  { 'neovim/nvim-lspconfig',                      build = install_python_ls },
  { 'nvim-lua/lsp-status.nvim' },
  { 'mgedmin/python-imports.vim' },
  { 'Olical/conjure' },
  { 'gpanders/nvim-parinfer' },
  { 'mechatroner/rainbow_csv' },
  { 'masukomi/vim-markdown-folding' },
  { 'ron89/thesaurus_query.vim' },
  { 'tikhomirov/vim-glsl' },
  { 'dart-lang/dart-vim-plugin' },
  -- Attmpts to make vim better when reading terminal data from kitty
  -- TODO FIX
  { 'rkitover/vimpager' },
  { 'habamax/vim-godot' },
  { 'dhruvasagar/vim-table-mode' },
  { 'whonore/vim-sentencer' },
  { 'ruanyl/vim-gh-line' },
  { 'folke/flash.nvim' },
  { 'ggandor/leap.nvim' },
  { 'guns/vim-sexp' },
  { 'romainl/vim-cool' },
  { 'echasnovski/mini.nvim' },
  { "MunifTanjim/nui.nvim" },
  { "m4xshen/hardtime.nvim" },
  { 'nvim-lua/plenary.nvim' },
  {
    "cksidharthan/mentor.nvim",
    opts = {
      tips = {
        "Use :Inspect with cursor above text to see why it is colored the way it is."
      }
    }
  },
  {
    'rachartier/tiny-glimmer.nvim',
    config = true
  },
  {
    'gen740/SmoothCursor.nvim',
    opts = {
      cursor = ">",
      linehl = "CursorLine",
      texthl = "CursorLine"
    }
  },
  {
    'google/vim-codefmt',
    dependencies = {
      { 'google/vim-maktaba' }
    }
  }
}

if vim.fn.filereadable(vim.fn.expand('~/google_dotfiles/google.lua')) ~= 0 then
  require('google_dotfiles/google').add_google_plugins(plugins_spec);
else
  table.insert(plugins_spec, {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = function()
      -- conditionally use the correct build system for the current OS
      if vim.fn.has("win32") == 1 then
        return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      else
        return "make"
      end
    end,
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      -- "stevearc/dressing.nvim",      -- for input provider dressing
      -- "folke/snacks.nvim",           -- for input provider snacks
      -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua",      -- for providers='copilot'
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  })
end

-- Setup lazy.nvim
require("lazy").setup({
  spec = plugins_spec,
})

--                          /// General ///

require("hardtime").setup({
  restriction_mode = "hint",
  disable_mouse = false,
  disabled_keys = {
    ["<Up>"] = false,
    ["<Down>"] = false,
    ["<Left>"] = false,
    ["<Right>"] = false,
  }
})

--                          /// Right Click Menu ///

vim.cmd('nnoremenu PopUp.Rain <Cmd>CellularAutomaton make_it_rain<CR>')


--                          /// Navigation ///

vim.keymap.set({ 'n', 'x' }, '(', function()
  vim.fn.search("['\"\\[\\](){}<>]", 'bW')
end)
vim.keymap.set({ 'n', 'x' }, ')', function()
  vim.fn.search("['\"\\[\\](){}<>]", 'W')
end)

require('flash').setup({
  modes = {
    char = {
      search = { wrap = true },
      highlight = { backdrop = false },
    }
  }
})

require('leap').set_default_keymaps()
vim.keymap.set('n', 's', '<Plug>(leap)')
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
vim.keymap.set({ 'x', 'o' }, 's', '<Plug>(leap-forward)')
vim.keymap.set({ 'x', 'o' }, 'S', '<Plug>(leap-backward)')

-- Jump backwards
vim.keymap.set('n', '<C-p>', function()
  -- require 'whatthejump'.show_jumps(false)
  return '<C-o>'
end, { expr = true })

-- Jump forwards
vim.keymap.set('n', '<C-d>', function()
  -- require 'whatthejump'.show_jumps(true)
  return '<C-i>'
end, { expr = true })

-- Nicer up/down movement on long lines.
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- Smooth scrolling
vim.g.comfortable_motion_no_default_key_mappings = true
map('n', '<PageDown>', ':call comfortable_motion#flick(50)<CR>10j', { silent = true })
map('n', '<PageUp>', ':call comfortable_motion#flick(-50)<CR>10k', { silent = true })
map('v', '<PageDown>', '10jzz', { silent = true })
map('v', '<PageUp>', '10kzz', { silent = true })

-- Hit escape twice to clear old search highlighting.  vim-cool kinda makes
-- this obselete.
map('n', '<Esc><Esc>', ':let @/=""<CR>', { silent = true })
vim.g.CoolTotalMatches = true


--                          /// Editing and Formatting ///

-- Use "gm" to duplicate lines (faster than copy/pasting).
require('mini.operators').setup({})

-- Rename word and prime to replace other occurances
-- Can also search for something then use 'cgn' to "change next searched occurance".
map('v', '//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])
map('n', '<localleader>t', '*Ncw<C-r>"')
map('n', '<localleader>p', '*Ncw')

-- Make U redo
map('n', 'U', '<C-r>')

-- Rename word across file
map('n', '<localleader>d', ':%s/\\<<C-r><C-w>\\>/')

-- Transform single line code blocks to multi-line ones and vice-versa.
vim.g.splitjoin_split_mapping = ''
vim.g.splitjoin_join_mapping = ''
map('n', 'SJ', ':SplitjoinJoin<cr>')
map('n', 'SS', ':SplitjoinSplit<cr>')

-- Delete until the next 'closing' character (quote or brace)
map('n', "d'", 'd/[\\]\\}\\)\'"]<CR>:let @/ = ""<CR>')

-- Keep visual selection when indenting or dedenting.
-- https://superuser.com/questions/310417/how-to-keep-in-visual-mode-after-identing-by-shift-in-vim
map('v', '<', '<gv')
map('v', '>', '>gv')

-- False to play nicely with parinfer, see
-- https://github.com/eraserhd/parinfer-rust/issues/136
vim.wo.linebreak = false
vim.o.textwidth = 79
vim.bo.wrapmargin = 0
vim.bo.formatoptions = 'jcroql'

-- Make new lines indent automatically.
vim.bo.autoindent = true

-- Reformat paragraphs when typing anywhere in them (not just when adding to
-- their end).
-- vim.cmd("command AutoWrapToggle if &fo =~ 'a' | set fo-=a | else | set fo+=a | endif")
-- map('n', '<C-a>', ':AutoWrapToggle<CR>')

-- Note that this command imports all ftplugin files, which may have unindended
-- effects.
vim.cmd('filetype plugin indent on')

-- Make tabs create 2 spaces by default. Note that this is overwritten by
-- vim-sleuth and ftplugin files.
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Command to trim all trailing whitespace in the file.
vim.cmd(
  [[
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction
command! TrimWhitespace call TrimWhitespace()
]]
)

-- Repeatable hotkeys to surround text objects with quotes/parens/etc.
require("nvim-surround").setup({
  keymaps = { -- vim-surround style keymaps
    visual = "F",
  },
})

-- Automatically close parens.
-- local npairs = require('nvim-autopairs')
-- npairs.setup({
--   disable_filetype = { "TelescopePrompt" , "clojure" },
-- })

--                          /// Visuals ///

require('illuminate').configure()

-- Show tabs as actual characters.
vim.wo.list = true
vim.wo.listchars = 'tab:>-'

-- My custom colorscheme defined in ~/.vim/colors.
vim.cmd('colorscheme terminal')
vim.o.termguicolors = false
vim.o.background = 'dark'

-- Function to determine the highlight group under the cursor (to help change
-- its color).
vim.cmd(
  [[
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
command! SynGroup call SynGroup()
]]
)

-- Highlights the line the cursor is currently on.
vim.wo.cursorline = true

-- Creates a line to show the max desired line length.
vim.wo.colorcolumn = '+1'

-- Makes vim faster when making new lines after long lines by preventing syntax
-- highlighting after a certain width.
vim.o.synmaxcol = 2000

-- Show relative line numbers on left side of buffer.
vim.wo.number = true
vim.wo.relativenumber = true

-- Adds indentation line hints.
require('ibl').setup {
  indent = { char = "¦" },
}

-- Syntax highlighting for specific filetypes
vim.cmd(
  [[
au BufRead,BufNewFile *.blueprint set filetype=gcl
]]
)


--                          /// User Interface ///

-- Allow mouse usage in the terminal.
vim.o.mouse = 'a'

-- Set title of (e.g. X11) window vim is in.  See :h statusline for info about
-- how to customize this.
vim.o.title = true
vim.o.titlestring = "%t (%{expand('%:~:.:h')}) - NVIM"

-- Add bottom bar with various info.
-- Uncomment to get top bar with all buffer names.
-- let g:airline#extensions#tabline#enabled = 1
-- Last section determines the max width for different parts of the bottom bar.
-- See https://github.com/vim-airline/vim-airline/issues/694 for some
-- explanation.
vim.cmd(
  [[
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#displayed_head_limit = 15
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#default#section_truncate_width = { 'a': 40, 'b': 40, 'c': 50, 'x': 110, 'y': 110, 'z': 110, }
]]
)

-- Theme located in ~/.vim/autoload/airline/themes/terminal.vim.
vim.g.airline_theme = 'terminal'
-- Use :help statusline for customization options here.
vim.g.airline_section_c = '%f%m'
-- Remove the last bottom bar section.
vim.g.airline_section_z = ''

-- Use the system clipboard for everything by default. See
-- https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim.
vim.o.clipboard = 'unnamedplus'
-- Copy filename of current buffer to clipboard
map('n', 'yf', ':let @+ = expand("%:p")<CR>')
-- Copy filename of current buffer in relref format to clipboard (to make
-- personal website writing easier).
-- TODO add this to a local vimrc file in the website directory, once I find a
-- clean way to do that.
map('n', 'yl',
  ':let @+ = \'{{< relref "\' .. substitute(expand("%:p"), "/home/kovas/website/content", "", "") .. \'\" >}}\'<CR>')

-- stay/view will annoyingly remember to change working dirs when opening files
-- sometimes, this should prevent that
vim.o.autochdir = false

-- For some unknown reason, on some machines the oil config gets overwritten by
-- a startup script.  So I load it last here with a VimEnter autocommand to
-- make sure this is the config I end up with.
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    require("oil").setup({
      default_file_explorer = true,
      prompt_save_on_select_new_entry = false,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["<CR>"] = "actions.select",
        ["<C-l>"] = "actions.refresh",
        ["g?"] = "actions.show_help",
        -- These conflict with my custom mappings for all buffer types
        ["<C-p>"] = false,
        ["<C-s>"] = false,
      },
      use_default_keymaps = false,
    })
  end,
})
vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })

map('n', 'm', ':wincmd W<CR>')
map('n', 'M', ':wincmd w<CR>')

-- "Chrome-like" mappings

map('n', '<C-l>', ':')

-- Make vertical split with ctrl-t, moving the next split.
map('n', '<C-t>', ':vsplit | wincmd w<CR>')

-- Gets number of windows that are not floating (actually show buffer contents).
local function get_num_windows()
  local count = 0
  -- print(dump(vim.api.nvim_tabpage_list_wins(0)))
  for _, winnr in pairs(vim.api.nvim_list_wins()) do
    local cfg = vim.api.nvim_win_get_config(winnr)
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
    if cfg.focusable then
      -- print(dump(cfg))
      -- print(ft)
      -- print(vim.api.nvim_buf_get_name(bufnr))
      count = count + 1
    end
  end
  return count
end

-- When this is equal to 1, then some extra C-w bindings are created that make
-- my custom C-w slow. See
-- https://github.com/dstein64/nvim-scrollview/blob/d03d1e305306b8b6927d63182384be0831fa3831/plugin/scrollview.vim#L164.
vim.g.scrollview_auto_workarounds = 0

-- Close windows, then the whole session, with C-w
vim.keymap.set("n", "<C-w>", function()
    local win_amount = get_num_windows()
    if win_amount == 1 then
      vim.cmd(':wqa<CR>')
    else
      vim.cmd('wincmd q')
    end
  end,
  {
    noremap = true,
    nowait = true
  })

-- Do this automatically when the vim window is resized.
vim.cmd('autocmd VimResized * wincmd =')


--                          /// Buffers and Files ///

-- Switch between buffers without saving.
vim.o.hidden = true

-- Do not automatically reload files if working on Google code, otherwise read
-- files automatically if they change.
if not_in_google3 then
  vim.o.autoread = true
  -- Trigger `autoread` when files changes on disk
  -- https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
  -- https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
  vim.cmd('autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if !bufexists("[Command Line]") | checktime | endif')
  -- Notification after file change
  -- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
  vim.cmd(
    'autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')
else
  vim.o.autoread = false
end

-- Switch between h/cc files (and other related files) with alt-shift-h/l.
map('n', '<A-L>', '<Plug>(altr-forward)')
map('n', '<A-H>', '<Plug>(altr-back)')

-- Goes to current filename string in the current directory's BUILD file.
map('n', 'gb', ":execute 'e +/' . escape(escape(expand('%:t'), '.'), '.') . ' %:h/BUILD'<CR>")

-- Create directories on write if they don't already exist.
-- See also https://github.com/pbrisbin/vim-mkdir
vim.cmd(
  [[
function g:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call g:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
]]
)

-- Save all buffers with ctrl-s.
map('n', '<C-S>', ':wa<CR>')


--                          /// Searching ///

-- map('n', '<space>', ':FuzzySearch<CR>')

vim.g.fzf_history_dir = '~/.local/share/fzf-history'

-- Search in files starting from directory with current buffer and working way
-- up with a maximum of 100 files using the , key.
-- vim.cmd(
-- [[
-- let g:types = { 'dict': type({}), 'funcref': type(function('call')), 'string': type(''), 'list': type([]) }
-- function! g:Warn(message)
--   echohl WarningMsg
--   echom a:message
--   echohl None
--   return 0
-- endfunction
-- function! g:Myag(query, ...)
--   if type(a:query) != g:types.string
--     return g:Warn('Invalid query argument')
--   endif
--   let query = empty(a:query) ? '^(?=.)' : a:query
--   let args = copy(a:000)
--   let ag_opts = len(args) > 1 && type(args[0]) == g:types.string ? remove(args, 0) : ''
--   let command = ag_opts . ' ' . fzf#shellescape(query) . ' ' .
--         \ printf('$(find_up.bash %s -type f | head -n 100)',
--         \        expand('%:h'))
--   return call('fzf#vim#ag_raw', insert(args, command, 0))
-- endfunction
-- command! -bang -nargs=* MyAg call g:Myag(<q-args>, <bang>0)
-- ]]
-- )
-- map('n', ',', ':MyAg ')

-- Search through all files in the current buffer's directory with " when in a
-- oil directory buffer.
vim.cmd(
  [[
function! g:Dirag(query, ...)
  if type(a:query) != type('')
    return g:Warn('Invalid query argument')
  endif
  let query = empty(a:query) ? '^(?=.)' : a:query
  let args = copy(a:000)
  let ag_opts = len(args) > 1 && type(args[0]) == type('') ? remove(args, 0) : ''
  let directory = substitute(expand('%:h'), 'oil:\/\/', '', '')
  let command = ag_opts . ' -a ' . fzf#shellescape(query) . ' ' . directory
  return call('fzf#vim#ag_raw', insert(args, command, 0))
endfunction
command! -bang -nargs=* DirAg call g:Dirag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
autocmd FileType oil nnoremap <buffer> ? :DirAg<CR>
]]
)

-- Search in all buffer lines.
map('n', '?', ':Lines<CR>')

-- Search through most recently used files with the ' key.
vim.g.fzf_mru_max = 1000000
-- This is used instead of 'google3' because when fig uses vimdiff it puts the
-- vim instance at the root of the CitC client (the dir _containing_ google3).
vim.g.fzf_mru_store_relative_dirs = { '/google/src/cloud/' }
-- Exclude files with google3/ in them - these will be opened only when things are
-- merged via vimdiff.
vim.g.fzf_mru_exclude = '/tmp/\\|google3/'
-- Make a separate function here to avoid the "press enter to continue" prompts
-- vim uses when the command line exceeds the size of the command window.  The
-- separate function does not show the FZFMru command in the window.
vim.api.nvim_create_user_command('MRU', function()
    vim.cmd ":FZFMru -m -x --no-sort --tiebreak=index --nth=-1 --delimiter=/ --preview 'batcat --color=always --style=plain --theme=base16 {}'"
  end,
  { nargs = 0, desc = 'Find most recently used files.' }
)
map('n', "'", ":MRU<CR>")
-- The '10000 part of this will make it so that 1000 oldfiles are remembered (the
-- last 10000 files will be available with the FZFMru command)
vim.o.shada = "!,'10000,<50,s10,h"


--                          /// Version Control ///

vim.g.signify_realtime = true
vim.g.signify_cursorhold_insert = false
vim.g.signify_cursorhold_normal = false
-- Go back and forth in history with ]r or [r.
-- taken from https://github.com/mhinz/vim-signify/issues/284
vim.g.target_commit = 0
vim.cmd(
  [[
function ChangeTargetCommit(older_or_younger)
  if a:older_or_younger ==# 'older'
    let g:target_commit += 1
  elseif g:target_commit==#0
    echom 'No timetravel! Cannot diff against HEAD~-1'
    return
  else
    let g:target_commit -= 1
  endif
  let g:signify_vcs_cmds.git = printf('%s%d%s', 'git diff --no-color --no-ext-diff -U0 HEAD~', g:target_commit, ' -- %f')
  let g:signify_vcs_cmds.hg = printf('%s%d%s', 'hg diff --config extensions.color=! --config defaults.diff= --nodates -U0 --rev .~', g:target_commit, ' -- %f')
  let g:signify_vcs_cmds_diffmode.hg = printf('%s%d %s', 'hg cat --rev .~', g:target_commit, '%f')
  let l:cur_rev_cmd = printf('hg log --rev .~%d --template ''{node|short} {fill(desc, "50")|firstline}\n''', g:target_commit)
  let l:cur_rev = system(l:cur_rev_cmd)
  let l:output_msg = printf('%s%d %s', 'Now diffing against HEAD~', g:target_commit, l:cur_rev)
  echom l:output_msg
  :SignifyRefresh
endfunction
]]
)
vim.cmd("command! SignifyOlder call ChangeTargetCommit('older')")
vim.cmd("command! SignifyNewer call ChangeTargetCommit('younger')")
map('n', ']r', ':SignifyOlder<CR>')
map('n', '[r', ':SignifyNewer<CR>')

-- TODO Add this for git too.
vim.cmd(
  [[
function HgDiffTarget()
  let l:cur_rev_cmd = printf('hg log --rev .~%d --template ''{node}''', g:target_commit)
  let l:cur_rev = system(l:cur_rev_cmd)
  execute 'Hgvdiff' l:cur_rev
endfunction
command! HgDiffTargetCmd call HgDiffTarget()
]]
)


--                          /// Diffing ///

-- Make obtain/put commands in diff mode auto jump to the next change.
map('n', 'do', 'do]c')
map('n', 'dp', 'dp]c')

-- Get diff between current buffer and what is saved to disk using the
-- DiffSaved command.
vim.cmd(
  [[
function! g:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call g:DiffWithSaved()
]]
)


--                          /// Completion and Snippets ///

-- Setup Gemini
-- if not_in_google3 then
-- local gemini_api = require('gemini.api')
-- require('gemini').setup({
--   model_config = {
--     completion_delay = 1000,
--     model_id = gemini_api.MODELS.GEMINI_2_0_FLASH,
--     temperature = 0.2,
--     top_k = 20,
--     max_output_tokens = 8196,
--     response_mime_type = 'text/plain',
--   },
--   chat_config = {
--     enabled = true,
--   },
--   hints = {
--     enabled = true,
--     hints_delay = 2000,
--     insert_result_key = '<C-e>',
--     get_prompt = function(node, bufnr)
--       local code_block = vim.treesitter.get_node_text(node, bufnr)
--       local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
--       local prompt = [[
--   Instruction: Use 1 or 2 sentences to describe what the following {filetype} function does:
--
--   ```{filetype}
--   {code_block}
--   ```]]
--       prompt = prompt.gsub('{filetype}', filetype)
--       prompt = prompt.gsub('{code_block}', code_block)
--       return prompt
--     end
--   },
--   completion = {
--     enabled = true,
--     blacklist_filetypes = { 'help', 'qf', 'json', 'yaml', 'toml' },
--     blacklist_filenames = { '.env' },
--     completion_delay = 600,
--     move_cursor_end = false,
--     insert_result_key = '<C-e>',
--     get_system_text = function()
--       return "You are a coding AI assistant that autocomplete user's code at a specific cursor location marked by <insert_here></insert_here>."
--         .. '\nDo not wrap the code in ```'
--     end,
--     get_prompt = function(bufnr, pos)
--       local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
--       local prompt = 'Below is a %s file:\n'
--           .. '```%s\n%s\n```\n\n'
--           .. 'Instruction:\nWhat code should be place at <insert_here></insert_here>?\n'
--       local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
--       local line = pos[1]
--       local col = pos[2]
--       local target_line = lines[line]
--       if target_line then
--         lines[line] = target_line:sub(1, col) .. '<insert_here></insert_here>' .. target_line:sub(col + 1)
--       else
--         return nil
--       end
--       local code = vim.fn.join(lines, '\n')
--       prompt = string.format(prompt, filetype, filetype, code)
--       return prompt
--     end
--   },
--   instruction = {
--     enabled = true,
--     menu_key = '<C-o>',
--     prompts = {
--       {
--         name = 'Unit Test',
--         command_name = 'GeminiUnitTest',
--         menu = 'Unit Test 🚀',
--         get_prompt = function(lines, bufnr)
--           local code = vim.fn.join(lines, '\n')
--           local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
--           local prompt = 'Context:\n\n```%s\n%s\n```\n\n'
--               .. 'Objective: Write unit test for the above snippet of code\n'
--           return string.format(prompt, filetype, code)
--         end,
--       },
--       {
--         name = 'Code Review',
--         command_name = 'GeminiCodeReview',
--         menu = 'Code Review 📜',
--         get_prompt = function(lines, bufnr)
--           local code = vim.fn.join(lines, '\n')
--           local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
--           local prompt = 'Context:\n\n```%s\n%s\n```\n\n'
--               .. 'Objective: Do a thorough code review for the following code.\n'
--               .. 'Provide detail explaination and sincere comments.\n'
--           return string.format(prompt, filetype, code)
--         end,
--       },
--       {
--         name = 'Code Explain',
--         command_name = 'GeminiCodeExplain',
--         menu = 'Code Explain',
--         get_prompt = function(lines, bufnr)
--           local code = vim.fn.join(lines, '\n')
--           local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
--           local prompt = 'Context:\n\n```%s\n%s\n```\n\n'
--               .. 'Objective: Explain the following code.\n'
--               .. 'Provide detail explaination and sincere comments.\n'
--           return string.format(prompt, filetype, code)
--         end,
--       },
--     },
--   },
--   task = {
--     enabled = true,
--     get_system_text = function()
--       return 'You are an AI assistant that helps user write code.\n'
--         .. 'Your output should be a code diff for git.'
--     end,
--     get_prompt = function(bufnr, user_prompt)
--       local buffers = vim.api.nvim_list_bufs()
--       local file_contents = {}
--
--       for _, b in ipairs(buffers) do
--         if vim.api.nvim_buf_is_loaded(b) then -- Only get content from loaded buffers
--           local lines = vim.api.nvim_buf_get_lines(b, 0, -1, false)
--           local filename = vim.api.nvim_buf_get_name(b)
--           filename = vim.fn.fnamemodify(filename, ":.")
--           local filetype = vim.api.nvim_get_option_value('filetype', { buf = b })
--           local file_content = table.concat(lines, "\n")
--           file_content = string.format("`%s`:\n\n```%s\n%s\n```\n\n", filename, filetype, file_content)
--           table.insert(file_contents, file_content)
--         end
--       end
--
--       local current_filepath = vim.api.nvim_buf_get_name(bufnr)
--       current_filepath = vim.fn.fnamemodify(current_filepath, ":.")
--
--       local context = table.concat(file_contents, "\n\n")
--       return string.format('%s\n\nCurrent Opened File: %s\n\nTask: %s',
--         context, current_filepath, user_prompt)
--     end
--   },
-- })
-- end

-- Setup copilot.
-- vim.g.copilot_workspace_folders = {'~/'}
-- vim.g.copilot_no_tab_map = true
-- vim.keymap.set('i', '<C-e>', 'copilot#Accept("\\<CR>")', {
--   expr = true,
--   replace_keycodes = false
-- })

-- Setup nvim-cmp.
local cmp = require 'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local source_names = {
  nvim_lsp = "(LSP)",
  emoji = "(Emoji)",
  path = "(Path)",
  calc = "(Calc)",
  cmp_tabnine = "(Tabnine)",
  luasnip = "(Snippet)",
  buffer = "(Buffer)",
  tmux = "(TMUX)",
  nvim_ciderlsp = "(ML-Autocompletion!)"
}

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()

-- require('cmp_ai.config'):setup({
--   max_lines = 5,
--   provider = 'Ollama',
--   provider_options = {
--     model = 'qwen2.5-coder:7b-base-q4_K_M',
--     prompt = function(lines_before, lines_after)
--       return "<|fim_prefix|>" .. lines_before .. "<|fim_suffix|>" .. lines_after .. "<|fim_middle|>"
--     end,
--     auto_unload = false
--   },
--   notify = true,
--   notify_callback = function(msg)
--     vim.notify(msg)
--   end,
--   run_on_every_keystroke = true,
--   ignored_file_types = {
--   },
-- })

local compare = require('cmp.config.compare')

cmp.setup({
  sorting = {
    priority_weight = 2,
    comparators = {
      -- require('cmp_ai.compare'),
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    -- From https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s", "c" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s", "c" }),

  },
  sources = {
    { name = 'nvim_ciderlsp', priority = 1000 },
    { name = 'nvim_lsp',      priority = 500 },
    { name = 'luasnip',       priority = 500 },
    { name = 'emoji',         priority = 500 },
    { name = 'calc',          priority = 500 },
    { name = 'spell',         priority = 500 },
    { name = 'path',          priority = 500 },
    { name = 'nvim_lua',      priority = 500 },
    -- { name = 'cmp_ai', priority = 500 },
    {
      name = 'buffer',
      option = {
        -- Complete from all open buffers, not just the current one.
        -- https://github.com/hrsh7th/cmp-buffer/issues/1.
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      },
    },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      vim_item.kind = vim_item.kind
      vim_item.menu = source_names[entry.source.name]
      -- vim_item.dup = duplicates[entry.source.name]
      return vim_item
    end
  },
})

cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } })
})


map('i', '<C-l>', '<plug>(fzf-complete-line)')


--                          /// Language - General ///

-- require('dim').setup({})

vim.cmd [[
  command! TSHighlightCapturesUnderCursor :lua require'nvim-treesitter-playground.hl-info'.show_hl_captures()<cr>
]]

-- Adds multicolored parenthesis to make it easier to see how they match up.
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'python', 'clojure', 'luadoc', 'lua', 'markdown', 'vim', 'vimdoc', 'sql' },
  highlight = { enable = true },
  -- TODO Re-enable when this works better for python.
  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1136 might be
  -- related
  -- indent = {enable = true},
  rainbow = {
    enable = true,
    extended_mode = true,  -- Highlight also non-parentheses delimiters
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines
    termcolors = { '3', '4', '1', '3', '4', '1', '3', '4' }
  },
  textobjects = {
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["gi"] = "@function.outer",
        ["gI"] = "@class.outer",
      },
    },
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

require 'treesitter-context'.setup {
  enable = true,           -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0,           -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,   -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 2, -- Maximum number of lines to show for a single context
  trim_scope = 'outer',    -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',         -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20,     -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

local hl = function(group, opts)
  opts.default = true
  vim.api.nvim_set_hl(0, group, opts)
end

-- Misc {{{
hl('@comment', { link = 'Comment' })
-- hl('@error', {link = 'Error'})
hl('@none', { bg = 'NONE', fg = 'NONE' })
hl('@preproc', { link = 'PreProc' })
hl('@define', { link = 'Define' })
hl('@operator', { link = 'Operator' })
-- }}}

-- Punctuation {{{
hl('@punctuation.delimiter', { link = 'Delimiter' })
hl('@punctuation.bracket', { link = 'Delimiter' })
hl('@punctuation.special', { link = 'Delimiter' })
-- }}}

-- Literals {{{
hl('@string', { link = 'String' })
hl('@string.regex', { link = 'String' })
hl('@string.escape', { link = 'SpecialChar' })
hl('@string.special', { link = 'SpecialChar' })

hl('@character', { link = 'Character' })
hl('@character.special', { link = 'SpecialChar' })

hl('@boolean', { link = 'Boolean' })
hl('@number', { link = 'Number' })
hl('@float', { link = 'Float' })
-- }}}

-- Functions {{{
hl('@function', { link = 'Function' })
hl('@function.call', { link = 'Function' })
hl('@function.builtin', { link = 'Special' })
hl('@function.macro', { link = 'Macro' })

hl('@method', { link = 'Function' })
hl('@method.call', { link = 'Function' })

hl('@constructor', { link = 'Function' })
hl('@parameter', { link = 'Identifier' })
-- }}}

-- Keywords {{{
hl('@keyword', { link = 'Keyword' })
hl('@keyword.function', { link = 'Keyword' })
hl('@keyword.operator', { link = 'Keyword' })
hl('@keyword.return', { link = 'Keyword' })

hl('@conditional', { link = 'Conditional' })
hl('@repeat', { link = 'Repeat' })
hl('@debug', { link = 'Debug' })
hl('@label', { link = 'Label' })
hl('@include', { link = 'Include' })
hl('@exception', { link = 'Exception' })
-- }}}

-- Types {{{
hl('@type', { link = 'Type' })
hl('@type.builtin', { link = 'Type' })
hl('@type.qualifier', { link = 'Type' })
hl('@type.definition', { link = 'Typedef' })

hl('@storageclass', { link = 'StorageClass' })
hl('@attribute', { link = 'PreProc' })
hl('@field', { link = 'Normal' })
hl('@property', { link = 'Identifier' })
-- }}}

-- Identifiers {{{
hl('@variable', { link = 'Normal' })
hl('@variable.builtin', { link = 'Normal' })

hl('@constant', { link = 'Constant' })
hl('@constant.builtin', { link = 'Special' })
hl('@constant.macro', { link = 'Define' })

hl('@namespace', { link = 'Include' })
hl('@symbol', { link = 'Identifier' })
-- }}}

-- Text {{{
hl('@text', { link = 'Normal' })
hl('@text.strong', { bold = true })
hl('@text.emphasis', { italic = true })
hl('@text.underline', { underline = true })
hl('@text.strike', { strikethrough = true })
hl('@text.title', { link = 'Title' })
hl('@text.literal', { link = 'String' })
hl('@text.uri', { link = 'Underlined' })
hl('@text.math', { link = 'Special' })
hl('@text.environment', { link = 'Macro' })
hl('@text.environment.name', { link = 'Type' })
hl('@text.reference', { link = 'Constant' })

hl('@text.todo', { link = 'Todo' })
hl('@text.note', { link = 'SpecialComment' })
hl('@text.warning', { link = 'WarningMsg' })
hl('@text.danger', { link = 'ErrorMsg' })
-- }}}

-- Tags {{{
hl('@tag', { link = 'Tag' })
hl('@tag.attribute', { link = 'Identifier' })
hl('@tag.delimiter', { link = 'Delimiter' })
-- }}}

-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.cmd('set foldmethod=expr')
vim.cmd('set foldexpr=nvim_treesitter#foldexpr()')
vim.cmd('set foldlevelstart=99')

local function install_python_ls()
  vim.cmd('!pip install python-language-server[all] yapf')
end
local nvim_lsp = require('lspconfig')

vim.api.nvim_set_keymap('n', '<localleader>f', [[:execute "norm! vip:FormatLines\<lt>CR>"<CR>]], { noremap = true })

-- execute an lsp command at given position allowing extra arguments
function execute_at(command_name, file_uri, cursor, ...)
  local row, col = unpack(cursor)
  vim.lsp.buf.execute_command {
    command = command_name,
    arguments = { file_uri, row - 1, col, ... }
  }
end

-- delegate command execution as a callback function receiving user input
function execute_with_input(command_name, file_uri, cursor)
  return function(user_input)
    execute_at(command_name, file_uri, cursor, user_input)
  end
end

-- capture buffer location before running lsp command,
-- to enable async execution when user input is required
function with_current_position(runnable)
  return function()
    local file_uri = 'file://' .. vim.fn.expand('%:p')
    local cursor = vim.api.nvim_win_get_cursor(0)
    runnable(file_uri, cursor)
  end
end

-- create a callback that immediately executes an lsp command
function run_immediately(command_name, ...)
  local extra_args = { ... }
  return with_current_position(function(file_uri, cursor)
    execute_at(command_name, file_uri, cursor, unpack(extra_args))
  end)
end

-- create a callback that reads user input and feeds to an lsp command
function run_with_input(command_name, opts)
  return with_current_position(function(file_uri, cursor)
    vim.ui.input(opts, execute_with_input(command_name, file_uri, cursor))
  end)
end

-- create a callback that prompts user to select data from a list
-- feeds the selection to an lsp command
function run_with_select(command_name, opts, select_options)
  return with_current_position(function(file_uri, cursor)
    vim.ui.select(select_options, opts, execute_with_input(command_name, file_uri, cursor))
  end)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  if vim.lsp.formatexpr then -- Neovim v0.6.0+ only.
    buf_set_option("formatexpr", "v:lua.vim.lsp.formatexpr")
  end

  -- Mappings.
  -- local opts = { noremap=true, silent=true }
  local opts = { noremap = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'tT', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'tt', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'cd', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- buf_set_keymap('n', 'ge', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', 'gE', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', 'ge', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  -- Do not use lsp formatting for languages that I would rather use codefmt
  -- with via the above FormatLines binding.
  if filetype ~= 'clojure' then
    buf_set_keymap('n', '<localleader>f', [[:execute "norm! vip:lua vim.lsp.buf.format()\<lt>CR>"<CR>]], opts)
    buf_set_keymap('v', '<localleader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
  else
    -- Copied from https://github.com/thegards/dotfiles/blob/76ed05d61039ff657e7ece5ba59d916f551f19ec/neovim/nvimdir/after/ftplugin/clojure.lua
    vim.keymap.set('n', 'cred', run_with_input("extract-to-def", { prompt = "def name:" }), opts)
    vim.keymap.set("n", "crai", run_immediately("add-missing-import"), { desc = "Add import to namespace" })
    vim.keymap.set("n", "cram", run_immediately("add-missing-libspec"), { desc = "Add missing require" })
    vim.keymap.set("n", "cras", run_immediately("add-require-suggestion"), { desc = "Add require suggestion" })
    vim.keymap.set("n", "crcc", run_immediately("cycle-coll"), { desc = "Cycle collection (#{}, {}, [], ())" })
    vim.keymap.set("n", "crck", run_immediately("cycle-keyword-auto-resolve"), { desc = "Cycle keyword auto-resolve" })
    vim.keymap.set("n", "crcn", run_immediately("clean-ns"), { desc = "Clean namespace" })
    vim.keymap.set("n", "crcp", run_immediately("cycle-privacy"), { desc = "Cycle privacy of def/defn" })
    vim.keymap.set("n", "crct", run_immediately("create-test"), { desc = "Create test" })
    vim.keymap.set("n", "crdf", run_immediately("demote-fn"), { desc = "Demote fn to #()" })
    --vim.keymap.set("n", "crdb", run_immediately("drag-backward"), { desc = "Drag backward" })
    --vim.keymap.set("n", "crdf", run_immediately("drag-forward"), { desc = "Drag forward" })
    vim.keymap.set("n", "crdk", run_immediately("destructure-keys"), { desc = "Destructure keys" })
    vim.keymap.set("n", "cred", run_with_input("extract-to-def", { prompt = "def name:" }), { desc = "Extract to def" })
    vim.keymap.set("n", "cref", run_with_input("extract-function", { prompt = "Function name:" }), { desc = "Extract function" })
    vim.keymap.set("n", "crel", run_immediately("expand-let"), { desc = "Expand let" })
    vim.keymap.set("n", "crfe", run_immediately("create-function"), { desc = "Create function from example" })
    vim.keymap.set("n", "crga", run_immediately("get-in-all"), { desc = "Move all expressions to get/get-in" })
    vim.keymap.set("n", "crgl", run_immediately("get-in-less"), { desc = "Remove one element from get/get-in" })
    vim.keymap.set("n", "crgm", run_immediately("get-in-more"), { desc = "Move another expression to get/get-in" })
    vim.keymap.set("n", "crgn", run_immediately("get-in-none"), { desc = "Unwind whole get/get-in" })
    vim.keymap.set("n", "cril", run_with_input("introduce-let", { prompt = "Binding name:" }), { desc = "Introduce let" })
    vim.keymap.set("n", "cris", run_immediately("inline-symbol"), { desc = "Inline Symbol" })
    vim.keymap.set("n", "crma", run_immediately("resolve-macro-as"), { desc = "Resolve macro as" })
    vim.keymap.set("n", "crmf", run_with_input("move-form", { prompt = "Filename:" }), { desc = "Move form" })
    vim.keymap.set("n", "crml", run_with_input("move-to-let", { prompt = "Binding name:" }), { desc = "Move expression to let" })
    vim.keymap.set("n", "crpf", run_with_input("promote-fn", { prompt = "Function name:" }), { desc = "Promote #() to fn, or fn to defn" })
    vim.keymap.set("n", "crrr", run_immediately("replace-refer-all-with-refer"), { desc = "Replace ':refer :all' with ':refer [...]'" })
    vim.keymap.set("n", "crra", run_immediately("replace-refer-all-with-alias"), { desc = "Replace ':refer :all' with alias" })
    vim.keymap.set("n", "crrk", run_immediately("restructure-keys"), { desc = "Restructure keys" })
    vim.keymap.set("n", "crscc", run_with_select("change-coll", { prompt = "New type:" }, { "map", "list", "set", "vector" }), { desc = "Switch collection to {}, (), #{}, []" })
    vim.keymap.set("n", "crscm", run_immediately("change-coll", "map"), { desc = "Switch collection to {}" })
    vim.keymap.set("n", "crscv", run_immediately("change-coll", "vector"), { desc = "Switch collection to []" })
    vim.keymap.set("n", "crscl", run_immediately("change-coll", "list"), { desc = "Switch collection to ()" })
    vim.keymap.set("n", "crsl", run_immediately("sort-clauses"), { desc = "Sort map/vector/list/set/clauses" })
    vim.keymap.set("n", "crtf", run_immediately("thread-first-all"), { desc = "Thread first all" })
    vim.keymap.set("n", "crth", run_immediately("thread-first"), { desc = "Thread first expression" })
    vim.keymap.set("n", "crtl", run_immediately("thread-last-all"), { desc = "Thread last all" })
    vim.keymap.set("n", "crtt", run_immediately("thread-last"), { desc = "Thread last expression" })
    vim.keymap.set("n", "crua", run_immediately("unwind-all"), { desc = "Unwind whole thread" })
    vim.keymap.set("n", "cruw", run_immediately("unwind-thread"), { desc = "Unwind thread once" })
    --vim.keymap.set("n", "crfs", run_immediately("forward-slurp"), { desc = "Paredit: forward slurp" })
    --vim.keymap.set("n", "crfb", run_immediately("forward-barf"), { desc = "Paredit: forward barf" })
    --vim.keymap.set("n", "crbs", run_immediately("backward-slurp"), { desc = "Paredit: backward slurp" })
    --vim.keymap.set("n", "crbb", run_immediately("backward-barf"), { desc = "Paredit: backward barf" })
  end
end

-- close quickfix menu after selecting choice
vim.api.nvim_create_autocmd(
  "FileType", {
    pattern = { "qf" },
    command = [[nnoremap <buffer> <CR> <CR>:cclose<CR>]]
  })

--                          /// Language - Lua ///

nvim_lsp.lua_ls.setup {
  on_attach = on_attach
}

pcall(function()
  vim.lsp.config('lua_ls', {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if
            path ~= vim.fn.stdpath('config')
            and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using (most
          -- likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Tell the language server how to find Lua modules same way as Neovim
          -- (see `:h lua-module-load`)
          path = {
            'lua/?.lua',
            'lua/?/init.lua',
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME
            -- Depending on the usage, you might want to add additional paths
            -- here.
            -- '${3rd}/luv/library'
            -- '${3rd}/busted/library'
          }
          -- Or pull in all of 'runtimepath'.
          -- NOTE: this is a lot slower and will cause issues when working on
          -- your own configuration.
          -- See https://github.com/neovim/nvim-lspconfig/issues/3189
          -- library = {
          --   vim.api.nvim_get_runtime_file('', true),
          -- }
        }
      })
    end,
    settings = {
      Lua = {
        format = {
          enable = true,
          -- Put format options here
          -- NOTE: the value should be String!
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          }
        },
      }
    }
  })
end)

--                          /// Language - SQL ///

-- This is actually worse...
-- vim.treesitter.language.register('sql', 'googlesql')


--                          /// Language - Python ///
-- This requires: pip install 'python-lsp-server[all]'
-- See
-- https://github.com/neovim/nvim-lspconfig/commit/9100b3af6e310561167361536fd162bbe588049a
-- for config tips.
if not_in_google3 then
  nvim_lsp.pylsp.setup {
    on_attach = function(client, bufnr)
      -- No pyls formatting when using Google config.
      if vim.fn.filereadable(vim.fn.expand('~/google_dotfiles/google.lua')) ~= 0 then
        -- print(client.name)
        -- client.request("textDocument/formatting", {} , nil, vim.api.nvim_get_current_buf())
        client.server_capabilities.document_formatting = false
      end
      on_attach(client, bufnr)
    end,
    settings = {
      pyls = {
        plugins = {
          -- This requires: pip install yapf
          yapf = { enabled = true },
          autopep8 = { enabled = false },
          pylint = { enabled = true },
          pycodestyle = { enabled = false },
        }
      }
    }
  }
end
-- Auto add imports from file ~/.vim/python-imports.cfg
map('n', 'gai', ':ImportName<CR>')

vim.cmd('autocmd FileType python setlocal shiftwidth=2 tabstop=2')

--                          /// Language - C++ ///

nvim_lsp.clangd.setup {
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
  },
}


--                          /// Language - Clojure ///

-- See ~/.zprint.edn for clojure formatting configuration.  I do not use the
-- lsp formatter (cljfmt).

vim.cmd([[
  let g:sexp_enable_insert_mode_mappings = 0
  let s:sexp_mappings = {
    \ 'sexp_move_to_prev_bracket':      '',
    \ 'sexp_move_to_next_bracket':      '',
    \ }
]])


-- For Conjure
vim.cmd('let g:conjure#eval#result_register="+"')
vim.cmd('let g:conjure#log#wrap = v:true')
vim.cmd('let g:conjure#mapping#doc_word = v:false')

-- Workaround https://github.com/Olical/conjure/issues/644
vim.api.nvim_create_autocmd("ExitPre", {
  pattern = "*",
  callback = function(event)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end,
})
-- Port is at ~/.nrepl/nrepl.edn
map('n', '<localleader>cc', ':ConjureConnect 9000<CR>', { silent = true })
-- Note that the clojure project must have this dependency for Conjure to work:
-- [cider/cider-nrepl "0.24.0"]
-- See
-- https://github.com/Olical/conjure/wiki/Quick-start:-ClojureScript-(shadow-cljs)
-- for details.

-- Clerk: https://github.com/nextjournal/clerk#neovim--conjure
vim.cmd(
  [[
function! ClerkShow()
  exe "w"
  exe "ConjureEval (nextjournal.clerk/show! \"" . expand("%:p") . "\")"
endfunction

nmap <silent> <localleader>ec :execute ClerkShow()<CR>
]]
)

map('n', '<localleader>ed',
  ':ConjureEval ' ..
  '(require \'[flow-storm.api :refer [remote-connect]] ' ..
  -- '\'[debux.cs.core :as d :refer-macros [dbg dbgn dbg_ dbgn_]]' ..
  ')' ..
  ' (remote-connect)<CR>')

-- Generate an example for the spec below the cursor.
map('n', '<localleader>eg',
  ':execute "ConjureEval (gen/generate (s/gen " . expand("<cWORD>") . "))"<CR>')

vim.cmd(
  [[
" Treat joke files as clojure files
autocmd BufEnter *.joke,*.slang :setlocal filetype=clojure
" See https://github.com/Olical/conjure/issues/318
function! AutoConjureSelect()
  let shadow_build=system("ps aux | grep 'shadow-cljs watch' | head -1 | sed -E 's/.*?shadow-cljs watch //' | tr -d '\n'")
  let cmd='ConjureShadowSelect ' . shadow_build
  execute cmd
endfunction
command! AutoConjureSelect call AutoConjureSelect()
" See https://vi.stackexchange.com/q/19927 for ways to make this trigger only
" once per buffer.
autocmd BufReadPost *.cljs :AutoConjureSelect
]]
)
-- https://clojure-lsp.github.io/clojure-lsp/installation/
-- sudo bash < <(curl -s https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install)
nvim_lsp.clojure_lsp.setup {
  on_attach = on_attach
}


--                          /// Language - CSV ///

vim.cmd('autocmd FileType csv autocmd BufWritePre <buffer> :RainbowAlign')


--                          /// Language - Markdown ///

vim.cmd('autocmd Filetype markdown setlocal spell spelllang=en_us')
vim.cmd('autocmd FileType markdown set foldmethod=expr')


--                          /// Language - ZMK Config ///

vim.cmd('autocmd FileType dts setlocal textwidth=300')


--                          /// Language - HTML/CSS ///

-- Need to run this to install:
-- npm i -g vscode-langservers-extracted

nvim_lsp.html.setup {
  on_attach = on_attach
}
nvim_lsp.cssls.setup {
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
}

--                          /// Language - LaTeX ///

vim.cmd('autocmd Filetype latex setlocal spell spelllang=en_us')
vim.cmd('au BufNewFile *.tex 0r ~/.vim/tex.skel')


--                          /// Language - English ///

-- To get offline thesaurus
-- curl http://www.gutenberg.org/files/3202/files/mthesaur.txt >
-- ~/.vim/thesaurus/mthesaur.txt
map('n', 'zt', ':ThesaurusQueryReplaceCurrentWord<CR>')


--                          /// Language - GLSL ///


--                          /// Language - Dart ///


--                          /// Language - YAML ///

vim.cmd('autocmd FileType yaml setlocal shiftwidth=2 tabstop=2')


--                          /// Language - Bazel ///

vim.cmd('autocmd FileType bzl setlocal shiftwidth=4 tabstop=4')


--                          /// Language - Terminal ///

--                          /// Machine Specific Config Files ///
if vim.fn.filereadable(vim.fn.expand('~/google_dotfiles/google.lua')) ~= 0 then
  require('google_dotfiles/google').load_google_config(nvim_lsp, on_attach)
end
