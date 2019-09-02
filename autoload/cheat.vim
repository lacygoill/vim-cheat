if exists('g:autoloaded_cheat')
    finish
endif
let g:autoloaded_cheat = 1

" /home/user/.vim/plugged/vim-cheat
let s:cheat_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

fu! cheat#completion(_a, _l, _p) abort "{{{1
    return join(map(systemlist('fd cheat.txt ~/wiki'), {_,v -> fnamemodify(v, ':h:t')}), "\n")
endfu

fu! s:split(path) abort "{{{1
    " Split a path into a list. Code from Pathogen.
    if type(a:path) == type([]) | return a:path | endif
    if empty(a:path) | return [] | endif
    let split = split(a:path, '\\\@<!\%(\\\\\)*\zs,')
    return map(split, {_,v -> substitute(v, '\\\([\\,]\)','\1','g')})
endfu

fu! cheat#open(newtab, ...) abort "{{{1
    " special case: we're reading a cheatsheet in “fullscreen”, and we reload
    if &ft is# 'cheat' && winnr('$') == 1
        enew
    elseif &ft is# 'cheat'
        " close possible existing cheatsheet;
        " only one at a time should be visible;
        " useful when reloading
        close
    endif

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
        " TODO: If the  current tabpage contains  only 1 window with  an unnamed
        " buffer, with no text, close it so  that the cheat window takes all the
        " space. Or zoom the cheat window?
        bo 43vnew +setl\ bt=nofile\ bh=hide\ nobl\ noswf\ wfw
    endif
    if a:0
        " FIXME: The file may not exist.
        " If so, an uncaught error is raised. Catch it.
        " Also:
        "
        "     $ cs foo
        "     " error
        "     " Vim should quit automatically
        exe '$read ~/wiki/'..a:1..'/cheat.txt'
    else
        exe '$read '..s:cheat_dir..'/cheat.txt'
    endif
    for glob in reverse(s:split(&runtimepath))
        for cs in filter(map(filter(split(glob(glob), '\n'),
           \ {_,v -> v !~ 'cheat'}),
           \ {_,v -> v..'/cheat.txt'}),
           \ {_,v -> filereadable(v)})
            exe '$read '..cs
        endfor
    endfor
    1d_
    setl fdl=1 fdm=marker fdt=substitute(getline(v:foldstart),'\\s\\+{'..'{{.*$','','')
    setl cocu=nc cole=3
    setl et nonu nornu nospell nowrap tw=40
    setl fileencoding=utf-8 ft=cheat noma
    setl isk=@,48-57,-,/,.,192-255
    exe 'setl tags='..s:cheat_dir..'/tags'
    nno  <buffer><nowait><silent>  <tab>  <c-w><c-p>
    nno  <buffer><nowait><silent>  <c-h>  :<c-u>echo 'press Tab'<cr>
    " TODO: If  there's  no other  tabpage,  and  only  one other  window  which
    " contains an empty unnamed buffer, `q` should quit Vim.
    " TODO: Install similar `q` mapping for the source code window.
    nno <buffer><nowait><silent> q :<c-u>call <sid>close_window()<cr>
    " TODO: Restore the autofolding state after we close the cheat window.{{{
    "
    " Check out how we dit it for `:Tldr`.
    " We should probably define a library function to toggle the state of auto-open-folds.
    "
    " ---
    "
    " Also,  make sure  the auto-open-folds  persists  across the  reloads of  a
    " cheatsheet (after we press `r`).
    "}}}
    " TODO: Doesn't work with our shell function `$ cs`.{{{
    "
    " It calls Vim like this:
    "
    "     $ vim +'Cheat tmux'
    "
    " But when Vim has just started, `coz` has not been installed yet.
    "}}}
    sil norm coz
    " mapping to reload cheatsheet
    " TODO: position is lost after reload; distracting
    let b:args = [a:newtab] + a:000
    nno  <buffer><nowait><silent>  r      :<c-u>call call('cheat#open', b:args)<cr>
    " mapping to edit source file
    " TODO: Add a little syntax highlighting and maybe some folding.{{{
    "
    " Otherwise it's hard to know where we are in a big cheatsheet.
    "
    " ---
    "
    " Also set comment leader to `#` to be able to comment with `gc`.
    " Basically, we need to set an ad-hoc filetype to load a filetype and syntax
    " plugins.
    "
    " ---
    "
    " Idea: Zoom  the window  (like what  is done  when we  press `spc  z`), and
    " unzoom it right before it's closed.
    " This way, we can  edit the source code in a big window;  and when we close
    " it, the other windows get back their original sizes.
    "}}}
    let b:source_file = a:0 ? '~/wiki/'..a:1..'/cheat.txt' : ''
    nno  <buffer><nowait><silent> -s      :<c-u>exe b:source_file isnot# '' ? 'lefta 40vs +setl\ wfw '..b:source_file : ''<cr>
endfu

fu! s:close_window() abort "{{{1
    if reg_recording() isnot# ''
        return feedkeys('q', 'in')[-1]
    endif
    wincmd p
    exe winnr('#')..'wincmd c'
endfu

