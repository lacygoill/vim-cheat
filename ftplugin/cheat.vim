vim9script

# Options {{{1
# window options {{{2

# TODO: Set them from an autocmd listening to `BufWinEnter`?{{{
#
# ---
#
# `winfixwidth` is not a buffer option.  Move it here?
#
# ---
#
# Review `~/wiki/vim/todo.md`.
# Did we write that window-local options should be set from an autocmd listening
# to `BufWinEnter`? If not, should we?
#}}}
&l:foldlevel = 1
&l:foldmethod = 'marker'
&l:foldtext = "getline(v:foldstart)->substitute('\\s\\+{{\\%x7b.*$','','')"

&l:concealcursor = 'nc'
&l:conceallevel = 3
&l:number = false
&l:relativenumber = false
&l:spell = false
&l:wrap = false

# buffer options {{{2

# TODO: Should we set `'bufhidden'` to `delete`?{{{
#
# If we do it, we lose the ability to retrieve the buffer when pressing `C-^` twice.
# Unless we populate the buffer via an autocmd listening to `BufNewFile`.
# If we don't, then review `~/wiki/vim/todo.md`.
#
# ---
#
# If you use `delete`, you lose the auto-open-fold feature after pressing `C-^` twice.
# In that case, you should probably set the feature from this filetype plugin.
#}}}
# TODO: Does `'bufhidden'` have an influence on how window-local options are applied when{{{
# a  cheat  buffer is  displayed  in  a  window,  while it's  already  displayed
# somewhere else, or when we press `C-^` twice?
#
# ---
#
# It doesn't seem to cause an issue:
#
#     $ cs tmux
#     :setlocal list
#     C-l
#     C-^
#
# `'list'` is set in the second window, even when we use `bufhidden=delete`.
#}}}
# TODO: What  about moving  the comments  of a  cheatsheet inside  popup windows
# opened dynamically when hovering the relevant line?
&l:bufhidden = 'hide'
&l:buflisted = false
&l:swapfile = false
&l:readonly = true
&l:winfixwidth = true

&l:commentstring = '# %s'
&l:textwidth = 40
&l:iskeyword = '@,48-57,-,/,.,192-255'
&l:tags = g:cheat_dir .. '/tags'

toggleSettings#autoOpenFold(v:true)
# TODO: if you keep the autocmd, clear it in b:undo_ftplugin
augroup CheatOpenFold
    autocmd! * <buffer>
    # `zM` is important!{{{
    #
    # Without,  when you  press `j`  or `k`,  the folds  won't be  automatically
    # opened/closed; at least not until you've pressed `zM`.
    # For an explanation, see:
    #
    #     ~/.vim/pack/mine/opt/toggleSettings/plugin/toggleSettings.vim
    #     /MoveAndOpenFold
    #     ?Warning
    #}}}
    autocmd BufWinEnter <buffer> normal! zMzv
augroup END
#}}}1
# Mappings {{{1

nnoremap <buffer><nowait> q <Cmd>call cheat#closeWindow()<CR>

# Teardown {{{1

b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')
    .. '| call cheat#undoFtplugin()'

