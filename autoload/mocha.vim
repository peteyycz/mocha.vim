" plugin/mocha.vim
" Author:       Peter Czibik

function! mocha#toggle_only ()
  let s:save_cursor = getpos('.')
  call search('describe', 'bW')
  let blockFirstLine = getline('.')
  if (blockFirstLine =~ '\.only')
    call setline('.', substitute(blockFirstLine, '\.only', '', 'g'))
  else
    call setline('.', substitute(blockFirstLine, 'describe', 'describe.only', 'g'))
  endif
  call setpos('.', s:save_cursor)
endfunction
