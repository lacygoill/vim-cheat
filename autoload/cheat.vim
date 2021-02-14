vim9script noclear

if exists('loaded') | finish | endif
var loaded = true

import Win_getid from 'lg.vim'

# Interface {{{1
def cheat#open(cmd: string) #{{{2
    var file: string = g:cheat_dir .. '/' .. (cmd == '' ? 'vim' : cmd)
    if !filereadable(file)
        echo '[cheat] ' .. file .. ' is not readable'
        return
    endif
    var index_of_existing_cheat_window: number =
        range(1, winnr('$'))
            ->mapnew((_, v) => getwinvar(v, '&ft'))
            ->index('cheat')
    if index_of_existing_cheat_window >= 0
        exe index_of_existing_cheat_window .. 'close'
    endif
    # Why 53 instead of 50?{{{
    #
    # Because we set `'signcolumn'` in our vimrc.
    # Because of  this, 3 cells  are consumed by the  sign column (2  on the
    # left, one on the right).
    #
    # If you want to use `50vnew`, reset `'scl'` in the filetype plugin.
    #}}}
    exe 'to :53vnew ' .. file
enddef

def cheat#completion(...l: any): string #{{{2
    sil return systemlist('find ' .. shellescape(g:cheat_dir) .. ' -type f')
        ->map((_, v) => fnamemodify(v, ':t:r'))
        ->join("\n")
enddef

def cheat#undoFtplugin() #{{{2
    set bh<
    set bl<
    set cms<
    set cocu<
    set cole<
    set fdl<
    set fdm<
    set fdt<
    set isk<
    set nu<
    set rnu<
    set ro<
    set spell<
    set swf<
    set tags<
    set tw<
    set wfw<
    set wrap<

    nunmap <buffer> q
enddef
#}}}1
# Core {{{1
def cheat#closeWindow() #{{{2
    if reg_recording() != ''
        feedkeys('q', 'in')
        return
    endif
    if CheatsheetIsAlone()
        qa!
    else
        var winid: number = Win_getid('#')
        close
        win_gotoid(winid)
    endif
enddef
#}}}1
# Utilities {{{1
def CheatsheetIsAlone(): bool #{{{2
    return tabpagenr('$') == 1
        && winnr('$') == 2
        && bufname('#') == ''
        && getbufline('#', 1, 10) == ['']
enddef

