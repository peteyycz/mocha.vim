" plugin/mocha.vim
" Author:       Peter Czibik

function! mocha#toggle_only ()
  let save_cursor = getpos('.')

  let blockLineNum = search('\(describe\|it\)', 'bW')
  let hasOnly = getline('.') =~ '\.only'

  call s:gloal_remove_only()

  if (!hasOnly)
    exec(blockLineNum . 'substitute/\(describe\|it\)/\1.only/e')
  endif

  call setpos('.', save_cursor)
endfunction

function! s:gloal_remove_only ()
  %substitute/\.only//e
endfunction
