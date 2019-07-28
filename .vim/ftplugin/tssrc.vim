"                                                        vim:sw=2 
"                                                        vim600:fdm=marker
" $Id: tssrc.vim,v 1.5 2006/06/05 10:02:15 wjding Exp $ 
" Script for TestScript generation by Steven Ding.
"
" Test script initial format:
""BEGIN:: 1
""<title>
""<description>
""
""Case 1[: <abstract>]
""------
""<description>
""R2.1_........
""0
"
" $Log: tssrc.vim,v $
" Revision 1.5  2006/06/05 10:02:15  wjding
" Clean indentexpr to avoid xml identing.
"
" Revision 1.4  2006/04/24 03:00:07  wjding
" Add noic config
"
" Revision 1.3  2006/02/08 05:56:28  wjding
" Add ts file format description.
"
" Revision 1.2  2006/02/05 05:26:58  wjding
" Modify tmsloaded as a buffer variable.
"
" Revision 1.1  2006/01/16 03:01:15  wjding
" Rename ts.vim to tssrc.vim
"
" Revision 1.1  2006/01/16 02:54:22  wjding
" Initial Version
"
"
let b:tmsloaded = 1

" global settings: {{{1
set formatoptions+=vn
set tw=72 noic
set indentexpr=

" NewCaseNo() Insert a "Case no" and renumber all the left cases. {{{1
function! NewCaseNo(getTitle)
  " Save the current cursor
  let line = line(".")
  let col = col(".")
  " Get the line number of last test and next test and last case
  let pTestLineNo = search("^BEGIN:: \\?", "bW")
  call cursor(line, col)
  let nTestLineNo = search("^BEGIN:: \\?", "W")
  call cursor(line, col)
  let matchedlineNo = search("^Case \\d\\+", "bW")
  call cursor(line, col)
  call RenumberCaseNo()

  if matchedlineNo > pTestLineNo
    let caseno = substitute(getline(matchedlineNo), "Case \\(\\d\\+\\)", "\\=submatch(1)", "")
  else
    let caseno = 0
  endif

  if caseno == ""
    let caseno = 1
  else
    let caseno = caseno + 1
  endif

  let str="Case " . caseno
  if a:getTitle
    let title=input("Please input the case title: ")
    let str = str . ": " . title
  endif
  if caseno > 9
    let str = str . "-------"
  else
    let str = str . "------"
  endif

  call cursor(line, col)

  exec ":norm! i" . str
  exec ":startinsert"
  let caseno = caseno + 1
endfun

" RenumberCaseNo() Renumber all the left cases. {{{1
function! RenumberCaseNo()
  let line = line(".")
  let col = col(".")
  " Get the line number of last test and next test and last case
  let nTestLineNo = search("^BEGIN:: \\?", "W")
  call cursor(line, col)
  let matchedlineNo = search("^Case \\d\\+", "bW")

  call cursor(line, col)
  let curline = search("^Case ", "W")

  if nTestLineNo == 0
    while curline != 0
      call UpdateCaseNo(curline)
      let curline = search("^Case ", "W")
    endwhile
  else
    while curline != 0 && curline < nTestLineNo
      call UpdateCaseNo(curline)
      let curline = search("^Case ", "W")
    endwhile
  endif
  call cursor(line, col)
endfun

" UpdateCaseNo() Add 1 to the Case no where curline pionts to. {{{1
function! UpdateCaseNo(curline)
  if getline(a:curline + 1) !~ "-------*"
    return
  endif
  let matchedline = getline(a:curline)
  let matchedline = substitute(matchedline, "\\(\\d\\+\\)", "\\=submatch(1) + 1", "")
  call setline(a:curline, matchedline)
endfun

