" $Id: go.vim$
" Author: Steven Ding
"
" $Log: go.vim,v $
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
