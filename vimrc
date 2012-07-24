scriptencoding utf-8

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

"vundle plugins
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

"packages
Bundle 'flazz/vim-colorschemes'

filetype plugin indent on
"vundle plugins end

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set whichwrap=b,s,<,>,~,[,]

if has("vms")
  set nobackup          " do not keep a backup file, use versions instead
else
  set backup                       " keep a backup file
  set backupdir=$HOME/.vim-backup  " specify backup directory
  let &directory=&backupdir        " swap directory is same as backup
endif

set history=500         " keep 500 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set hidden              " enable multiple buffer
set number              " display line numbers

" indent
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2

" show blank chars
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%

" 全角スペース
function! IdeographicSpace()
  highlight IdeographicSpace
  \ cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
endfunction

if has('syntax')
  augroup IdeographicSpace
    autocmd!
    autocmd Colorscheme * call IdeographicSpace()
    autocmd VimEnter,WinEnter * match IdeographicSpace /　/
  augroup END
  call IdeographicSpace()
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                  \ | wincmd p | diffthis
endif

"Set Colorscheme
colorscheme zenburn
