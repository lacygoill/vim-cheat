vim9script noclear

if exists('loaded') | finish | endif
var loaded = true

# TODO: Edit the Vim cheatsheet so that it contains only info you wish to memorize.
# Also, include some `:ls [flags]` commands, like `:ls u-`, `:ls a+`, ...

# TODO: Read  `~/wiki/vim/todo.md`, find a  general design for  scratch buffers,
# and use it for cheat buffers.
# Also, once you've  finished this plugin, re-read its code,  and make sure that
# for every  line of  code whose  purpose is  not clear,  the latter  purpose is
# documented in `todo.md`.

# Variables {{{1

const g:cheat_dir = $HOME .. '/wiki/cheat'

# Commands {{{1

# We name the command `:Cs`, to be consistent with `$ cs`.
# Note that it probably shadows `:cs` (short form of `:cscope`).
command -bar -nargs=? -complete=custom,cheat#completion Cs cheat#open(<q-args>)

# Mappings {{{1

nnoremap <unique> g? <Cmd>Cs<CR>

# restore Rot13 encoding (`:help g?`)
nnoremap <unique> +?  g?
nnoremap <unique> +?? g??

# install similar mapping in visual mode for consistency
xnoremap <unique> +? g?

