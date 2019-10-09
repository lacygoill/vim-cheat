if exists('g:autoloaded_cheat')
    finish
endif
let g:autoloaded_cheat = 1

" Interface {{{1
fu! cheat#open(...) abort "{{{2
    let cmd = a:0 ? a:1 : 'vim'
    let file = g:cheat_dir..'/'..cmd
    if !filereadable(file)
        echo '[cheat] '..file..' is not readable'
        return
    endif
    let index_of_existing_cheat_window =
        \ index(map(range(1, winnr('$')), {_,v -> getwinvar(v, '&ft')}), 'cheat')
    if index_of_existing_cheat_window >= 0
        exe index_of_existing_cheat_window..'close'
    endif
    " Why 43 instead of 40?{{{
    "
    " Because we set `'signcolumn'` in our vimrc.
    " Because of  this, 3 cells  are consumed by the  sign column (2  on the
    " left, one on the right).
    "
    " If you want to use `40vnew`, reset `'scl'` in the filetype plugin.
    "}}}
    exe 'to 43vnew '..file
endfu

fu! cheat#completion(_a, _l, _p) abort "{{{2
    sil return join(map(systemlist('find '..g:cheat_dir..' -type f'),
        \ {_,v -> fnamemodify(v, ':t:r')}), "\n")
endfu
"}}}1
" Core {{{1
fu! cheat#close_window() abort "{{{2
    if reg_recording() isnot# ''
        return feedkeys('q', 'in')[-1]
    endif
    if s:cheatsheet_is_alone()
        qa!
    else
        wincmd p
        exe winnr('#')..'q'
    endif
endfu

"}}}1
" Utilities {{{1
fu! s:cheatsheet_is_alone() abort "{{{2
    return tabpagenr('$') == 1
        \ && winnr('$') == 2
        \ && bufname('#') is# ''
        \ && getbufline('#', 1, 10) ==# ['']
endfu

