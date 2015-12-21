" Vim color file
" Maintainer: Shunsuke Shimizu <grafi@grafi.jp>
" OriginalMaintainer: Henry So, Jr. <henryso@panix.com>

" These are the colors of the "desert" theme by Hans Fugal with a few small
" modifications (namely that I lowered the intensity of the normal white and
" made the normal and nontext backgrounds black), modified to work with 88-
" and 256-color xterms.
"
" The original "desert" theme is available as part of the vim distribution or
" at http://hans.fugal.net/vim/colors/.
"
" The real feature of this color scheme, with a wink to the "inkpot" theme, is
" the programmatic approximation of the gui colors to the palettes of 88- and
" 256- color xterms.  The functions that do this (folded away, for
" readability) are calibrated to the colors used for Thomas E. Dickey's xterm
" (version 200), which is available at http://dickey.his.com/xterm/xterm.html.
"
" I struggled with trying to parse the rgb.txt file to avoid the necessity of
" converting color names to #rrggbb form, but decided it was just not worth
" the effort.  Maybe someone seeing this may decide otherwise...

set background=dark

hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name="desert256mod"
if !exists("g:desert256mod_termtrans")
    let g:desert256mod_termtrans = 0
endif

if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " functions {{{
    " returns an approximate grey index for the given grey level
    function! s:grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual grey level represented by the grey index
    function! s:grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " returns the palette index for the given grey index
    function! s:grey_color(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " returns an approximate color index for the given color level
    function! s:rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " returns the actual color level for the given color index
    function! s:rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " returns the palette index for the given R/G/B color indices
    function! s:rgb_color(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " returns the palette index to approximate the given R/G/B color levels
    function! s:color(r, g, b)
        " get the closest grey
        let l:gx = s:grey_number(a:r)
        let l:gy = s:grey_number(a:g)
        let l:gz = s:grey_number(a:b)

        " get the closest color
        let l:x = s:rgb_number(a:r)
        let l:y = s:rgb_number(a:g)
        let l:z = s:rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " there are two possibilities
            let l:dgr = s:grey_level(l:gx) - a:r
            let l:dgg = s:grey_level(l:gy) - a:g
            let l:dgb = s:grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = s:rgb_level(l:gx) - a:r
            let l:dg = s:rgb_level(l:gy) - a:g
            let l:db = s:rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " use the grey
                return s:grey_color(l:gx)
            else
                " use the color
                return s:rgb_color(l:x, l:y, l:z)
            endif
        else
            " only one possibility
            return s:rgb_color(l:x, l:y, l:z)
        endif
    endfun

    " returns the palette index to approximate the 'rrggbb' hex string
    function! s:rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return s:color(l:r, l:g, l:b)
    endfun

    " sets the highlighting for the given group
    function! s:X(group, fg, bg, attr)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . s:rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . s:rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun
    " }}}


    " highlight groups
    if (g:desert256mod_termtrans)
        call s:X("NonText", "addbe7", "", "bold")
        call s:X("Normal", "cccccc", "", "")
    else
        call s:X("NonText", "addbe7", "000000", "bold")
        call s:X("Normal", "cccccc", "000000", "")
    endif
    "Directory
    "DiffAdd
    "DiffChange
    "DiffDelete
    "DiffText
    "ErrorMsg
    call s:X("VertSplit", "c2bfa5", "7f7f7f", "reverse")
    call s:X("Folded", "ffd700", "4d4d4d", "")
    call s:X("FoldColumn", "d2b48c", "4d4d4d", "")
    call s:X("IncSearch", "708090", "f0e68c", "")
    "LineNr
    call s:X("MatchParen", "", "404890", "")
    call s:X("ModeMsg", "daa520", "", "")
    call s:X("MoreMsg", "2e8b57", "", "")
    call s:X("Question", "00ff7f", "", "")
    call s:X("Search", "f5deb3", "cd853f", "")
    call s:X("SpecialKey", "508050", "", "")
    call s:X("StatusLine", "c2bfa5", "000000", "reverse")
    call s:X("StatusLineNC", "c2bfa5", "7f7f7f", "reverse")
    call s:X("Title", "cd5c5c", "", "")
    call s:X("Visual", "6b8e23", "f0e68c", "reverse")
    "VisualNOS
    call s:X("WarningMsg", "fa8072", "", "")
    "WildMenu
    "Menu
    "Scrollbar
    "Tooltip
    call s:X("Pmenu","f6f3e8","444444", "")
    call s:X("PmenuSel","000000","cae682", "")

    " syntax highlighting groups
    call s:X("Comment", "87ceeb", "", "")
    call s:X("Constant", "ffa0a0", "", "")
    call s:X("Identifier", "98fb98", "", "none")
    call s:X("Statement", "f0e68c", "", "bold")
    call s:X("PreProc", "cd5c5c", "", "")
    call s:X("Type", "bdb76b", "", "bold")
    call s:X("Special", "ffdead", "", "")
    "Underlined
    call s:X("Ignore", "666666", "", "")
    "Error
    call s:X("Todo", "ff4500", "eeee00", "")

else
    " Copied from original desert scheme.
    " color terminal definitions
    hi SpecialKey    ctermfg=darkgreen
    hi NonText       cterm=bold ctermfg=darkblue
    hi Directory     ctermfg=darkcyan
    hi ErrorMsg      cterm=bold ctermfg=7 ctermbg=1
    hi IncSearch     cterm=NONE ctermfg=yellow ctermbg=green
    hi Search        cterm=NONE ctermfg=grey ctermbg=blue
    hi MoreMsg       ctermfg=darkgreen
    hi ModeMsg       cterm=NONE ctermfg=brown
    hi LineNr        ctermfg=3
    hi Question      ctermfg=green
    hi StatusLine    cterm=bold,reverse
    hi StatusLineNC  cterm=reverse
    hi VertSplit     cterm=reverse
    hi Title         ctermfg=5
    hi Visual        cterm=reverse
    hi VisualNOS     cterm=bold,underline
    hi WarningMsg    ctermfg=1
    hi WildMenu      ctermfg=0 ctermbg=3
    hi Folded        ctermfg=darkgrey ctermbg=NONE
    hi FoldColumn    ctermfg=darkgrey ctermbg=NONE
    hi DiffAdd       ctermbg=4
    hi DiffChange    ctermbg=5
    hi DiffDelete    cterm=bold ctermfg=4 ctermbg=6
    hi DiffText      cterm=bold ctermbg=1
    hi Comment       ctermfg=darkcyan
    hi Constant      ctermfg=brown
    hi Special       ctermfg=5
    hi Identifier    ctermfg=6
    hi Statement     ctermfg=3
    hi PreProc       ctermfg=5
    hi Type          ctermfg=2
    hi Underlined    cterm=underline ctermfg=5
    hi Ignore        ctermfg=darkgrey
    hi Error         cterm=bold ctermfg=7 ctermbg=1
endif

" vim: set fdl=0 fdm=marker:
