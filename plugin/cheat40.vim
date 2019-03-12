if exists('g:loaded_cheatsheet')
    finish
endif
let g:loaded_cheatsheet = 1

com! -bar -nargs=0 -bang Cheat40 call cheat40#open(<bang>0)

nno <silent><unique> g? :<c-u>Cheat40<cr>

