" plugin/mocha.vim
" Author:       Peter Czibik

let g:mocha#block_separators = ['describe', 'it']
let g:mocha#tokens = ['skip', 'only']

function! s:get_separator_pattern (options)
  return '\(' . join(a:options, '\|') . '\)'
endfunction

function! s:get_separator_line_pattern ()
  return '^\s*' . s:get_separator_pattern(g:mocha#block_separators)
          \ . '\(.\(' . s:get_separator_pattern(g:mocha#tokens) . '\)\?\)*'
endfunction

function! mocha#goto_separator (search_flags)
  call search(s:get_separator_line_pattern(), a:search_flags . 'W')
  normal zt
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
    call s:remove_token('skip', block_line_num)
    let has_only = getline(block_line_num) =~ '\.only'
    call s:remove_token('only', '%')
    if (!has_only )
      call s:add_token_to_line(block_line_num, 'only')
    endif
    call setpos('.', save_cursor)
  endif
endfunction

function! mocha#toggle_skip ()
  let save_cursor = getpos('.')

  let block_line_num = s:get_matching_block_linenumber(s:get_separator_line_pattern())
  if (block_line_num)
    let has_skip = getline(block_line_num) =~ '\.skip'
    call s:remove_token('skip', block_line_num)
    call s:remove_token('only', block_line_num)

    if (!has_skip )
      call s:add_token_to_line(block_line_num, 'skip')
    endif
    call setpos('.', save_cursor)
  endif
endfunction

function! s:add_token_to_line (line_number, token)
  call setline(a:line_number, substitute(getline(a:line_number),
        \ '\(' . s:get_separator_pattern(g:mocha#block_separators) . '\)',
        \ '\1.' . a:token, ''))
endfunction

function! s:remove_token (token, range)
  let substitute_pattern = 'substitute/^\(\s*' . s:get_separator_pattern(g:mocha#block_separators) .
        \ '\)\(\.' . a:token . '\)/\1/e'
  exec(a:range . substitute_pattern)
endfunction

function! mocha#global_remove_skip()
  let save_cursor = getpos('.')
  call s:remove_token('skip', '%')
  call setpos('.', save_cursor)
endfunction
