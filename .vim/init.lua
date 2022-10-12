
--                          /// Utilities ///

-- Taken from https://oroques.dev/notes/neovim-init
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Debug print a lua datastructure
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..tostring(k)..'"' end
         s = s .. '['..tostring(k)..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


--                          /// Plugin Management ///

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local function notInGoogle3()
  print(string.find(vim.fn.getcwd(), '/google/src') == nil)
  return string.find(vim.fn.getcwd(), '/google/src') == nil
end

local not_in_google3 = string.find(vim.fn.getcwd(), '/google/src') == nil

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'yuttie/comfortable-motion.vim';
  use 'ggvgc/vim-fuzzysearch';
  use 'AndrewRadev/splitjoin.vim';
  -- Automatically delete extra characters (like quotes) when joining lines.
  use 'flwyd/vim-conjoin';
  -- Automatically set tabstop/shiftwidth based on current file or nearby files.
  use 'tpope/vim-sleuth';
  -- Change cases using e.g. cru for upper case.
  use 'tpope/vim-abolish';
  use 'kylechui/nvim-surround';
  use 'tpope/vim-repeat';
  use 'windwp/nvim-autopairs';
  -- Automatically align code.
  use 'junegunn/vim-easy-align';
  -- Highlight current word with cursor on it across whole buffer.
  use 'RRethy/vim-illuminate';
  -- Animates window resizing.
  use 'camspiers/animate.vim';
  use 'lukas-reineke/indent-blankline.nvim';
  -- Add scrollbars.
  use { 'dstein64/nvim-scrollview', branch = 'main' };
  use 'vim-airline/vim-airline';
  -- Persist settings between sessions
  use 'zhimsel/vim-stay';
  -- Better directory browsing.  Access the directory the current file is in with
  -- the - key.
  use 'justinmk/vim-dirvish';
  use 'tpope/vim-eunuch';
  -- Make it so that when a buffer is deleted, the window stays.
  use 'qpkorr/vim-bufkill';
  use 'kana/vim-altr';
  -- Open files at specified lines using file:line syntax.
  use 'wsdjeg/vim-fetch';
  use {'junegunn/fzf', run = vim.fn['fzf#install']};
  use { 'junegunn/fzf.vim' };
  use 'pbogut/fzf-mru.vim';
  use 'ludovicchabant/vim-lawrencium';
  use 'mhinz/vim-signify';
  use {'rafamadriz/friendly-snippets'};
  use {'hrsh7th/cmp-buffer'};
  use {'hrsh7th/cmp-emoji'};
  use {'hrsh7th/cmp-calc'};
  use {'hrsh7th/cmp-path'};
  use {'hrsh7th/cmp-nvim-lua'};
  use {'f3fora/cmp-spell'};
  use {'hrsh7th/cmp-nvim-lsp'};
  use {'hrsh7th/cmp-vsnip'};
  use {'hrsh7th/vim-vsnip'};
  use {'hrsh7th/vim-vsnip-integ'};
  use {'hrsh7th/nvim-cmp'};
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'};
  use 'nvim-treesitter/nvim-treesitter-textobjects';
  use 'nvim-treesitter/playground';
  use 'p00f/nvim-ts-rainbow';
  use { 'neovim/nvim-lspconfig', run = install_python_ls };
  use 'nvim-lua/lsp-status.nvim';
  use 'mgedmin/python-imports.vim';
  use 'Olical/conjure';
  use {'eraserhd/parinfer-rust', run = 'cargo build --release'};
  use 'mechatroner/rainbow_csv';
  use 'masukomi/vim-markdown-folding';
  use 'ron89/thesaurus_query.vim';
  use 'tikhomirov/vim-glsl';
  use 'dart-lang/dart-vim-plugin';
  -- Attmpts to make vim better when reading terminal data from kitty
  -- TODO FIX
  use 'rkitover/vimpager';
  use 'habamax/vim-godot';
  use 'dhruvasagar/vim-table-mode';
  use 'whonore/vim-sentencer';
  use 'ruanyl/vim-gh-line';
  use 'ggandor/leap.nvim';
  use 'narutoxy/dim.lua';
  use 'romainl/vim-cool';
  use {'gen740/SmoothCursor.nvim',
       config = function() require('smoothcursor').setup({cursor = ">",
                                                          linehl = "CursorLine",
                                                          texthl = "CursorLine"}) end}
  if vim.fn.filereadable(vim.fn.expand('~/google_dotfiles/google.lua')) ~= 0 then
    require('google_dotfiles/google').load_google_plugins(use)
  else
    -- TODO find a way to put the codefmt lines here so that I can source
    -- google.vim in my google-specific config.
  end
  use {'google/vim-maktaba'};
  use {'google/vim-codefmt'};



  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

