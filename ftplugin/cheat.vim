" Options {{{1
" window options {{{2

" TODO: Set them from an autocmd listening to `BufWinEnter`?{{{
"
" ---
"
" `wfw` is not a buffer option. Move it here?
"
" ---
"
" Review `~/wiki/vim/todo.md`.
" Did we write that window-local options should be set from an autocmd listening
" to `BufWinEnter`? If not, should we?
"}}}
setl fdl=1 fdm=marker fdt=substitute(getline(v:foldstart),'\\s\\+{'..'{{.*$','','')
setl cocu=nc cole=3
setl nonu nornu
setl nospell
setl nowrap

" buffer options {{{2

" TODO: Should we set `bh` to `delete`?{{{
"
" If we do it, we lose the ability to retrieve the buffer when pressing `C-^` twice.
" Unless we populate the buffer via an autocmd listening to `BufNewFile`.
" If we don't, then review `~/wiki/vim/todo.md`.
"
" ---
"
" If you use `delete`, you lose the auto-open-fold feature after pressing `C-^` twice.
" In that case, you should probably set the feature from this filetype plugin.
"}}}
" TODO: Does `bh` have an influence on how window-local options are applied when{{{
" a  cheat  buffer is  displayed  in  a  window,  while it's  already  displayed
" somewhere else, or when we press `C-^` twice?
"
" ---
"
"     $ cs tmux
"     :setl list
"     C-l
"     C-^
"
" `'list'` is set in the second window, even when we use `bh=delete`.
" How is that possible?
"
" MWE:
"
"     $ vim -Nu NONE --cmd 'set rtp^=~/.vim/plugged/vim-cheat | filetype plugin on | setl list' -O ~/wiki/cheat/vim =(echo ~/wiki/cheat/vim)
"     C-w C-w
"     gf
"
" Why is `'list'` enabled in the second window?
"
" OTOH:
"
"     # include `setl list` in the current filetype plugin
"     $ vim -Nu NONE --cmd 'set rtp^=~/.vim/plugged/vim-cheat | filetype plugin on' -O ~/wiki/cheat/vim =(echo ~/wiki/cheat/vim)
"     C-w C-w
"     gf
"
" This time, `'list'` is not enabled in the second window, which is expected.
"
" ---
"
"     $ echo '/tmp/pn.pn' >/tmp/file
"     $ vim -Nu NONE --cmd 'filetype plugin on' /tmp/file
"     :to vnew /tmp/pn.pn
"     C-w C-w
"     gf
"}}}
setl bh=hide nobl noswf ro wfw

setl cms=#\ %s
setl et
setl tw=40
setl isk=@,48-57,-,/,.,192-255
exe 'setl tags='..g:cheat_dir..'/tags'

call toggle_settings#auto_open_fold('enable')
" TODO: if you keep the autocmd, clear it in b:undo_ftplugin
augroup cheat_open_fold
    au! * <buffer>
    au BufWinEnter <buffer> norm! zv
augroup END
"}}}1
" Mappings {{{1

nno <buffer><nowait><silent> <c-l> :<c-u>call cheat#focus_previous_window_if_on_right()<cr>
nno <buffer><nowait><silent> q :<c-u>call cheat#close_window()<cr>

" teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ . "
    \ | setl bh< bl< cms< cocu< cole< fdl< fdm< fdt< isk< nu< rnu< ro< spell< swf< tags< tw< wfw< wrap<
    \ "

