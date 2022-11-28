" $Id: .vimrc,v 1.17 2015-03-04 15:14:42 wjding Exp $
" Maintainer: Steven Ding <wjding@alcatel-lucent.com>
"
" $Log: .vimrc,v $
" Revision 1.17  2015-03-04 15:14:42  wjding
" 1. Fix <xFn> setting.
" 2. Add support to LCP master.log
"
" Revision 1.16  2015-02-15 08:27:54  wjding
" Updated on lsslogin.
"
" Revision 1.15  2008-07-22 05:10:50  wjding
" Updated to support several OS/hosts at the same time
"
" Revision 1.14  2006/09/26 12:16:20  wjding
" Added scrolloff, noic, etc. Initial script on lsslogin1.
"
" Revision 1.13  2006/03/18 10:03:22  wjding
" Add .ts file type.
"
" Revision 1.12  2006/03/14 05:27:31  wjding
" Modify BufNew to BufNewFile.
"
" Revision 1.11  2006/01/16 03:00:07  wjding
" Change the .ts to .tssrc
"
" Revision 1.10  2006/01/16 02:55:35  wjding
" Add support for test script files
"
" Revision 1.9  2005/11/22 03:26:44  wjding
" Add set to cmdheight=1.
"
" Revision 1.8  2005/11/22 03:25:26  wjding
" Add support for TMS lists.
"
" Revision 1.7  2005/11/22 03:22:18  wjding
" Add command to remove the default mouse settings.
"
" Revision 1.6  2005/09/30 15:38:06  wjding
" Set textwidth for test scripts.
"
" Revision 1.5  2005/09/16 22:14:35  wjding
" Add support to Fn keys by Xmanager keyboard 101. This is identified by terminal
" type.
"
" Revision 1.4  2005/01/05 06:01:51  wjding
" Add "set expandtab".
"
" Revision 1.3  2004/12/09 04:51:07  wjding
" Add perl script automatic header creation.
"
" Revision 1.2  2004/12/05 09:10:25  wjding
" Add support for automatic creation of C/sh file headers.
"
" Revision 1.1  2004/07/06 01:51:40  cvs
" *** empty log message ***
"
"

set backup open
set backupext=~

set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/gvimrc_example.vim
set cpoptions=aABceFs

set scrollopt+=hor
set wildmenu
set wildmode=list:longest,list:full
set ruler
set laststatus=2
set showmode
set history=500
set hlsearch
set viminfo='20,\"500,:500,@500,/500
set statusline=%<%f%h%m%r%=%{strlen(getline(line('.')))}\ %l,%c\ %V\ \ \ \ \ \ \ %P
set mouse=
set ts=4
set cmdheight=1
set noic
set so=7
set nosmarttab

