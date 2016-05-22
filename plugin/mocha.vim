" plugin/mocha.vim
" Author:       Peter Czibik

command! ToggleOnly call mocha#toggle_only()
command! ToggleSkip call mocha#toggle_skip()

command! FocusNextTest call mocha#goto_separator('')
command! FocusPreviousTest call mocha#goto_separator('b')
