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

" To convert HTML entities on a selected text. This function will interconvert
" betwen < and &lt; , > and &gt;
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

" pathogen
execute pathogen#infect()



" This requires xmllint in the PATH variable
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
