" plugin/mocha.vim
" Author:       Peter Czibik

let g:mocha#block_separators = ['describe', 'it']
let g:mocha#tokens = ['skip', 'only']

function! s:get_separator_pattern (options)
  return '\(' . join(a:options, '\|') . '\)'
endfunction

function! mocha#toggle_token (token)
  let save_cursor = getpos('.')

  let separator_line_pattern = '^\s*' .
        \ s:get_separator_pattern(g:mocha#block_separators)
        \ . '\(.' . s:get_separator_pattern(g:mocha#tokens) . '\)\?('

  if (getline('.') =~ separator_line_pattern)
    let block_line_num = line('.')
  else
    let block_line_num = search(separator_line_pattern, 'bnW')
  endif

  if (block_line_num)
    let has_only = getline(block_line_num) =~ '\.' . a:token
    call s:gloal_remove_only()
    if (!has_only )
      call setline(block_line_num, substitute(getline(block_line_num),
            \ '\(' . s:get_separator_pattern(g:mocha#block_separators) . '\)',
            \ '\1.' . a:token, ''))
    endif
    call setpos('.', save_cursor)
  endif
endfunction

function! s:gloal_remove_only ()
  exec('%substitute/\.' . s:get_separator_pattern(g:mocha#tokens) . '//e')
endfunction
