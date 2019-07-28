" Vim color file
" Name:       my256.vim
" Maintainer: Steven Ding
" This should work in the xterm-256 mode. It won't work in 8/16 colour terminals.

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let colors_name = "wjding256"

" {{{
hi SpecialKey      term=bold cterm=bold ctermfg=139
hi NonText         term=bold cterm=bold ctermfg=61
hi Directory       term=bold ctermfg=47
hi ErrorMsg        term=standout cterm=bold ctermfg=231 ctermbg=196
hi IncSearch       term=reverse cterm=bold ctermfg=232 ctermbg=215
hi Search          term=reverse ctermfg=232 ctermbg=215
hi MoreMsg         term=bold cterm=bold ctermfg=63
hi ModeMsg         term=NONE cterm=NONE ctermfg=63
hi LineNr          term=underline ctermfg=61 ctermbg=232
hi Question        term=standout cterm=bold ctermfg=214
hi StatusLine      term=bold,reverse cterm=bold ctermfg=17 ctermbg=250
hi StatusLineNC    term=reverse cterm=NONE ctermfg=235 ctermbg=245
hi VertSplit       term=reverse ctermfg=244 ctermbg=238
hi Title           term=bold cterm=bold ctermfg=130 ctermbg=232
hi Visual          term=reverse ctermfg=130 ctermbg=229
hi VisualNOS       term=bold,underline cterm=bold,underline
hi WarningMsg      term=standout cterm=bold ctermfg=231 ctermbg=202
hi WildMenu        term=standout cterm=bold ctermfg=214 ctermbg=232
hi Folded          term=standout ctermfg=229 ctermbg=57
hi FoldColumn      term=standout ctermfg=61 ctermbg=232
hi DiffAdd         ctermfg=250 ctermbg=21
hi DiffChange      ctermfg=250 ctermbg=126
hi DiffDelete      ctermfg=250 ctermbg=67
hi DiffText        term=reverse ctermfg=229 ctermbg=196
hi SignColumn      term=standout ctermfg=14 ctermbg=242
hi Normal          ctermfg=245 ctermbg=232
"hi Comment         term=bold ctermfg=21
hi Comment         ctermfg=69
hi Constant        term=underline ctermfg=215
hi Special         term=bold ctermfg=63
hi Identifier      term=none cterm=none ctermfg=207
hi Statement       term=bold ctermfg=37
hi PreProc         term=underline ctermfg=128
hi Type            term=underline ctermfg=207
hi Underlined      term=underline cterm=bold ctermfg=229
hi Ignore          ctermfg=61
hi Error           term=reverse ctermfg=231 ctermbg=196
hi Todo            term=standout cterm=bold ctermfg=52 ctermbg=190
hi String          ctermfg=196 ctermbg=0
hi Number          ctermfg=37
hi Cursor          term=standout ctermfg=230 ctermbg=255
hi lCursor         term=standout ctermfg=230 ctermbg=255
hi CursorIM        term=standout ctermfg=230 ctermbg=255
hi Pmenu           ctermfg=237 ctermbg=242
hi PmenuSel        ctermfg=237 ctermbg=245
hi PmenuSbar       ctermbg=239
hi PmenuThumb      cterm=reverse
hi CodeWidth       ctermbg=235
hi MatchParen      term=reverse ctermbg=239

" }}}

" {{{
" }}}

" vim: set foldmethod=marker et :
