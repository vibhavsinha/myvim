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

" Directory sepcific settings
function! SetupEnvironment()
  let l:path = expand('%:p')
  if l:path =~ '/home/vibhav/public_html/secure' "vdocipher settings
	set tags=~/public_html/yii/php.tags
    setlocal expandtab smarttab textwidth=0

  elseif l:path =~ '/home/user/projects'
    setlocal tabstop=4 shiftwidth=4 noexpandtab

  endif

endfunction
autocmd! BufReadPost,BufNewFile * call SetupEnvironment()
function! HtmlEntities(line1, line2, action)
  let search = @/
  let range = 'silent ' . a:line1 . ',' . a:line2
  if a:action == 0  " must convert &amp; last
    execute range . 'sno/&lt;/</eg'
    execute range . 'sno/&gt;/>/eg'
    execute range . 'sno/&amp;/&/eg'
  else              " must convert & first
    execute range . 'sno/&/&amp;/eg'
    execute range . 'sno/</&lt;/eg'
    execute range . 'sno/>/&gt;/eg'
  endif
  nohl
  let @/ = search
endfunction
command! -range -nargs=1 Entities call HtmlEntities(<line1>, <line2>, <args>)
noremap <silent> \h :Entities 0<CR>
noremap <silent> \H :Entities 1<CR>
