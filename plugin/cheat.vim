if exists('g:loaded_cheat')
    finish
endif
let g:loaded_cheat = 1

com! -bar -complete=custom,cheat#completion -nargs=? Cheat call cheat#open(<bang>0, <f-args>)

nno <silent><unique> g? :<c-u>Cheat<cr>

