" $Id: c.vim,v 1.8 2008-07-22 05:23:54 wjding Exp $
" Author: Steven Ding
"
" $Log: c.vim,v $
" Revision 1.8  2008-07-22 05:23:54  wjding
" Move C code highlight from color file to c.vim
"
" Revision 1.7  2007-06-24 06:43:48  wjding
" Added hostname check to load cscope DB.
" For hostname lsslogin1, added support for multiple VPATH for cscope DBs.
"
" Revision 1.6  2007/03/02 05:29:17  wjding
" add support for PE environment
"
" Revision 1.5  2006/09/26 12:20:12  wjding
" Initial script for lsslogin1, FS5K development. Changed tag file, and added
" several maps.
"
" Revision 1.4  2005/01/05 06:02:10  wjding
" Add "set noexpandtab".
"
" Revision 1.3  2004/12/05 07:57:16  wjding
" Remove expandtab and softtab settings. Remove "gcc" compiler support.
"

set statusline=%<%f%h%m%r%=%{strlen(getline(line('.')))}\ %l,%c\ %V\ \ \ \ \ \ \ %P

" For Linux kernel
set path+=/home/wjding/work/linux/4.19.56/include

cs add /home/wjding/work/linux/4.19.56/cscope.out /home/wjding/work/linux/4.19.56

"""""""""""""""""""""""""""""""""
" For C programs
"set ai cin sts=4 expandtab showmatch cino=>4 sw=4 formatoptions+=lro tw=78
set ai
set cin
set showmatch
set cino=>1s:0
set ts=8
set sts=8
set sw=8
set formatoptions+=lro
set tw=78
set noexpandtab
set cpoptions=aABceFs
set path=.,/usr/include,/usr/include/*,/usr/include/*/*
"set path+=~/src/linux-3.14.58/include,~/src/linux-3.14.58/include/*
set tags+=~/work/tags

if exists("$ROOT")
    set path+=$ROOT/include,$ROOT/include/*
    set tags+=$ROOT/tags
endif

"compiler gcc

map <F2> :w<CR>

map <F7> :tn<CR>
map <F8> :tN<CR>
map <S-F7> :cn<CR>
map <S-F8> :cN<CR>

"map <S-F9> :make<CR>
"syntax on
"
if has("cscope")
    set csto=1
    set cst
    set nocsverb
    if hostname() == "lsslogin1"
"        set csprg=/opt/exp/bin/cscope

        exec "cs add ".$ROOT."/cscope.out ".$ROOT

"        let paths = substitute($VPATH, "[^:]*:", "", "")
"        for path in split(paths, ':')
"            let ssppath = path.'/'."ssp/cscope.out"
"            let sdepath = path.'/'."sde/cscope.out"
"            let csppath = path.'/'."csp/cscope.out"
"            exec "cs add ".ssppath." ".path
"            exec "cs add ".sdepath." ".path
"            exec "cs add ".csppath." ".path
"        endfor

"        exec "cs add /home/cssadm/css_ofc/C214.01/css/cscope.out /home/cssadm/css_ofc/C214.01"
    endif
    " add any database in current directory
	if exists("$ROOT")
        exec "cs add ".$ROOT."/cscope.out ".$ROOT
	endif
    if filereadable("cscope.out")
        exec "cs add cscope.out " . getcwd()
        " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    map g<C-]> :cs find c <C-R>=expand("<cword>")<CR><CR>
    map g<C-a> :cs find t <C-R>=expand("<cword>")<CR><CR>
    map g<C-i> :cs find s <C-R>=expand("<cword>")<CR><CR>
    map <F2> :!buildcs<CR><CR>:cs reset<CR><CR>
    set nocsverb
endif

" Highlight the line length > 80
hi CodeWidth       ctermbg=235
mat CodeWidth      /\%80v/
