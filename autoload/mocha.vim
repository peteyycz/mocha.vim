" plugin/mocha.vim
" Author:       Peter Czibik

let g:mocha#block_separators = ['describe', 'it']

function! s:get_separator_pattern ()
  return '\(' . join(g:mocha#block_separators, '\|') . '\)'
endfunction

function! mocha#toggle_only ()
  let save_cursor = getpos('.')

  let separator_line_pattern = '^\s*' . s:get_separator_pattern()
        \ . '\(.only\)\?('

  if (getline('.') =~ separator_line_pattern)
    let block_line_num = line('.')
  else
    let block_line_num = search(separator_line_pattern, 'bnW')
  endif

  if (block_line_num)
    let has_only = getline(block_line_num) =~ '\.only'
    call s:gloal_remove_only()
    if (!has_only )
      call setline(block_line_num, substitute(getline(block_line_num),
            \ '\(' . s:get_separator_pattern() . '\)', '\1.only', ''))
    endif
    call setpos('.', save_cursor)
  endif
endfunction

function! s:gloal_remove_only ()
  %substitute/\.only//e
endfunction