--                          /// General ///

vim.g.maplocalleader=" "

--                          /// Navigation ///

require('leap').set_default_keymaps()

-- Nicer up/down movement on long lines.
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- Colemak rebind
map('n', 'e', 'gj')
map('n', 'E', 'J')
map('v', 'e', 'j')
map('v', 'E', 'J')

-- Smooth scrolling, ctrl-j or enter to go down, ctrl-k or tab to go up.
vim.g.comfortable_motion_no_default_key_mappings = true
map('n', '<C-e>', ':call comfortable_motion#flick(50)<CR>10j', { silent = true })
-- map('n', '<CR>', ':call comfortable_motion#flick(50)<CR>10j', { silent = true })
map('n', '<PageDown>', ':call comfortable_motion#flick(50)<CR>10j', { silent = true })
map('n', '<C-u>', '<tab>')
-- map('n', '<tab>', ':call comfortable_motion#flick(-50)<CR>10k', { silent = true })
map('n', '<C-k>', ':call comfortable_motion#flick(-50)<CR>10k', { silent = true })
map('n', '<PageUp>', ':call comfortable_motion#flick(-50)<CR>10k', { silent = true })
map('v', '<C-e>', ':call comfortable_motion#flick(50)<CR>10j', { silent = true })
-- map('v', '<CR>', ':call comfortable_motion#flick(50)<CR>10j', { silent = true })
map('v', '<PageDown>', ':call comfortable_motion#flick(50)<CR>10j', { silent = true })
map('v', '<C-u>', '<tab>')
-- map('v', '<tab>', ':call comfortable_motion#flick(-50)<CR>10k', { silent = true })
map('v', '<C-k>', ':call comfortable_motion#flick(-50)<CR>10k', { silent = true })
map('v', '<PageUp>', ':call comfortable_motion#flick(-50)<CR>10k', { silent = true })

-- Hit escape twice to clear old search highlighting.  vim-cool kinda makes
-- this obselete.
map('n', '<Esc><Esc>', ':let @/=""<CR>', {silent = true})
vim.g.CoolTotalMatches = true

--                          /// Editing and Formatting ///

