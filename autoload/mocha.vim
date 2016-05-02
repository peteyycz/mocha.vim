" plugin/mocha.vim
" Author:       Peter Czibik

let g:mocha#block_separators = ['describe', 'it']

function! s:get_separator_regex ()
  return join(g:mocha#block_separators, '\|')
endfunction

function! mocha#toggle_only ()
  let save_cursor = getpos('.')

  if (getline('.') =~ s:get_separator_regex())
    let blockLineNum = line('.')
  else
    let blockLineNum = search(
          \ '^\s*' . s:get_separator_regex() . '\(.only\)\?(',
          \ 'bnW')
  endif

  if (blockLineNum)
    let hasOnly = getline(blockLineNum) =~ '\.only'
    call s:gloal_remove_only()
    if (!hasOnly)
      call setline(blockLineNum, substitute(getline(blockLineNum),
            \ '\(' . s:get_separator_regex() . '\)', '\1.only', ''))
    endif
    call setpos('.', save_cursor)
  endif
endfunction

function! s:gloal_remove_only ()
  %substitute/\.only//e
endfunction
