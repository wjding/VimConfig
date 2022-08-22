" $Id: c.vim,v 1.10 2015-06-25 07:59:14 wjding Exp $
" Author: Steven Ding
"
" $Log: c.vim,v $
" Revision 1.10  2015-06-25 07:59:14  wjding
" 1. Updated the maximum line length hilight.
" 2. Added mappings to search for next or previous "case" in a switch.
"
" Revision 1.9  2015-02-15 08:27:54  wjding
" Updated on lsslogin.
"
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
set path=.,/usr/include,/usr/include/*,/usr/include/*/*,~/isos/include/*/*
set tags+=$ROOT/tags,~/work/tags

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
    set nocscopeverbose
    if hostname() == "lsslogin1" || hostname() == "lsslogin2"
        set csprg=/opt/exp/bin/cscope
        set csto=1
        set cst
        set nocsverb

        exec "cs add ".$ROOT."/cscope.out ".$ROOT

        let paths = substitute($VPATH, "[^:]*:", "", "")
        for path in split(paths, ':')
            let ssppath = path.'/'."ssp/cscope.out"
            let sdepath = path.'/'."sde/cscope.out"
            let csppath = path.'/'."csp/cscope.out"
            let globpath = path.'/'."glob/cscope.out"
            let ospath = path.'/'."os/cscope.out"
            exec "cs add ".ssppath." ".path
            exec "cs add ".sdepath." ".path
            exec "cs add ".csppath." ".path
            exec "cs add ".globpath." ".path
            exec "cs add ".ospath." ".path
        endfor

        exec "cs add /home/cssadm/css_ofc/C214.01/css/cscope.out /home/cssadm/css_ofc/C214.01"
    endif
    " add any database in current directory
    if filereadable($ROOT . "/cscope.out")
        exec "cs add " . $ROOT . "/cscope.out"
    endif
    if filereadable("cscope.out")
        cs add cscope.out
        " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    map g<C-]> :cs find c <C-R>=expand("<cword>")<CR><CR>
    map g<C-a> :cs find t <C-R>=expand("<cword>")<CR><CR>
    map g<C-i> :cs find s <C-R>=expand("<cword>")<CR><CR>
    map <F2> :!buildcs<CR><CR>:cs reset<CR><CR>
    set csverb
endif

function! FindNextSwitchcase()
	let cw = expand("<cword>")
	let [lnum, cnum] = searchpos(cw, "bcn")
	let search_str = '\%\' . cnum . 'c' . '\(\<case\>\|\<default\>\)'
	echo search_str
	call search(search_str, "W")
	let @/ = search_str
endfunction
function! FindPreSwitchcase()
	let cw = expand("<cword>")
	let [lnum, cnum] = searchpos(cw, "bcn")
	call cursor(lnum, cnum - 2 )
	let search_str = '\%\' . cnum . 'c' . '\(\<case\>\|\<default\>\)'
	call search(search_str, "bW")
	let @/ = search_str
endfunction
map g* :call FindNextSwitchcase()<CR>
map g# :call FindPreSwitchcase()<CR>

" Highlight the line length > 80
hi CodeWidth       ctermbg=235
mat CodeWidth      /\%120v/
