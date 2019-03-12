if exists('g:autoloaded_cheat40')
    finish
endif
let g:autoloaded_cheat40 = 1

let s:cheat40_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

fu! s:split(path) abort "{{{1
    " Split a path into a list. Code from Pathogen.
    if type(a:path) == type([]) | return a:path | endif
    if empty(a:path) | return [] | endif
    let split = split(a:path, '\\\@<!\%(\\\\\)*\zs,')
    return map(split, {i,v -> substitute(v, '\\\([\\,]\)','\1','g')})
endfu

fu! cheat40#open(newtab) abort "{{{1
    if a:newtab
        tabnew +setl\ bt=nofile\ bh=hide\ nobl\ noswf\ wfw
    else
        " Why 43 instead of 40?{{{
        "
        " Because we set `'signcolumn'` in our vimrc.
        " Because of  this, some 3 cells  are consumed by the sign  column (2 on
        " the left, one on the right).
        "
        " You could use `40vnew`, but you would also need to reset `'scl'`:
        "
        "     botright 40vnew +setlocal\ scl=no\ buftype=nofile...
        "                                ^^^^^^
        "}}}
        bo 43vnew +setl\ bt=nofile\ bh=hide\ nobl\ noswf\ wfw
    endif
    exe '$read ' . s:cheat40_dir . '/cheat40.txt'
    for glob in reverse(s:split(&runtimepath))
        for cs in filter(map(filter(split(glob(glob), '\n'),
           \ {i,v -> v !~ 'cheat40'}),
           \ {i,v -> v . '/cheat40.txt'}),
           \ {i,v -> filereadable(v)})
            exe '$read ' . cs
        endfor
    endfor
    1d_
    setl fdl=1 fdm=marker fdt=substitute(getline(v:foldstart),'\\s\\+{'.'{{.*$','','')
    setl cocu=nc cole=3
    setl et nonu nornu nospell nowrap tw=40
    setl fileencoding=utf-8 ft=cheat40 noma
    setl isk=@,48-57,-,/,.,192-255
    exe 'setl tags=' . s:cheat40_dir . '/tags'
    nno  <buffer><nowait><silent>  <tab>  <c-w><c-p>
    nno  <buffer><nowait><silent>  q      <c-w><c-p>@=winnr('#')<cr><c-w>c
endf

