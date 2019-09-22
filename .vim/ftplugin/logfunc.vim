" Vim function file for system.log and debug.log
" $Id: logfunc.vim,v 1.1 2005/02/11 06:04:29 wjding Exp $
"
" Maintainer:	Steven Ding (wjding@lucent.com)
"
" $Log: logfunc.vim,v $
" Revision 1.1  2005/02/11 06:04:29  wjding
" Initialize and add a function Spnchn.
"
"

function! Spnchn(trunk)
        let l:spn = a:trunk/32+1
        let l:chn = a:trunk%32+1
        echo "SPN: ".l:spn." CHN: ".l:chn
endfunction

nmap gs :call Spnchn(<C-R>=expand("<cword>")<CR>)<CR>

