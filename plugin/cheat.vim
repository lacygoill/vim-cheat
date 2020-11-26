if exists('g:loaded_cheat')
    finish
endif
let g:loaded_cheat = 1

" TODO: Edit the Vim cheatsheet so that it contains only info you wish to memorize.
" Also, include some `:ls [flags]` commands, like `:ls u-`, `:ls a+`, ...

" TODO: Read  `~/wiki/vim/todo.md`, find a  general design for  scratch buffers,
" and use it for cheat buffers.
" Also, once you've  finished this plugin, re-read its code,  and make sure that
" for every  line of  code whose  purpose is  not clear,  the latter  purpose is
" documented in `todo.md`.

" Variables {{{1

const g:cheat_dir = $HOME .. '/wiki/cheat'

" Commands {{{1

" We name the command `:Cs`, to be consistent with `$ cs`.
" Note that it probably shadows `:cs` (short form of `:cscope`).
com -bar -nargs=? -complete=custom,cheat#completion Cs call cheat#open(<f-args>)

" Mappings {{{1

nno <unique> g? <cmd>Cs<cr>

" restore Rot13 encoding (`:h g?`)
nno <unique> +?  g?
nno <unique> +?? g??

" install similar mapping in visual mode for consistency
xno <unique> +? g?