-- Rename word and prime to replace other occurances
-- Can also search for something then use 'cgn' to "change next searched occurance".
map('v', '//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])
map('n', 'ct', '*Ncw<C-r>"')
map('n', 'cT', '*Ncw')

-- Copy the line N lines above/below the current line and put it below the
-- current line. See https://vi.stackexchange.com/q/3231
-- e.g. 4TT gets the line 4 lines below the current line.
-- This is somewhat obselete by the ctrl-l fzf lines functionality.
map('n', 'tt', [[:<C-u>execute ':-' . v:count . 't.'<CR>]])
map('n', 'TT', [[:<C-u>execute ':+' . v:count . 't.'<CR>]])

-- Rename word across file
map('n', 'cW', ':%s/\\<<C-r><C-w>\\>/')

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

-- Wrap lines automatically at 79 characters.
-- vim.wo.wrap = true
vim.wo.linebreak = true
vim.o.textwidth = 79
vim.bo.wrapmargin = 0
vim.bo.formatoptions = vim.o.formatoptions .. 'l'
-- vim.bo.formatoptions = vim.o.formatoptions .. 't'

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
    surrounds = {
        ["("] = {
            add = { "(", ")" },
            find = function()
                return M.get_selection({ motion = "a(" })
            end,
            delete = "^(. ?)().-( ?.)()$",
        },
        [")"] = {
            add = { "(", ")" },
            find = function()
                return M.get_selection({ motion = "a)" })
            end,
            delete = "^(.)().-(.)()$",
        },
        ["{"] = {
            add = { "{", "}" },
            find = function()
                return M.get_selection({ motion = "a{" })
            end,
            delete = "^(. ?)().-( ?.)()$",
        },
        ["}"] = {
            add = { "{", "}" },
            find = function()
                return M.get_selection({ motion = "a}" })
            end,
            delete = "^(.)().-(.)()$",
        },
        ["<"] = {
            add = { "<", ">" },
            find = function()
                return M.get_selection({ motion = "a<" })
            end,
            delete = "^(. ?)().-( ?.)()$",
        },
        [">"] = {
            add = { "<", ">" },
            find = function()
                return M.get_selection({ motion = "a>" })
            end,
            delete = "^(.)().-(.)()$",
        },
        ["["] = {
            add = { "[", "]" },
            find = function()
                return M.get_selection({ motion = "a[" })
            end,
            delete = "^(. ?)().-( ?.)()$",
        },
        ["]"] = {
            add = { "[", "]" },
            find = function()
                return M.get_selection({ motion = "a]" })
            end,
            delete = "^(.)().-(.)()$",
        },
        ["'"] = {
            add = { "'", "'" },
            find = function()
                return M.get_selection({ motion = "a'" })
            end,
            delete = "^(.)().-(.)()$",
        },
        ['"'] = {
            add = { '"', '"' },
            find = function()
                return M.get_selection({ motion = 'a"' })
            end,
            delete = "^(.)().-(.)()$",
        },
        ["`"] = {
            add = { "`", "`" },
            find = function()
                return M.get_selection({ motion = "a`" })
            end,
            delete = "^(.)().-(.)()$",
        },
        ["i"] = { -- TODO: Add find/delete/change functions
            add = function()
                local left_delimiter = M.get_input("Enter the left delimiter: ")
                local right_delimiter = left_delimiter and M.get_input("Enter the right delimiter: ")
                if right_delimiter then
                    return { { left_delimiter }, { right_delimiter } }
                end
            end,
            find = function() end,
            delete = function() end,
        },
        ["t"] = {
            add = function()
                local input = M.get_input("Enter the HTML tag: ")
                if input then
                    local element = input:match("^<?([^%s>]*)")
                    local attributes = input:match("^<?[^%s>]*%s+(.-)>?$")

                    local open = attributes and element .. " " .. attributes or element
                    local close = element

                    return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
                end
            end,
            find = function()
                return M.get_selection({ motion = "at" })
            end,
            delete = "^(%b<>)().-(%b<>)()$",
            change = {
                target = "^<([^%s<>]*)().-([^/]*)()>$",
                replacement = function()
                    local input = M.get_input("Enter the HTML tag: ")
                    if input then
                        local element = input:match("^<?([^%s>]*)")
                        local attributes = input:match("^<?[^%s>]*%s+(.-)>?$")

                        local open = attributes and element .. " " .. attributes or element
                        local close = element

                        return { { open }, { close } }
                    end
                end,
            },
        },
        ["T"] = {
            add = function()
                local input = M.get_input("Enter the HTML tag: ")
                if input then
                    local element = input:match("^<?([^%s>]*)")
                    local attributes = input:match("^<?[^%s>]*%s+(.-)>?$")

                    local open = attributes and element .. " " .. attributes or element
                    local close = element

                    return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
                end
            end,
            find = function()
                return M.get_selection({ motion = "at" })
            end,
            delete = "^(%b<>)().-(%b<>)()$",
            change = {
                target = "^<([^>]*)().-([^/]*)()>$",
                replacement = function()
                    local input = M.get_input("Enter the HTML tag: ")
                    if input then
                        local element = input:match("^<?([^%s>]*)")
                        local attributes = input:match("^<?[^%s>]*%s+(.-)>?$")

                        local open = attributes and element .. " " .. attributes or element
                        local close = element

                        return { { open }, { close } }
                    end
                end,
            },
        },
        ["f"] = {
            add = function()
                local result = M.get_input("Enter the function name: ")
                if result then
                    return { { result .. "(" }, { ")" } }
                end
            end,
            find = function()
                local selection
                if vim.g.loaded_nvim_treesitter then
                    selection = M.get_selection({
                        query = {
                            capture = "@call.outer",
                            type = "textobjects",
                        },
                    })
                end
                if selection then
                    return selection
                end
                return M.get_selection({ pattern = "[^=%s%(%)]+%b()" })
            end,
            delete = "^(.-%()().-(%))()$",
            --[[ function()
                local selections
                if vim.g.loaded_nvim_treesitter then
                    selections = M.get_selections({
                        char = "f",
                        exclude = function()
                            return M.get_selection({
                                query = {
                                    capture = "@call.inner",
                                    type = "textobjects",
                                },
                            })
                        end,
                    })
                end
                if selections then
                    return selections
                end
                return M.get_selections({ char = "f", pattern = "^([^=%s%(%)]+%()().-(%))()$" })
            end, ]]
            change = {
                target = "^.-([%w_]+)()%(.-%)()()$",
                replacement = function()
                    local result = M.get_input("Enter the function name: ")
                    if result then
                        return { { result }, { "" } }
                    end
                end,
            },
        },
        invalid_key_behavior = {
            add = function(char)
                return { { char }, { char } }
            end,
            find = function(char)
                return M.get_selection({
                    pattern = vim.pesc(char) .. ".-" .. vim.pesc(char),
                })
            end,
            delete = function(char)
                return M.get_selections({
                    char = char,
                    pattern = "^(.)().-(.)()$",
                })
            end,
            change = {
                target = function(char)
                    return M.get_selections({
                        char = char,
                        pattern = "^(.)().-(.)()$",
                    })
                end,
            },
        },
        ["l"] = {
            add = function()
                local clipboard = vim.fn.getreg("+"):gsub("\n", "")
                return {
                    { "[" },
                    { "](" .. clipboard .. ")" },
                }
            end,
            find = "%b[]%b()",
            delete = "^(%[)().-(%]%b())()$",
            change = {
                target = "^()()%b[]%((.-)()%)$",
                replacement = function()
                    local clipboard = vim.fn.getreg("+"):gsub("\n", "")
                    return {
                        { "" },
                        { clipboard },
                    }
                end,
            },
        },
    },
    aliases = {
        ["a"] = ">", -- Single character aliases apply everywhere
        ["b"] = ")",
        ["B"] = "}",
        ["r"] = "]",
        ["q"] = { '"', "'", "`" }, -- Table aliases only apply for changes/deletions
    },
})

