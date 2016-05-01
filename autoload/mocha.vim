" plugin/mocha.vim
" Author:       Peter Czibik

function! mocha#toggle_only ()
  let save_cursor = getpos('.')
  let blockLineNum = search('\(describe\|it\)', 'bnW')

  if (blockLineNum)
    let hasOnly = getline(blockLineNum) =~ '\.only'
    call s:gloal_remove_only()
    if (!hasOnly)
      call setline(blockLineNum, substitute(getline(blockLineNum),
            \ '\(describe\|it\)', '\1.only', ''))
    endif
    call setpos('.', save_cursor)
  endif
endfunction

function! s:gloal_remove_only ()
  %substitute/\.only//e
endfunction
