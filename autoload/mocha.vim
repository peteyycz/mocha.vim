" plugin/mocha.vim
" Author:       Peter Czibik

let g:mocha#block_separators = ['describe', 'it']
let g:mocha#tokens = ['skip', 'only']

function! s:get_separator_pattern (options)
  return '\(' . join(a:options, '\|') . '\)'
endfunction

function! s:get_separator_line_pattern ()
  return '^\s*' . s:get_separator_pattern(g:mocha#block_separators)
          \ . '\(.\(' . s:get_separator_pattern(g:mocha#tokens) . '\)\?\)*('
endfunction

function! s:get_matching_block_linenumber (pattern)
  if (getline('.') =~ a:pattern)
    return line('.')
  endif
  return search(a:pattern, 'bnW')
endfunction

function! mocha#toggle_only ()
  let save_cursor = getpos('.')

  let block_line_num = s:get_matching_block_linenumber(s:get_separator_line_pattern())

  if (block_line_num)
    call s:remove_skip(block_line_num)

    let has_only = getline(block_line_num) =~ '\.only'
    call s:gloal_remove_only()
    if (!has_only )
      call setline(block_line_num, substitute(getline(block_line_num),
            \ '\(' . s:get_separator_pattern(g:mocha#block_separators) . '\)',
            \ '\1.only', ''))
    endif
    call setpos('.', save_cursor)
  endif
endfunction

function! mocha#toggle_skip ()
  let save_cursor = getpos('.')

  let block_line_num = s:get_matching_block_linenumber(s:get_separator_line_pattern())

  if (block_line_num)
    let has_skip = getline(block_line_num) =~ '\.skip'
    call s:remove_token(block_line_num, 'skip')
    call s:remove_token(block_line_num, 'only')

    if (!has_skip )
      call setline(block_line_num, substitute(getline(block_line_num),
            \ '\(' . s:get_separator_pattern(g:mocha#block_separators) . '\)',
            \ '\1.skip', ''))
    endif
    call setpos('.', save_cursor)
  endif
endfunction

function! s:remove_token (line_number, token)
  let has_skip = getline(a:line_number) =~ '\.' . a:token
  if (has_skip)
    call setline(a:line_number, substitute(getline(a:line_number),
          \ '\.' . a:token, '', ''))
  endif
endfunction

function! s:gloal_remove_only ()
  %substitute/\.only//e
endfunction
