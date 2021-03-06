" $Id: masterlog.vim,v 1.1.2.14 2015-03-04 15:32:19 wjding Exp $
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
"      g/  : search forward within the specified component
"      g?  : search backward within the specified component
"      n   : redo search forward
"      N   : redo search backward
"
" $Log: masterlog.vim,v $
" Revision 1.1.2.14  2015-03-04 15:32:19  wjding
" Added FoldNonSUBNUM
"
" Revision 1.1.2.13  2009-03-13 04:45:40  wjding
" Changed StatusLine color
"
" Revision 1.1.2.12  2009-03-13 03:14:38  wjding
" Added change history
"
" Revision 1.1.2.11  2009-03-13 02:50:55  wjding
" Modified the Folded syntax display
"
" Revision 1.1.2.10  2009-03-13 02:09:15  wjding
" Support compact SIP headers.
"
" Revision 1.1.2.9  2009-03-12 08:56:01  wjding
" Format change, delete the commented unused code.
"
" Revision 1.1.2.8  2009-03-12 08:54:15  wjding
" There are 2 fixes in this version:
" 1. Fix the bug that failed to match the headers when there is no space after
"    header string, such as "Call-ID:LU....", etc.
" 2. Fix the bug can't match when several Via: headers are merged to one line.
"
" Revision 1.1.2.7  2009-03-12 08:49:53  wjding
" Fix the bug to include \r or \n in the Call-ID, etc. This caused failure to
" find the correct message sometimes.
"
" Revision 1.1.2.6  2008-07-24 10:05:17  wjding
" Re-format the code
"
" Revision 1.1.2.5  2008-07-24 07:30:50  wjding
" Disable Vim 7.0 part and enhance to get IP from current log entry
"
" Revision 1.1.2.4  2008-07-23 07:43:29  wjding
" Fix issue that wrong Via branch is got sometimes.
"
" Revision 1.1.2.3  2008-07-23 05:24:52  wjding
" Added function prologue
"
" Revision 1.1.2.2  2008-07-23 05:03:01  wjding
" Add search functionality and little enhancements
"
" Revision 1.1.2.1  2008-07-22 09:03:21  wjding
" Fix the issue that matches a partial message
"
" Revision 1.1  2008-07-22 03:51:34  wjding
" initial version
"

