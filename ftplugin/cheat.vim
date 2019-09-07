" Options {{{1

setl bh=hide nobl bt=nofile noswf wfw

" teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ . "
    \ | setl bh< bl< bt< swf< wfw<
    \ "

