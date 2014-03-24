set nu
set si
:syntax on
set backspace=indent,eol,start
:filetype plugin on
au FileType java setlocal makeprg=javac\ %
au FileType py setlocal makeprg=python\ %
au FileType php setlocal makeprg=php\ -l\ %
set tabstop=4
set shiftwidth=4
au BufRead,BufNewFile *.php set ft=php.html
execute pathogen#infect()
