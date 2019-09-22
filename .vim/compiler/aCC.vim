" Vim compiler file
" Compiler:	HP_UX aCC
" Maintainer:	Steven Ding (wjding@szapsoft.com)
" Last Change:	2003 Apr. 23

if exists("current_compiler")
  finish
endif
let current_compiler = "aCC"

" The errorformat for MSVC is the default.
"setlocal errorformat=Error\ %n:\ \"%f\"%*[^0-9]%l\ %m
setlocal errorformat=%AError\ %n:\ \"%f\"%*[^0-9]%l\ %#\ %m,%-Z%p^%*[%^\ ],%-C%.%#
setlocal makeprg=make