" Define function key mapping
set <F9>=[20~
set <F10>=[21~
set <F11>=[23~
set <F12>=[24~

set so=4
set foldmethod=manual

" Initialize local variables
let b:targetstr = ""
let b:comp_ip = ""
let b:debug = 0

" Initialize script variables
let s:logbeginstr = "^+++ "

" Debug function
" str : String to print
"
" if b:debug is set to 1, str will be printed. 
function! s:debug(str)
  if b:debug == 1
    echo a:str
  endif
  return
endfunction

" This function determines whether the current log is useful according to
" the current fold settings. If the current log entry is in the fold, it
" will be skipped. 
"
" Parameters: none
" Returns:  1 - if the cursor located in a log entry which is not folded.
"           0 - if the cursor located in a log entry which is folded.
"
function! IsDesiredLog()
  if exists("b:targetstr") == 0 || b:targetstr == ""
    return 1
  endif

  " save the cursor location
  let ccol = col(".")
  let cline = line(".")

  let linetxt = getline(cline)
  call s:debug("line/col: " . cline . "/" . ccol . ", " . linetxt)
  if ccol == 1 && linetxt =~ "^+++ "
    let beginLogLine = cline
  else
    let beginLogLine = search(s:logbeginstr, "bW")
    " reset the cursor
    call cursor(cline, ccol)
    if beginLogLine == 0
      " TODO: how to deal?
      return
    endif
  endif

  let linetxt = getline(beginLogLine)
  call s:debug("line: " . beginLogLine . ", " . linetxt)
  if linetxt =~ b:targetstr
    return 1
  else
    return 0
  endif
endfunction

" This function will print related information of the current SIP message to
" screen.
"
" Parameters: none
" Returns:    none
"
function! PrintCallInfo()
  let bline = line(".")
  let lnum = search('^CSeq:', '')
  call cursor(bline, 1)
  call s:debug("CSeq: " . lnum)
  if lnum > 0
    let cseq=substitute(getline(lnum), '^CSeq: \?\d\+ \(\S\+\)\r', '\1', "")
    let req = cseq
  endif

  echo req
endfunction

" Vim version < 7.00
"
" Use buffer variable callidentity to store callid, fromtag and via.
let b:callidentity=""

" This function returns a string that contains:
"   callid:fromtag:viabranches
" Parameters: testVia - y : check the top Via branch
"                     - n : ignore the top Via branch
" Returns:    string
function! GetCCallInfo(testVia)
  call s:debug("Current Line: " . line("."))
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
  let lnum = search('^Call-ID:\|^i:', '')
  call s:debug("CallID lineno: " . lnum)
  if lnum == 0 || lnum > cMsgEnd
    call cursor(cMsgEnd, 1)
    let rc = ""
    return rc
  endif

  let line=getline(lnum)
  let callid=substitute(line, '^\(Call-ID\|i\): \?\([^ ;\r\n]\+\).*', '\2', "")
  call s:debug("CallID: " . callid)

  " get from tag
  call cursor(cMsgBegin, 1)
  let lnum = search('^From:\|^f:', '')
  if lnum == 0 || lnum > cMsgEnd
    call cursor(cMsgEnd, 1)
    let rc = ""
    return rc
  endif

  let line=getline(lnum)
  let fromtag=substitute(line, '^\(From\|f\): \?[^<]*<[^>]\+>;tag=\([^ ;\r\n]\+\).*', '\2', "")
  call s:debug("From tag: " . fromtag)
  " get to tag
"  call cursor(cMsgBegin, 1)
"  let lnum = search('^To: ', '')
"  call s:debug("To: " . lnum)
"  if lnum == 0
"    let rc = ""
"    return rc
"  endif
"  let line=getline(lnum)
"  let totag = substitute(line, '^To: [^<]*<[^>]\+>\(;tag=\([^ ;]\+\)\)\{0,1}.*', '\2', "")

  let rc = callid . ":" . fromtag

  if a:testVia == "y"
    " Get the Via branches
    call cursor(cMsgBegin, 1)
    let lnum = search('^Via:\|^v:', '')
    if lnum == 0 || lnum > cMsgEnd
      call cursor(cMsgEnd, 1)
      return rc
    endif
    let line=getline(lnum)
    let topbranch = substitute(line, '^\(Via\|v\):.\{-};branch=\([^ ,;\r\n]\+\).*', '\2', "")
    call s:debug("Via branch:")
    call s:debug(topbranch)
    let rc = rc . ":" . topbranch
    call s:debug("RC: " . rc)
  endif

  " Reset the cursor
  call cursor(cMsgBegin, 1)
  " return
  return rc
endfunction

" The function will find the next SIP message within current
" call/transaction.
"
" Parameters: dir     - n (downwards) or N (upwards)
"             testVia - y (transaction) or n (call)
" Returns:    none
"
function! FindNext(dir, testVia)
  let bline = line(".")
  let b:callidentity = GetCCallInfo(a:testVia)
  if b:callidentity == ""
    echo "Failed to find messages!"
    return -1
  endif
  call s:debug("b:callidentity: \n" . b:callidentity)
  let found = 0
  if a:dir == "n"
    let flag = 'W'
  else
    let flag = 'bW'
  endif
  while found != 1
    let cline = search('^[', flag)
    if cline == 0
      echo "Failed to find messages!"
      call cursor(bline, 1)
      break
    endif

    if IsDesiredLog() != 1
      continue
    endif

    let callidentity = GetCCallInfo(a:testVia)
    call s:debug("Callidentity: \n" . callidentity)
    if (callidentity == b:callidentity)
      let found = 1
    endif
    call cursor(cline, 1)
  endwhile

  if found == 1
    call PrintCallInfo()
  endif
endfunction

" The function will fold all other log entries except the specified SIP log.
"
" Parameters: comp - component that we care, FS5000, NGSS or ALL
" Returns:    none
"
function! FoldNonSIP(comp)
  let bline = line(".")
  let bcol = col(".")
  call cursor(1,1)

  normal zE
  let targetstr = "^+++ .\\+"
  if a:comp == "NGSS"
    let targetstr = targetstr . " NGSS"
  elseif a:comp == "FS5000"
    let targetstr = targetstr . " FS5000"
  endif

  if a:comp != "ALL"
    let targetstr = targetstr . " [0-9.:]\\+ "
  endif

  let b:targetstr = targetstr
  call s:debug(targetstr)

  let fbegin = 1
  while 1
    let lnum = search("^[", "W")
    if lnum == 0
      break
    endif
    let fend = search(s:logbeginstr, "bW")
    call s:debug("fbegin, fend: " . fbegin . ", " . fend)
    if match(getline(fend), targetstr) == -1
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

" The function will fold all other log entries except log from the specified
" IP address.
"
" It will get the IP address from the line the cursor resides and if failed,
" it will prompt for a component IP.
"
" Parameters: none
" Returns:    none
"
function! FoldNonIP()
  let ip = ""
  let bline = line(".")
  let bcol = col(".")
  let lnum=search('^+++ ', "bW")
  if lnum > 0 && match(getline(lnum), '^+++ .* \(\d\+\.\d\+\.\d\+\.\d\+\))\s*$') == 0
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

  let targetstr = "^+++ .\\+ " . ip . ")\\s*$"
  let b:comp_ip = ip
  let b:targetstr = targetstr
  call s:debug(targetstr)

  let fbegin = 1
  while 1
    let lnum = search(targetstr, "W")
    if lnum == 0
      break
    endif
    let fend = lnum - 1
    call s:debug("fbegin, fend: " . fbegin . ", " . fend)
    if fend <= fbegin
      let fbegin = search(s:logbeginstr, "W")
      while match(getline(fbegin), targetstr) == 0
        "	call s:debug("line " . fbegin . " matches, skip")
        let fbegin = search(s:logbeginstr, "W")
      endwhile
      call s:debug("line " . fbegin . " as fbegin")
      continue
    endif
    call s:debug("Begin, end: " . fbegin . ", " . fend)
    exe fbegin . "," . fend . " fold"
    let fbegin = search(s:logbeginstr, "W")
    while match(getline(fbegin), targetstr) == 0
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

" The function will fold all other log entries except log for a specified
" SUB_NUM.
"
" It will get the SUB_NUM the line the cursor resides and if failed, it will
" prompt for one.
"
" TODO: Not finished.
"
" Parameters: none
" Returns:    none
"
function! FoldNonSUBNUM()
  let subnum = ""
  let bline = line(".")
  let bcol = col(".")
  if match(getline("."), '^\(B2BC\|NGFS\):(SUBNUM=\(\d\+\)) ') == 0
    let subnum = substitute(getline("."), '^\(B2BC\|NGFS\):(SUBNUM=\(\d\+\)) ', '\2', "")
  endif
  call cursor(1,1)

  " Delete the folders
  normal zE

  " Get the SUB_NUM if it isn't got
  if subnum == ""
    let subnum = input("Please input the SUB_NUM you would like to keep: ")
    while subnum == "" || match(subnum, '^\d\+$') < 0
      echo "\nError! Please try again!"
      let subnum = input("Please input the card IP you would like to keep: ")
    endwhile
  else
    echo "Filter logs for SUB_NUM " . subnum . "..."
  endif

  let targetstr = "^+++ .\\+ " . subnum . ")\\s*$"
  " TODO: How to set the buffer targetstr?
  "let b:targetstr = targetstr
  call s:debug(targetstr)

  " need re-write...
  let fbegin = 1
  while 1
    let lnum = search(targetstr, "W")
    if lnum == 0
      break
    endif
    let fend = lnum - 2
    call s:debug("fbegin, fend: " . fbegin . ", " . fend)
    if fend <= fbegin
      let fbegin = search(s:logbeginstr, "W")
      while match(getline(fbegin), targetstr) == 0
        "	call s:debug("line " . fbegin . " matches, skip")
        let fbegin = search(s:logbeginstr, "W")
      endwhile
      call s:debug("line " . fbegin . " as fbegin")
      continue
    endif
    call s:debug("Begin, end: " . fbegin . ", " . fend)
    exe fbegin . "," . fend . " fold"
    let fbegin = search(s:logbeginstr, "W")
    while match(getline(fbegin), targetstr) == 0
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

" The function will delete all the folders in the current buffer.
"
" Parameters: none
" Returns:    none
"
function! ClearFolder()
  normal zE
  let b:targetstr = ""
  let b:comp_ip = ""
endfunction

" CompSearch will only search for the component we cares (not folded). If no
" fold is defined, it will perform a normal search.
"
" Parameters: direction - "" (forward) or "b" (backward)
" Returns:    none
function! CompSearch(direction)
  " save the cursor
  let bcol = col(".")
  let bline = line(".")

  let smode = "W"
  let prompt = "/"
  if a:direction == "b"
    let smode = smode . "b"
    let prompt = "?"
  endif

  let search_txt = input(prompt)
  if search_txt == "" || search_txt == "/"
    let search_txt = getreg("/")
  else
    call setreg("/", search_txt)
  endif

  if exists("b:targetstr") == 0 || b:targetstr == ""
    return search(search_txt, smode)
  endif

  while 1
    let lnum = search(search_txt, smode)
    if lnum == 0
      echo "E486: Pattern not found: " . search_txt
      call cursor(bline, bcol)
      return
    endif

    if IsDesiredLog() == 1
      break
    endif
  endwhile
endfunction

" The function will repeat the search for the component we cares.
"
" Parameters: direction - "n" (forward) or "N" (backward)
" Returns:    none
function! CompSearchNextPrev(direction)
  if exists("b:targetstr") == 0 || b:targetstr == ""
    echo "Normal search"
    if a:direction == "n"
      normal! n
    else
      normal! N
    endif
    return
  endif

  if a:direction == "n"
    normal g/<CR>
    return
  endif

  if a:direction == "N"
    normal g?<CR>
    return
  endif
endfunction

" Mappings
"nmap <buffer> <F9> <Plug>FindNextInDiag
"nmap <buffer> <F10> <Plug>FindPrevInDiag
"nmap <buffer> <F11> <Plug>FindNextInTrans
"nmap <buffer> <F12> <Plug>FindPrevInTrans
nmap <silent> <Plug>FindNextInDiag :call FindNext('n', 'n')<CR>
nmap <silent> <Plug>FindPrevInDiag :call FindNext('N', 'n')<CR>
nmap <silent> <Plug>FindNextInTrans :call FindNext('n', 'y')<CR>
nmap <silent> <Plug>FindPrevInTrans :call FindNext('N', 'y')<CR>
nmap <buffer> <Leader>f5 <Plug>FS5000SIP
nmap <buffer> <Leader>fn <Plug>NGSSSIP
nmap <buffer> <Leader>fa <Plug>ALLSIP
nmap <buffer> <Leader>fi <Plug>FoldByIP
nmap <buffer> <Leader>fc <Plug>ClearFolder
nmap <buffer> g/ <Plug>CompSearchForward
nmap <buffer> g? <Plug>CompSearchBackward
nmap <buffer> n <Plug>CompSearchNext
nmap <buffer> N <Plug>CompSearchPrev
nmap <silent> <Plug>FS5000SIP :call FoldNonSIP("FS5000")<CR>
nmap <silent> <Plug>NGSSSIP :call FoldNonSIP("NGSS")<CR>
nmap <silent> <Plug>ALLSIP :call FoldNonSIP("ALL")<CR>
nmap <silent> <Plug>FoldByIP :call FoldNonIP()<CR>
nmap <silent> <Plug>ClearFolder :call ClearFolder()<CR>
nmap <silent> <Plug>CompSearchForward :call CompSearch("")<CR>
nmap <silent> <Plug>CompSearchBackward :call CompSearch("b")<CR>
nmap <silent> <Plug>CompSearchNext :call CompSearchNextPrev("n")<CR>
nmap <silent> <Plug>CompSearchPrev :call CompSearchNextPrev("N")<CR>

" Colors
hi Headers term=bold cterm=bold ctermfg=2
mat Headers /\(^Route:\)\@<=.*\|\(^Contact:\|^m:\)\@<=.*\|\(^Event:\|^o:\)\@<=.*/
hi SessID term=bold cterm=bold ctermfg=3
2match SessID /^Session-ID:.*/
hi Folded ctermbg=4 ctermfg=7
hi StatusLine term=standout cterm=bold,standout ctermfg=4 ctermbg=6

" vim: sw=2