-- Automatically close parens.
local npairs = require('nvim-autopairs')
npairs.setup({
  disable_filetype = { "TelescopePrompt" , "clojure" },
})

--                          /// Visuals ///

-- Show tabs as actual characters.
vim.wo.list = true
vim.wo.listchars = 'tab:>-'

-- My custom colorscheme defined in ~/.vim/colors.
vim.cmd('colorscheme terminal')
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
require("indent_blankline").setup {
    char = "¦",
    buftype_exclude = {"terminal"},
    show_current_context = true,
    max_indent_increase = 1,
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

-- Disable netrw so dirvish is used for everything
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

map('n', '(', ':wincmd W<CR>')
map('n', ')', ':wincmd w<CR>')

map('n', '<BS>', ':bn<CR>')

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
{noremap = true,
 nowait = true})

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
  vim.cmd('autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')
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

map('n', '<space>', ':FuzzySearch<CR>')

vim.g.fzf_history_dir = '~/.local/share/fzf-history'

-- Search in files starting from directory with current buffer and working way
-- up with a maximum of 100 files using the , key.
vim.cmd(
[[
let g:types = { 'dict': type({}), 'funcref': type(function('call')), 'string': type(''), 'list': type([]) }
function! g:Warn(message)
  echohl WarningMsg
  echom a:message
  echohl None
  return 0
endfunction
function! g:Myag(query, ...)
  if type(a:query) != g:types.string
    return g:Warn('Invalid query argument')
  endif
  let query = empty(a:query) ? '^(?=.)' : a:query
  let args = copy(a:000)
  let ag_opts = len(args) > 1 && type(args[0]) == g:types.string ? remove(args, 0) : ''
  let command = ag_opts . ' ' . fzf#shellescape(query) . ' ' .
        \ printf('$(find_up.bash %s -type f | head -n 100)',
        \        expand('%:h'))
  return call('fzf#vim#ag_raw', insert(args, command, 0))
endfunction
command! -bang -nargs=* MyAg call g:Myag(<q-args>, <bang>0)
]]
)
map('n', ',', ':MyAg ')

