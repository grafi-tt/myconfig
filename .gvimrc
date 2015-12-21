" font
if has('win32')
	" TODO: enable M+ on Windows
	set guifont=MS_Gothic:h12:cSHIFTJIS
elseif has('gui_macvim')
	set guifont=M+\ 1m\ regular:h12
elseif has('gui_gtk2')
	set guifont=M+\ 1m\ regular\ 9
elseif has('xfontset')
	set guifontset=a14,r14,k14
endif

" window
set columns=120
set lines=40
set guioptions=ei
set guicursor=a:blinkon0

" mouse
set mouse=a
set nomousefocus
set mousehide
