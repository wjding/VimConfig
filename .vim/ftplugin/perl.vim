" $Id: c.vim,v 1.8 2008-07-22 05:23:54 wjding Exp $
" Author: Steven Ding
"
" $Log: c.vim,v $

set statusline=%<%f%h%m%r%=%{strlen(getline(line('.')))}\ %l,%c\ %V\ \ \ \ \ \ \ %P

"""""""""""""""""""""""""""""""""
" For C programs
set ai
set cin
set showmatch
set cino=>1s:0
set ts=8
set sts=8
set sw=4
set formatoptions+=lro
set tw=78
set noexpandtab
set cpoptions=aABceFs

"compiler gcc

map <F2> :w<CR>

map <F7> :tn<CR>
map <F8> :tN<CR>
map <S-F7> :cn<CR>
map <S-F8> :cN<CR>

" Highlight the line length > 80
hi CodeWidth       ctermbg=235
mat CodeWidth      /\%80v/

