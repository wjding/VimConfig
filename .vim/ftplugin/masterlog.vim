" $Id: masterlog.vim,v 1.1 2008-07-22 03:51:34 wjding Exp $
" Author: Steven Ding <wjding@alcatel-lucent.com>
"
" Usage:
"   1. <F9>/<F10> search the next/previous SIP message within
"      the same dialog.
"   2. <F11>/<F12> search the next/previous SIP message within
"      the same transaction.
"   3. \fa : fold all other logs except SIP messages
"      \f5 : fold all other logs except SIP messages printed by FS5000
"      \fn : fold all other logs except SIP messages printed by NGSS
"      \fi : fold all other logs except those belongs to specific IP components
"      \fc : clear all the folders
"
" $Log: masterlog.vim,v $
" Revision 1.1  2008-07-22 03:51:34  wjding
" initial version
"

set <F9>=[20~
set <F10>=[21~
set <F11>=[23~
set <F12>=[24~

set so=4
set foldmethod=manual

let s:logbeginstr = "^+++ "

function! s:debug(str)
"  echo a:str
  return
endfunction

if v:version >= 700
  let b:callid=""
  let b:fromtag=""
  let b:totag=""
  let b:topbranch=""

  " This function returns a list that contains:
  " [callid, fromtag, totag, viabranches]
  " callid, fromtag, totag are strings
  " viabranches is a string list contains the branch values from the top-most
  " Via to the bottom-most Via headers.
  function! GetCCallInfo()
    if col(".") == 1 && getline(".")[col(".")-1] == "+"
      let cMsgLogBegin = line(".")
    else
      let cMsgLogBegin = search(s:logbeginstr, 'bW')
    endif
    let cMsgBegin = search('^[', 'W')
    let cMsgLogEnd = search(s:logbeginstr, 'W') - 1
    let cMsgEnd = search('^.*]$', 'bW')
    call s:debug("cMsgLogBegin: " . cMsgLogBegin . ", cMsgBegin: " . cMsgBegin . ", cMsgEnd: " . cMsgEnd . ", cMsgLogEnd: ". cMsgLogEnd)
    " reset cursor at the beginning of message
    call cursor(cMsgBegin, 1)
    " get call id
    let lnum = search('^Call-ID: ', 'n', cMsgEnd)
    call s:debug("CallID: " . lnum)
    if lnum == 0
      let rlist = ["", "", "", ""]
      return rlist
    endif

    let rlist = matchlist(getline(lnum), '^Call-ID: \(\S\+\)')
    let callid=rlist[1]
    call s:debug("CallID: " . callid)

    " get from tag
    let lnum = search('^From: ', 'n', cMsgEnd)
    call s:debug("From: " . lnum)
    if lnum == 0
      let rlist = ["", "", "", ""]
      return rlist
    endif

    let rlist = matchlist(getline(lnum), '^From: [^<]*<[^>]\+>;tag=\(\S\+\)')
    let fromtag=rlist[1]
    " get to tag
    let lnum = search('^To: ', 'n', cMsgEnd)
    call s:debug("To: " . lnum)
    if lnum == 0
      let rlist = ["", "", "", ""]
      return rlist
    endif
    let rlist = matchlist(getline(lnum), '^To: [^<]*<[^>]\+>\(;tag=\(\S\+\)\)\{0,1}')
    let totag = rlist[2]

    " Get the Via branches
    let lnum = search('^Via: ', 'n', cMsgEnd)
    let rlist = matchlist(getline(lnum), '^Via: .*;branch=\(\S\+\)')
    let topbranch = rlist[1]
    call s:debug("Via branch:")
    call s:debug(topbranch)
    " return
    let rlist = [callid, fromtag, totag, topbranch]
    return rlist
  endfunction

  " dir=n  search downwards
  " dir=N  search upwards
  function! <SID>FindNext(dir)
    let [b:callid, b:fromtag, b:totag, b:topbranch] = GetCCallInfo()
    if b:callid == "" && b:fromtag == ""
      echo "Failed to find messages!"
      return -1
    endif
    let found = 0
    if a:dir == "n"
      let flag = 'W'
    else
      let flag = 'bW'
    endif
    while found != 1
      if !search('^[', flag)
	echo "Failed to find messages!"
	break
      endif
      let [callid, fromtag, totag, topbranch] = GetCCallInfo()
      call s:debug(callid .", ". fromtag .", ". totag)
      if (callid == b:callid && fromtag == b:fromtag && topbranch == b:topbranch)
	let found = 1
      endif
    endwhile
  endfunction
else
  " Vim version < 7.00
  let b:callidentity=""

  " This function returns a list that contains:
  " [callid, fromtag, totag, viabranches]
  " callid, fromtag, totag are strings
  " viabranches is a string list contains the branch values from the top-most
  " Via to the bottom-most Via headers.
  function! GetCCallInfo(testVia)
    if col(".") == 1 && getline(".")[col(".")-1] == "+"
      let cMsgLogBegin = line(".")
    else
      let cMsgLogBegin = search(s:logbeginstr, 'bW')
    endif
    let cMsgBegin = search('^[', 'W')
    let cMsgLogEnd = search(s:logbeginstr, 'W') - 1
    let cMsgEnd = search('^.*]$', 'bW')
    call s:debug("cMsgLogBegin: " . cMsgLogBegin . ", cMsgBegin: " . cMsgBegin . ", cMsgEnd: " . cMsgEnd . ", cMsgLogEnd: ". cMsgLogEnd)
    " reset cursor at the beginning of message
    call cursor(cMsgBegin, 1)
    " get call id
    let lnum = search('^Call-ID: ', '')
    call s:debug("CallID: " . lnum)
    if lnum == 0
      let rc = ""
      return rc
    endif

    let line=getline(lnum)
    let callid=substitute(line, '^Call-ID: \(\S\+\)', '\1', "")
    call s:debug("CallID: " . callid)

    " get from tag
    call cursor(cMsgBegin, 1)
    let lnum = search('^From: ', '')
    call s:debug("From: " . lnum)
    if lnum == 0
      let rc = ""
      return rc
    endif

    let line=getline(lnum)
    let fromtag=substitute(line, '^From: [^<]*<[^>]\+>;tag=\(\S\+\)', '\1', "")
    " get to tag
"    call cursor(cMsgBegin, 1)
"    let lnum = search('^To: ', '')
"    call s:debug("To: " . lnum)
"    if lnum == 0
"      let rc = ""
"      return rc
"    endif
"    let line=getline(lnum)
"    let totag = substitute(line, '^To: [^<]*<[^>]\+>\(;tag=\(\S\+\)\)\{0,1}', '\2', "")

    let rc = callid . ":" . fromtag

    if a:testVia == "y"
      " Get the Via branches
      call cursor(cMsgBegin, 1)
      let lnum = search('^Via: ', '')
      let line=getline(lnum)
      let topbranch = substitute(line, '^Via: .*;branch=\(\S\+\)', '\1', "")
      call s:debug("Via branch:")
      call s:debug(topbranch)
      let rc = rc . topbranch
    endif

    " Reset the cursor
    call cursor(cMsgBegin, 1)
    " return
    return rc
  endfunction

  function! PrintCallInfo()
    let bline = line(".")
    let lnum = search('^CSeq: ', '')
    call cursor(bline, 1)
    call s:debug("CSeq: " . lnum)
    if lnum > 0
      let cseq=substitute(getline(lnum), '^CSeq: \d\+ \(\S\+\)\r', '\1', "")
      let req = cseq
    endif

    echo req
  endfunction

  " dir=n  search downwards
  " dir=N  search upwards
  function! FindNext(dir, testVia)
    let b:callidentity = GetCCallInfo(a:testVia)
    let bline = line(".")
    if b:callidentity == ""
      echo "Failed to find messages!"
      return -1
    endif
    let found = 0
    if a:dir == "n"
      let flag = 'W'
    else
      let flag = 'bW'
    endif
    while found != 1
      if !search('^[', flag)
	echo "Failed to find messages!"
	call cursor(bline, 1)
	break
      endif
      let callidentity = GetCCallInfo(a:testVia)
      call s:debug(callidentity)
      if (callidentity == b:callidentity)
	let found = 1
      endif
    endwhile

    if found == 1
      call PrintCallInfo()
    endif
  endfunction
endif

function! FoldNonSIP(comp)
  let bline = line(".")
  let bcol = col(".")
  call cursor(1,1)

  normal zE
  let logidentity = "^+++ .\\+"
  if a:comp == "NGSS"
    let logidentity = logidentity . " NGSS"
  elseif a:comp == "FS5000"
    let logidentity = logidentity . " FS5000"
  endif

  if a:comp != "ALL"
    let logidentity = logidentity . " [0-9.:]\\+ "
  endif
  call s:debug(logidentity)

  let fbegin = 1
  while 1
    let lnum = search("^[", "W")
    if lnum == 0
      break
    endif
    let fend = search(s:logbeginstr, "bW")
    call s:debug("fbegin, fend: " . fbegin . ", " . fend)
    if match(getline(fend), logidentity) == -1
      " It is SIP log not for desired component
      call cursor(lnum, 1)
      continue
    endif
    let fend = fend - 1
    if fend <= fbegin
      let fbegin = search(s:logbeginstr, "W")
      continue
    endif
    call s:debug("Begin, end: " . fbegin . ", " . fend)
    exe fbegin . "," . fend . " fold"
    let fbegin = search(s:logbeginstr, "W")
  endwhile
  exe fbegin . "," . line("$") . " fold"
  call cursor(bline, bcol)
endfunction

function! FoldNonIP()
  let ip = ""
  let bline = line(".")
  let bcol = col(".")
  if match(getline("."), '^+++ .* \(\d\+\.\d\+\.\d\+\.\d\+\))\s*$') == 0
    let ip = substitute(getline("."), '^+++ .* \(\d\+\.\d\+\.\d\+\.\d\+\))\s*$', '\1', "")
  endif
  call cursor(1,1)

  normal zE

  " Get the IP address
  if ip == ""
    let ip = input("Please input the card IP you would like to keep: ")
    while ip == "" || match(ip, '^\d\+\.\d\+\.\d\+\.\d\+$') < 0
      echo "\nError! Please try again!"
      let ip = input("Please input the card IP you would like to keep: ")
    endwhile
  else
    echo "Filter logs for IP " . ip . "..."
  endif

  let dststr = "^+++ .\\+ " . ip . ")\\s*$"
  call s:debug(dststr)

  let fbegin = 1
  while 1
    let lnum = search(dststr, "W")
    if lnum == 0
      break
    endif
    let fend = lnum - 1
    call s:debug("fbegin, fend: " . fbegin . ", " . fend)
    if fend <= fbegin
      let fbegin = search(s:logbeginstr, "W")
      while match(getline(fbegin), dststr) == 0
"	call s:debug("line " . fbegin . " matches, skip")
	let fbegin = search(s:logbeginstr, "W")
      endwhile
      call s:debug("line " . fbegin . " as fbegin")
      continue
    endif
    call s:debug("Begin, end: " . fbegin . ", " . fend)
    exe fbegin . "," . fend . " fold"
    let fbegin = search(s:logbeginstr, "W")
    while match(getline(fbegin), dststr) == 0
      let fbegin = search(s:logbeginstr, "W")
      if fbegin == 0
	break
      endif
    endwhile
  endwhile
  if fbegin > 0
    exe fbegin . "," . line("$") . " fold"
  endif
  call cursor(bline, bcol)
  echo "Done!"
endfunction

" Mappings
nmap <F9> <Plug>FindNextInDiag
nmap <F10> <Plug>FindPrevInDiag
nmap <F11> <Plug>FindNextInTrans
nmap <F12> <Plug>FindPrevInTrans
nmap <silent> <Plug>FindNextInDiag :call FindNext('n', 'n')<CR>
nmap <silent> <Plug>FindPrevInDiag :call FindNext('N', 'n')<CR>
nmap <silent> <Plug>FindNextInTrans :call FindNext('n', 'y')<CR>
nmap <silent> <Plug>FindPrevInTrans :call FindNext('N', 'y')<CR>
nmap <Leader>f5 <Plug>FS5000SIP
nmap <Leader>fn <Plug>NGSSSIP
nmap <Leader>fa <Plug>ALLSIP
nmap <Leader>fi <Plug>FoldByIP
nmap <Leader>fc <Plug>ClearFolder
nmap <silent> <Plug>FS5000SIP :call FoldNonSIP("FS5000")<CR>
nmap <silent> <Plug>NGSSSIP :call FoldNonSIP("NGSS")<CR>
nmap <silent> <Plug>ALLSIP :call FoldNonSIP("ALL")<CR>
nmap <silent> <Plug>FoldByIP :call FoldNonIP()<CR>
nmap <silent> <Plug>ClearFolder zE

" Colors
hi Headers term=bold ctermfg=2
mat Headers /\(^Route: \)\@<=.*\|\(^Contact: \)\@<=.*/