" NewItemNo() Insert a "BEGIN::" and renumber all the left test items. {{{1
function! NewItemNo()
  let line = line(".")
  let col = col(".")
  let matchedline = getline(search("^BEGIN:: \\?", "bW"))

  let testno = substitute(matchedline, "BEGIN:: \\?\\(\\d\\+\\)", "\\=submatch(1)", "")
  if testno == ""
    let testno = 1
  else
    let testno = testno + 1
  endif
  
  let str="BEGIN:: " . testno
  call cursor(line, col)
  exec ":norm! i". str .""
  call RenumberItemNo()
  exec ":startinsert"
endfun

" RenumberItemNo() Renumber all the left cases. {{{1
function! RenumberItemNo()
  let line = line(".")
  let col = col(".")
"  call cursor(1, 1)

  let curline = search("^BEGIN::", "W")

  while curline != 0
    let matchedline = getline(curline)
    let matchedline = substitute(matchedline, "\\(\\d\\+\\)", "\\=submatch(1) + 1", "")
    call setline(curline, matchedline)
    let curline = search("^BEGIN:: \\?", "W")
  endwhile

  call cursor(line, col)
endfun

" Format() Format the file for FS5K-convert.pl. {{{1
function! Format()
  let reg_a = getreg('a')
  let reg_b = getreg('b')
  let user = input("Originator: ")
  let group = input("Group: ")
  let phase = input("Phase: ")
  let prefix = input("Title prefix: ")

  let choice = confirm("Set name: ", "&DT\n&FT\n&ST", 2, "Question")
  if choice == 0
    let setname = "ft"
  elseif choice == 1
    let setname = "dt"
  elseif choice == 2
    let setname = "ft"
  elseif choice == 3
    let setname = "st"
  endif
  call setreg('a', "\n\nBEGIN::")
  exec "silent $put a"
  exec "%s/\\(^Case \\)\\(\\d\\+\\)\\(.*\\n\\(.*\\n\\)\\{,2\\}-----.*\\n\\(\\(Case \\)\\@!.*\\n\\)*\\)\\d\\(\\n\\n\\n\\n*BEGIN::\\)/\\1\\2\\3\\2\\7/"
  exec "silent $-2,$d"
"  let user = "s.ding"
"  let group = "s.ding"
"  let phase = "s.ding"
"  let prefix = "s.ding"
  let line1 = line(".")
  let col1 = col(".")
  exec "normal H"
  let line2 = line(".")
  let col2 = col(".")
  call setreg('a', "")
  exec "silent 0put a"
  goto
  let currentline=search("^BEGIN::", "W")
  while currentline > 0
    let reqline=search("^\\(R2.1_\\)\\|\\(R-IMPLICIT\\)", "W")
    let endline=search("^\\d\\+$", "W")
    exec "silent " . reqline . "," . endline . " mo " . currentline
    call setreg('a', "aa0000\n")
    exec "silent normal \"aPj"
    call setreg('a', "Title=" . prefix . "::\n")
    exec "silent normal \"apj"
    call setreg('a', "\nProc=\n")
    exec "silent normal \"ap"
    call setreg('a', "\nsetname=" . setname . "\nLocation=SYSLAB\nOrig=" . user . "\nPhase=" . phase . "\nGroup=" . group)
    exec "silent " . (endline + 4) . " put a"
    let currentline=search("^BEGIN::", "W")
  endwhile
  goto
  exec "silent g/^BEGIN::/d"
  exec "silent 1d"
  call cursor(line2, col2)
  exec "normal z"
  call cursor(line1, col1)
  call setreg('a', reg_a)
  call setreg('b', reg_b)
endfun

" Hotkey Mappings {{{1
noremap <F7> :call NewCaseNo(1)<CR>
noremap <F8> :call NewCaseNo(0)<CR>
noremap <S-F8> :call NewItemNo()<CR>
noremap \fmt :call Format()<CR>

inoremap <F7> <ESC>:call NewCaseNo(1)<CR>
inoremap <F8> <ESC>:call NewCaseNo(0)<CR>
inoremap <S-F8> <ESC>:call NewItemNo()<CR>
" }}}

