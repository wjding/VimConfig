" Vim compiler file
" Compiler:	HP_UX cc
" Maintainer:	Steven Ding (wjding@szapsoft.com)
" Last Change:	2003 Jun. 13

if exists("current_compiler")
  finish
endif
let current_compiler = "cc"

" The errorformat for MSVC is the default.
"setlocal errorformat=Error\ %n:\ \"%f\"%*[^0-9]%l\ %m
setlocal errorformat=(Bundled)\ cc:\ \"%f\"%*[^0-9]%l:%m
setlocal makeprg=make