if has("unix")
  " Terminal keys setting
  set <F1>=[11~
  set <F2>=[12~
  set <F3>=[13~
  set <F4>=[14~
  set <F5>=[15~
  set <F6>=[17~
  set <F7>=[18~
  set <F8>=[19~
  set <F9>=[20~
  set <F10>=[21~
  set <F11>=[23~
  set <F12>=[24~
  set <xF1>=OP
  set <xF2>=OQ
  set <xF3>=OR
  set <xF4>=OS
  set <S-xF1>=[23~
  set <S-xF2>=[24~
  set <S-xF3>=[25~
  set <S-xF4>=[26~
  set <S-F1>=[1;2P
  set <S-F2>=[1;2Q
  set <S-F3>=[1;2R
  set <S-F4>=[1;2S
  if &term == "xterm"
    set <S-F5>=[38
    set <S-F6>=[29
    set <S-F7>=[31
    set <S-F8>=[32
    set <S-F9>=[33
    set <S-F10>=[34
    set <S-F11>=[35
    set <S-F12>=[36
  elseif &term =~ "^xterm-256color" || &term =~ "^screen-256color" || &term =~ "^screen.xterm"
    set <S-F5>=[15;2~
    set <S-F6>=[17;2~
    set <S-F7>=[18;2~
    set <S-F8>=[19;2~
    set <S-F9>=[20;2~
    set <S-F10>=[21;2~
    set <S-F11>=[23;2~
    set <S-F12>=[24;2~
  endif
  "set <F11>=Oy
  "set <F12>=Oz
endif "has("unix")

" map <F5> <C-R>=strftime("%m/%d/%y")<CR><Esc>
" imap <F5> <C-R>=strftime("%m/%d/%y")<CR><SPACE>
map <F9> <C-W><
map <F10> <C-W>+
map <F11> <C-W>-
map <F12> <C-W>>
map <S-F9> <C-W>h
map <S-F10> <C-W>j
map <S-F11> <C-W>k
map <S-F12> <C-W>l
imap <F9> <C-O><C-W><
imap <F10> <C-O><C-W>+
imap <F11> <C-O><C-W>-
imap <F12> <C-O><C-W>>
imap <S-F9> <C-O><C-W>h
imap <S-F10> <C-O><C-W>j
imap <S-F11> <C-O><C-W>k
imap <S-F12> <C-O><C-W>l
cmap <C-P> <Up>
cmap <C-N> <Down>
cnoremap <C-A> <C-B>
cnoremap <C-B> <Left>
cnoremap <C-F> <Right>

set expandtab
"set showmatch

"if &term =~ "xterm" || &term =~ "dtterm"
"  if has("terminfo")
"    set t_Co=8
"    set t_Sf=[3%p1%dm
"    set t_Sb=[4%p1%dm
"  else
"    set t_Co=8
"    set t_Sf=[3%dm
"    set t_Sb=[4%dm
"  endif
"endif

if has("autocmd")
  """""""""""""""""""""""""""""""""
  " For C programs, has been moved to $HOME/.vim/ftplugin/c.vim
  au BufNewFile *.c,*.cpp,*.[hH] 0r ~/work/vim/templates/c.temp
  au BufNewFile *.c,*.cpp so ~/work/vim/c.vim
"  au BufNewFile *.[hH] so ~/work/vim/h.vim
  "set cino=>4

  """""""""""""""""""""""""""""""""
  " For Korn Shell scripts
  au BufNewFile *.sh 0r ~/work/vim/templates/sh.temp
  au BufNewFile *.sh so ~/work/vim/sh.vim

  """""""""""""""""""""""""""""""""
  " For Perl Shell scripts
  au BufNewFile *.pl 0r ~/work/vim/templates/pl.temp
  au BufNewFile *.pl so ~/work/vim/sh.vim

  """""""""""""""""""""""""""""""""
  " For Readmes
"  au BufNewFile [rR]eadme*,README* 0r ~/template/readme.txt
"  au BufNewFile [rR]eadme*,README* so ~/work/vim/readme.vim
"  au BufNewFile [rR]eadme*,README* go 96
"  au BufNewFile,BufRead [rR]eadme*,README* set expandtab formatoptions+=lront tw=78
  """""""""""""""""""""""""""""""""
  " For Java programs
"  au BufNewFile,BufRead *.java set ai cin sts=4 expandtab showmatch cino=>4,j1 sw=4
"  au BufNewFile *.java 0r ~/template/java.template
"  au BufNewFile *.java $
"  au BufNewFile,BufRead *.java imap { {
"  au BufNewFile,BufRead *.java imap } }

  """""""""""""""""""""""""""""""""
  " For makefiles
"  au BufNewFile [Mm]akefile 0r ~/template/makefile
"  au BufNewFile [Mm]akefile 0r ~/template/makefile_inc
"  au BufNewFile [Mm]akefile startinsert
"  au BufNewFile [Mm]akefile call cursor(12,13)

  """""""""""""""""""""""""""""""""
  " For CVS & bugzilla
"  au BufNewFile,BufRead /tmp/cvs* so ~/work/vim/cvs.vim
  " For system.log 
"  au BufRead *system.log* so ~/.vim/ftplugin/system.log.vim
"  au BufRead *debug.log* so ~/.vim/ftplugin/debug.log.vim

  """""""""""""""""""""""""""""""""
  " For Perl files
  au BufNewFile,BufRead *.pl set sw=4 expandtab

  " For TMS Test scripts
  au BufNewFile,BufRead *.ts,*.tssrc so ~/.vim/ftplugin/tssrc.vim

  " For SVN log
  au BufNewFile,BufRead svn-commit.tmp set nobackup

  """""""""""""""""""""""""""""""""
  " For base_cfg
  au BufNewFile,BufRead base_cfg* set sw=4 noet nu

  " StevenD added for master.log
  au BufRead *.log,master.* so ~/.vim/ftplugin/masterlog.vim
  au BufRead,BufNewFile *.log,master.* set filetype=log

  if $HOSTNAME == "lsslogin1" || $HOSTNAME == "lsslogin2"
    " on lsslogin
    """""""""""""""""""""""""""""""""
    set ts=8
    " For ECMS feature line
    au BufNewFile,BufRead,StdinReadPost f.*
      \ noremap <F4> O#feature (<C-R>=$FEATURE<CR>)<Esc>j|
      \ noremap <F3> o#endfeature (<C-R>=$FEATURE<CR>)<Esc>k|
      \ noremap <S-F4> O#feature (!<C-R>=$FEATURE<CR>)<Esc>j|
      \ noremap <S-F3> o#endfeature (!<C-R>=$FEATURE<CR>)<Esc>k
  endif " $HOSTNAME == "lsslogin[12]"

  if $HOSTNAME == "ihecms"
    " on ihecms
    """""""""""""""""""""""""""""""""
    " For .s test scripts
    au BufNew,BufRead [a-z][a-z][0-9][0-9][0-9][0-9].s set tw=72

    """""""""""""""""""""""""""""""""
    " For .ts, .tssrc test script files
    au BufNewFile,BufRead *.ts,*.tssrc so ~/.vim/ftplugin/tssrc.vim

    """""""""""""""""""""""""""""""""
    " For tms output lists
    au BufNewFile,BufRead,StdinReadPost *
        \ if (getline(1) =~ '^tidnum' && getline(2) =~ '^=====') |
        \   nmap g<C-K> :!tmsprt <C-R>=expand("<cword>")<CR> \| less<CR>|
        \ endif

    au BufNewFile,BufRead,StdinReadPost *
        \ if (getline(7) =~ '^Test' && getline(8) =~ '^------') |
        \   nmap g<C-K> :!tmsprt <C-R>=expand("<cword>")<CR> \| less<CR>|
        \   nmap g<C-J> :g/\%71v-\%72v$<CR> |
        \   nmap g<C-I> :!printimr lssr11 <C-R>=expand("<cword>")<CR> \| less<CR>|
        \   nmap g<C-O> :!getimr.sh <C-R>=expand("<cword>")<CR> \| less<CR>|
        \ endif
  endif " $HOSTNAME == "ihecms"
endif " has("autocmd")

set path+=.

if &term =~ "dtterm" || &term =~ "^xterm$"
  if has("terminfo")
    set t_Co=8
    set t_AF=[3%p1%dm
    set t_AB=[4%p1%dm
  else
    set t_Co=8
    set t_Sf=[3%dm
    set t_Sb=[4%dm
  endif
  colorscheme my
elseif &term =~ "^xterm-256color" || &term =~ "^screen-256color" || &term =~ "screen.xterm"
  set t_Co=256
  set t_AB=[48;5;%p1%dm
  set t_AF=[38;5;%p1%dm
  colorscheme wjding256
elseif &term == ""
  " Gvim
  colorscheme koehler
endif

if &diff
  map <F5> ]c
  map <F6> [c
  map <S-F5> :diffget<CR>
  map <S-F6> :diffput<CR>
endif

syntax on

