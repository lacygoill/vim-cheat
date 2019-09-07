if exists('g:loaded_cheat')
    finish
endif
let g:loaded_cheat = 1

" Autocommand {{{1

augroup cheat_populate
    au!
    au BufNewFile /tmp/*/cheat/* call cheat#populate(expand('<amatch>'))
augroup END

" Command {{{1

com! -bar -complete=custom,cheat#completion -nargs=? Cheat call cheat#open(<f-args>)

" Mapping {{{1

nno <silent><unique> g? :<c-u>Cheat<cr>

