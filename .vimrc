augroup VimRC
  autocmd!
augroup END

" set neovim default
set autoindent
set backspace=indent,eol,start
set incsearch
set laststatus=2
set modeline
set showcmd
set smarttab
set wildmenu

set t_Co=256
set hlsearch
syntax on

" ui
set number
set scrolloff=2
set visualbell
set list
set listchars=tab:>-,trail:-,nbsp:+,extends:>,precedes:<

" edit
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=0
" input soft tab by S-Tab
inoremap <S-Tab> <C-R>=repeat(' ', &shiftwidth - (virtcol('.') - 1) % &shiftwidth)<CR>

" space keymap
nnoremap <Space>s :<C-U>shell<CR>
nnoremap <Space>t :<C-U>split<CR>
nnoremap <Space>v :<C-U>vsplit<CR>
nnoremap <Space>h <C-W>h
nnoremap <Space>j <C-W>j
nnoremap <Space>k <C-W>k
nnoremap <Space>l <C-W>l
nnoremap <Space>H <C-W>H
nnoremap <Space>J <C-W>J
nnoremap <Space>K <C-W>K
nnoremap <Space>L <C-W>L
nnoremap <Space>r <C-W>r
nnoremap <Space>= <C-W>=
nnoremap <Space>> <C-W>>
nnoremap <Space>< <C-W><
nnoremap <Space>+ <C-W>+
nnoremap <Space>- <C-W>-

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
