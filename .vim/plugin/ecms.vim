" $Id: c.vim,v 1.5 2006/09/26 12:20:12 wjding Exp $
" Author: Steven Ding
"
" The file contains general utilities to work with ecms system.
"
" $Log: c.vim,v $
"

if $HOSTNAME == "lsslogin1" || $HOSTNAME == "lsslogin2"

" Function to get the file for local edit
fun! GetFile4Priv()
  let ofile=getreg('%')
  let root=$ROOT
  let oroots=split($VPATH, ':')
  let oroot_prefix=oroots[-1]
  if ( stridx(ofile, oroot_prefix) != 0 )
    return
  endif
  let rpath=substitute(ofile, "^".oroot_prefix, "", "")

  let idx=0
  for oroot in oroots
    if idx == 0
      cont
    endif
    let rfile=oroot . "/" . rpath
    echo rfile
    let idx = idx + 1
  endfor
endf

endif

