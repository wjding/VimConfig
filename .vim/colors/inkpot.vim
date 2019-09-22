" Vim color file
" Name:       inkpot.vim
" Maintainer: Ciaran McCreesh <ciaranm@gentoo.org>
" This should work in the GUI, rxvt-unicode (88 colour mode) and xterm (256
" colour mode). It won't work in 8/16 colour terminals.

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let colors_name = "inkpot"

" map a urxvt cube number to an xterm-256 cube number
fun! <SID>M(a)
    return strpart("0135", a:a, 1) + 0
endfun

" map a urxvt colour to an xterm-256 colour
fun! <SID>X(a)
    if &t_Co == 88
        return a:a
    else
        if a:a == 8
            return 237
        elseif a:a < 16
            return a:a
        elseif a:a > 79
            return 232 + (3 * (a:a - 80))
        else
            let l:b = a:a - 16
            let l:x = l:b % 4
            let l:y = (l:b / 4) % 4
            let l:z = (l:b / 16)
            return 16 + <SID>M(l:x) + (6 * <SID>M(l:y)) + (36 * <SID>M(l:z))
        endif
    endif
endfun

" {{{
exec "hi Normal         gui=NONE   guifg=#cfbfad   guibg=#1e1e27   cterm=NONE   ctermfg=" . <SID>X("7") . "   ctermbg=" . <SID>X(80) . ""
exec "hi IncSearch      gui=BOLD   guifg=#303030   guibg=#cd8b60   cterm=BOLD   ctermfg=" . <SID>X("80") . "   ctermbg=" . <SID>X(73) . ""
exec "hi Search         gui=NONE   guifg=#303030   guibg=#cd8b60   cterm=NONE   ctermfg=" . <SID>X("80") . "   ctermbg=" . <SID>X(73) . ""
exec "hi ErrorMsg       gui=BOLD   guifg=#ffffff   guibg=#ff3300   cterm=BOLD   ctermfg=" . <SID>X("79") . "   ctermbg=" . <SID>X(64) . ""
exec "hi WarningMsg     gui=BOLD   guifg=#ffffff   guibg=#ff6600   cterm=BOLD   ctermfg=" . <SID>X("79") . "   ctermbg=" . <SID>X(68) . ""
exec "hi ModeMsg        gui=BOLD   guifg=#7e7eae   guibg=NONE      cterm=BOLD   ctermfg=" . <SID>X("39") . ""
exec "hi MoreMsg        gui=BOLD   guifg=#7e7eae   guibg=NONE      cterm=BOLD   ctermfg=" . <SID>X("39") . ""
exec "hi Question       gui=BOLD   guifg=#ffcd00   guibg=NONE      cterm=BOLD   ctermfg=" . <SID>X("72") . ""
exec "hi StatusLine     gui=BOLD   guifg=#b9b9b9   guibg=#3e3e5e   cterm=BOLD   ctermfg=" . <SID>X("84") . "   ctermbg=" . <SID>X(81) . ""
exec "hi StatusLineNC   gui=NONE   guifg=#b9b9b9   guibg=#3e3e5e   cterm=NONE   ctermfg=" . <SID>X("84") . "   ctermbg=" . <SID>X(81) . ""
exec "hi VertSplit      gui=NONE   guifg=#b9b9b9   guibg=#3e3e5e   cterm=NONE   ctermfg=" . <SID>X("84") . "   ctermbg=" . <SID>X(82) . ""
exec "hi WildMenu       gui=BOLD   guifg=#ffcd00   guibg=#1e1e2e   cterm=BOLD   ctermfg=" . <SID>X("72") . "   ctermbg=" . <SID>X(80) . ""

exec "hi DiffText       gui=NONE   guifg=#ffffcd   guibg=#00cd00   cterm=NONE   ctermfg=" . <SID>X("78") . "   ctermbg=" . <SID>X(24) . ""
exec "hi DiffChange     gui=NONE   guifg=#ffffcd   guibg=#008bff   cterm=NONE   ctermfg=" . <SID>X("78") . "   ctermbg=" . <SID>X(23) . ""
exec "hi DiffDelete     gui=NONE   guifg=#ffffcd   guibg=#cd0000   cterm=NONE   ctermfg=" . <SID>X("78") . "   ctermbg=" . <SID>X(48) . ""
exec "hi DiffAdd        gui=NONE   guifg=#ffffcd   guibg=#00cd00   cterm=NONE   ctermfg=" . <SID>X("78") . "   ctermbg=" . <SID>X(24) . ""

