"
" Essential Vim settings (aiming to <100 lines)
"
augroup VimRC
  autocmd!
augroup END

"" general
set wildmenu
set visualbell
set modeline
set iminsert=1 imsearch=-1

"" keymap
" shell
nnoremap <Space>s :<C-U>shell<CR>

"" edit
set backspace=indent,eol,start
set smarttab
set autoindent noexpandtab
set tabstop=4 shiftwidth=4 softtabstop=0
set cinoptions=:0 "disable idnent of case label
" input soft tab by S-Tab
inoremap <S-Tab> <C-R>=repeat(' ', &shiftwidth - (virtcol('.') - 1) % &shiftwidth)<CR>

"" appearance
set noruler
set showcmd
set laststatus=2
set number
set list listchars=tab:>-,trail:-,extends:>,precedes:<
set scrolloff=2

set t_Co=256
syntax on
set hlsearch
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
colorscheme desert

" status line (guessed default: %t\ %m%h%r%=%l,%c%V\ %P)
" [1] sample.txt [type][encoding:format][+][RO]    1,1-1    All
set statusline=[%n]\ %t\ %y%{GetStatusEx()}%m%r%=%l,%c%V\ \ \ \ %P
function! GetStatusEx()
  let str = &fileformat
  if has("multi_byte") && &fileencoding != ""
    let str = &fileencoding . ":" . str
  endif
  let str = "[" . str . "]"
  return str
endfunction

"" search
set noignorecase
set wrapscan
set incsearch

"" encoding
if has("multi_byte")
  set ambiwidth=single
  set encoding=utf-8
  set fileencoding=utf-8
  set fileencodings=utf-8,eucjp,iso-2022-jp,ucs-bom,cp932,latin-1
  autocmd VimRC BufReadPost *
        \ if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0 |
        \   let &fileencoding=&encoding |
        \ endif
endif

set fileformat=unix
set fileformats=unix,dos

"" autocmd
" open QuickFix Automatically
autocmd VimRC QuickfixCmdPost make,grep,grepadd,vimgrep cwindow
" keep cursor position
autocmd VimRC BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   execute "normal g`\"" |
      \ endif

"" invitation to dark Vim
if filereadable($MYVIMRC . ".full")
  source $MYVIMRC.full
end
