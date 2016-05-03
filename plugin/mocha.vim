" plugin/mocha.vim
" Author:       Peter Czibik

command! ToggleOnly call mocha#toggle_token('only')
command! ToggleSkip call mocha#toggle_token('skip')