exec "hi Cursor         gui=NONE   guifg=#404040   guibg=#8b8bff   cterm=NONE   ctermfg=" . <SID>X("8") . "    ctermbg=" . <SID>X(39) . ""
exec "hi lCursor        gui=NONE   guifg=#404040   guibg=#8b8bff   cterm=NONE   ctermfg=" . <SID>X("8") . "    ctermbg=" . <SID>X(39) . ""
exec "hi CursorIM       gui=NONE   guifg=#404040   guibg=#8b8bff   cterm=NONE   ctermfg=" . <SID>X("8") . "    ctermbg=" . <SID>X(39) . ""

exec "hi Folded         gui=NONE   guifg=#cfcfcd   guibg=#4b208f   cterm=NONE   ctermfg=" . <SID>X("78") . "   ctermbg=" . <SID>X(35) . ""
exec "hi FoldColumn     gui=NONE   guifg=#8b8bcd   guibg=#2e2e2e   cterm=NONE   ctermfg=" . <SID>X("38") . "   ctermbg=" . <SID>X(80) . ""

exec "hi Directory      gui=NONE   guifg=#00ff8b   guibg=NONE      cterm=NONE   ctermfg=" . <SID>X("29") . "   ctermbg=NONE"
exec "hi LineNr         gui=NONE   guifg=#8b8bcd   guibg=#2e2e2e   cterm=NONE   ctermfg=" . <SID>X("38") . "   ctermbg=" . <SID>X(80) . ""
exec "hi NonText        gui=BOLD   guifg=#8b8bcd   guibg=NONE      cterm=BOLD   ctermfg=" . <SID>X("38") . "   ctermbg=NONE"
exec "hi SpecialKey     gui=BOLD   guifg=#8b00cd   guibg=NONE      cterm=BOLD   ctermfg=" . <SID>X("34") . "   ctermbg=NONE"
exec "hi Title          gui=BOLD   guifg=#af4f4b   guibg=#1e1e27   cterm=BOLD   ctermfg=" . <SID>X("52") . "   ctermbg=" . <SID>X(80) . ""
exec "hi Visual         gui=NONE   guifg=#cd8b00   guibg=#ffffcd   cterm=NONE   ctermfg=" . <SID>X("52") . "   ctermbg=" . <SID>X(78) . ""

exec "hi Comment        gui=NONE   guifg=#cd8b00   guibg=NONE      cterm=NONE   ctermfg=" . <SID>X("52") . "   ctermbg=NONE"
exec "hi Constant       gui=NONE   guifg=#ffcd8b   guibg=NONE      cterm=NONE   ctermfg=" . <SID>X("73") . "   ctermbg=NONE"
exec "hi String         gui=NONE   guifg=#ffcd8b   guibg=#404040   cterm=NONE   ctermfg=" . <SID>X("73") . "   ctermbg=" . <SID>X(8) . ""
exec "hi Error          gui=NONE   guifg=#ffffff   guibg=#ff0000   cterm=NONE   ctermfg=" . <SID>X("79") . "   ctermbg=" . <SID>X(64) . ""
exec "hi Identifier     gui=NONE   guifg=#ff8bff   guibg=NONE      cterm=NONE   ctermfg=" . <SID>X("71") . "   ctermbg=NONE"
exec "hi Ignore         gui=NONE   guifg=#8b8bcd   guibg=NONE      cterm=NONE   ctermfg=" . <SID>X("38") . "   ctermbg=NONE"
exec "hi Number         gui=NONE   guifg=#506dbd   guibg=NONE      cterm=NONE   ctermfg=" . <SID>X("22") . "   ctermbg=NONE"
exec "hi PreProc        gui=NONE   guifg=#409090   guibg=NONE      cterm=NONE   ctermfg=" . <SID>X("10") . "   ctermbg=NONE"
exec "hi Special        gui=NONE   guifg=#c080d0   guibg=NONE      cterm=NONE   ctermfg=" . <SID>X("39") . "   ctermbg=NONE"
exec "hi Statement      gui=NONE   guifg=#808bed   guibg=NONE      cterm=NONE   ctermfg=" . <SID>X("26") . "   ctermbg=NONE"
exec "hi Todo           gui=BOLD   guifg=#303030   guibg=#c08040   cterm=BOLD   ctermfg=" . <SID>X("08") . "   ctermbg=" . <SID>X(68) . ""
exec "hi Type           gui=NONE   guifg=#ff8bff   guibg=NONE      cterm=NONE   ctermfg=" . <SID>X("71") . "   ctermbg=NONE"
exec "hi Underlined     gui=BOLD   guifg=#ffffcd   guibg=NONE      cterm=BOLD   ctermfg=" . <SID>X("78") . "   ctermbg=NONE"
" }}}
"
" vim: set foldmethod=marker et :