-- Search through all files in the current buffer's directory with ; when in a
-- vim-dirvish directory buffer.
vim.cmd(
[[
function! g:Dirag(query, ...)
  if type(a:query) != g:types.string
    return g:Warn('Invalid query argument')
  endif
  let query = empty(a:query) ? '^(?=.)' : a:query
  let args = copy(a:000)
  echo args
  let ag_opts = len(args) > 1 && type(args[0]) == g:types.string ? remove(args, 0) : ''
  let command = ag_opts . ' ' . fzf#shellescape(query) . ' ' . expand('%:h')
  return call('fzf#vim#ag_raw', insert(args, command, 0))
endfunction
command! -bang -nargs=* DirAg call g:Dirag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
autocmd FileType dirvish nnoremap <buffer> ; :DirAg<CR>
]]
)

-- Search in all buffer lines with the ; key.
map('n', ';', ':Lines<CR>')

-- Search through most recently used files with the ' key.
vim.g.fzf_mru_max = 100000
-- This is used instead of 'google3' because when fig uses vimdiff it puts the
-- vim instance at the root of the CitC client (the dir _containing_ google3).
vim.g.fzf_mru_store_relative_dirs = {'/google/src/cloud/'}
-- Exclude files with google3 in them - these will be opened only when things are
-- merged via vimdiff.
vim.g.fzf_mru_exclude = '/tmp/\\|google3'
map('n', "'", ":FZFMru -m -x --tiebreak=index --nth=-1,.. --delimiter=/ --preview 'bat --color=always --style=plain --theme=base16 {}'<CR>")
-- The '1000 part of this will make it so that 1000 oldfiles are remembered (the
-- last 1000 files will be available with the FZFMru command)
vim.o.shada = "!,'1000,<50,s10,h"


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

-- Toggle mercurial diff of current file with alt-d.
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
map('n', '<C-d>', ':HgDiffTargetCmd<CR>')


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

-- Setup nvim-cmp.
local cmp = require'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- local source_names = {
--   nvim_lsp = "(LSP)",
--   emoji = "(Emoji)",
--   path = "(Path)",
--   calc = "(Calc)",
--   cmp_tabnine = "(Tabnine)",
--   vsnip = "(Snippet)",
--   luasnip = "(Snippet)",
--   buffer = "(Buffer)",
--   tmux = "(TMUX)",
--   nvim_ciderlsp = "(ML-Autocompletion!)"
-- }

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    -- From https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#vim-vsnip
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),

  },
  sources = {
    { name = 'nvim_ciderlsp' },
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'emoji' },
    { name = 'calc' },
    { name = 'spell' },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'buffer',
      option = {
        -- Complete from all open buffers, not just the current one.
        -- https://github.com/hrsh7th/cmp-buffer/issues/1.
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      },
    },
  },
  -- formatting = {
  --     fields = { "kind", "abbr", "menu" },
  --     format = function(entry, vim_item)
  --       -- vim_item.kind = kind_icons[vim_item.kind]
  --       vim_item.menu = source_names[entry.source.name]
  --       -- vim_item.dup = duplicates[entry.source.name]
  --       return vim_item
  --     end
  -- },
})

cmp.setup.cmdline("/", {sources = {{name = "buffer"}}})

cmp.setup.cmdline(":", {
    sources = cmp.config.sources({{name = "path"}}, {{name = "cmdline"}})
})

-- Setup lspconfig.
-- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
--   capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- }

-- Integration with nvim-autopairs.
_G.MUtils= {}  -- skip it, if you use another global object
vim.g.completion_confirm_key = ""
MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"](npairs.esc("<cr>"))
    else
      return npairs.esc("<cr>")
    end
  else
    return npairs.autopairs_cr()
  end
end
map('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true})


map('i', '<C-l>', '<plug>(fzf-complete-line)')


--                          /// Language - General ///

require('dim').setup({})

vim.cmd [[
  command! TSHighlightCapturesUnderCursor :lua require'nvim-treesitter-playground.hl-info'.show_hl_captures()<cr>
]]

-- Adds multicolored parenthesis to make it easier to see how they match up.
require('nvim-treesitter.configs').setup {
  ensure_installed = {'python', 'clojure'},
  highlight = {enable = true},
  -- TODO Re-enable when this works better for python.
  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1136 might be
  -- related
  -- indent = {enable = true},
  rainbow = {
    enable = true,
    extended_mode = true, -- Highlight also non-parentheses delimiters
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
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
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
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.cmd('set foldmethod=expr')
vim.cmd('set foldexpr=nvim_treesitter#foldexpr()')
vim.cmd('set foldlevelstart=99')

local function install_python_ls()
  vim.cmd('!pip install python-language-server[all] yapf')
end
local nvim_lsp = require('lspconfig')

-- Range formatting
-- See https://github.com/neovim/neovim/issues/14680
function format_range_operator(motion)
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, '[')
    local finish = vim.api.nvim_buf_get_mark(0, ']')
    vim.lsp.buf.range_formatting({}, start, finish)
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = 'v:lua.op_func_formatting'
  vim.api.nvim_feedkeys('g@' .. motion, 'n', false)
end
vim.api.nvim_set_keymap('n', '<localleader>g', '<cmd>lua format_range_operator("")<CR>', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<localleader>f', '<cmd>lua format_range_operator("ip")<CR>', {noremap = true})
-- https://stackoverflow.com/a/54647696 explains why the \<lt> escape is
-- important
vim.api.nvim_set_keymap('n', '<localleader>f', [[:execute "norm! vip:FormatLines\<lt>CR>"<CR>]], {noremap = true})


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
  local opts = { noremap=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'ge', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'gW', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  -- buf_set_keymap('v', 'gQ', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
end


--                          /// Language - Python ///
-- This requires: pip install 'python-lsp-server[all]'
-- See
-- https://github.com/neovim/nvim-lspconfig/commit/9100b3af6e310561167361536fd162bbe588049a
-- for config tips.
nvim_lsp.pylsp.setup {
  on_attach = function(client, bufnr)
    -- No pyls formatting when using Google config.
    if vim.fn.filereadable(vim.fn.expand('~/google_dotfiles/google.lua')) ~= 0 then
      -- print(client.name)
      -- client.request("textDocument/formatting", {} , nil, vim.api.nvim_get_current_buf())
      client.resolved_capabilities.document_formatting = false
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
-- Auto add imports from file ~/.vim/python-imports.cfg
map('n', 'gai', ':ImportName<CR>')

vim.cmd('autocmd FileType python setlocal shiftwidth=2 tabstop=2')

--                          /// Language - Clojure ///

-- For Conjure
vim.cmd('let g:conjure#eval#result_register="+"')
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

vim.g.clj_fmt_autosave = 0

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


--                          /// Language - GDScript ///
nvim_lsp.gdscript.setup {
  on_attach = on_attach
}

--                          /// Machine Specific Config Files ///
if vim.fn.filereadable(vim.fn.expand('~/google_dotfiles/google.lua')) ~= 0 then
  require('google_dotfiles/google').load_google_config(nvim_lsp, on_attach)
end
