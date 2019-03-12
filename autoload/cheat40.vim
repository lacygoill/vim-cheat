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
        tabnew +setlocal\ buftype=nofile\ bufhidden=hide\ nobuflisted\ noswapfile\ winfixwidth
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
        botright 43vnew +setlocal\ buftype=nofile\ bufhidden=hide\ nobuflisted\ noswapfile\ winfixwidth
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
    norm! ggd_
    setl foldlevel=1 foldmethod=marker foldtext=substitute(getline(v:foldstart),'\\s\\+{'.'{{.*$','','')
    setl concealcursor=nc conceallevel=3
    setl expandtab nonumber norelativenumber nospell nowrap textwidth=40
    setl fileencoding=utf-8 filetype=cheat40 nomodifiable
    setl iskeyword=@,48-57,-,/,.,192-255
    exe 'setl tags=' . s:cheat40_dir . '/tags'
    nno  <buffer><nowait><silent>  <tab> <c-w><c-p>
    nno  <buffer><nowait><silent>  q <c-w><c-p>@=winnr('#')<cr><c-w>c
endf

