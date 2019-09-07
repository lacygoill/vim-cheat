if exists('g:autoloaded_cheat')
    finish
endif
let g:autoloaded_cheat = 1

" TODO: The status line should display sth like `[cheat] tmux`.
" TODO: Edit the Vim cheatsheet so that it contains only info you wish to memorize.
" Also, include some `:ls [flags]` commands, like `:ls u-`, `:ls a+`, ...

let s:cheat_dir = $HOME..'/wiki/cheat'

" Interface {{{1
fu! cheat#open(...) abort "{{{2
    let cmd = a:0 ? a:1 : 'vim'
    let file = s:cheat_dir..'/'..cmd..'.txt'
    if !filereadable(file)
        echo '[cheat] '..file..' is not readable'
        return
    endif

    " TODO: Make sure no error  is raised when we read a  cheatsheet in a window
    " which is alone in a tabpage, and we reload.
    " TODO: Make sure we can never open more than one cheatsheet per tabpage.
    let tempfile = tempname()..'/cheat/'..cmd

    " TODO: Open file silently; i.e. when we run `:Cheat`, no message such as:
    "
    "     ~/wiki/cheat/vim.txt" 433L, 16836C
    "
    " TODO: Create a `cheat` filetype, and move all those settings in a filetype plugin.
    " TODO: Should we set `bh` to `delete`?
    " If we do it, we lose the ability to retrieve the buffer when pressing `C-^` twice.
    " Unless we populate the buffer via an autocmd listening to `BufNewFile`.
    " If we don't, then review `~/wiki/vim/todo.md`.
    " Why 43 instead of 40?{{{
    "
    " Because we set `'signcolumn'` in our vimrc.
    " Because of  this, 3 cells  are consumed by the  sign column (2  on the
    " left, one on the right).
    "
    " You could use `40vnew`, but you would also need to reset `'scl'`:
    "
    "     botright 40vnew +setlocal\ scl=no\ buftype=nofile...
    "                                ^^^^^^
    "}}}
    " TODO: Shouldn't we set 'scl' and use `40` instead of `43`?
    exe 'to 43vnew'..tempfile
endfu
fu! cheat#populate(path) abort "{{{2
    let cmd = matchstr(a:path, '.*/\zs.*')
    let file = s:cheat_dir..'/'..cmd..'.txt'
    exe '$read '..file
    1d_
    " TODO: All the rest of this function should be in a filetype plugin.
    setl fdl=1 fdm=marker fdt=substitute(getline(v:foldstart),'\\s\\+{'..'{{.*$','','')
    setl cocu=nc cole=3
    setl et nonu nornu nospell nowrap tw=40
    setl isk=@,48-57,-,/,.,192-255
    exe 'setl tags='..s:cheat_dir..'/tags'
    nno <buffer><nowait><silent> <c-l> :<c-u>call <sid>focus_previous_window_if_on_right()<cr>
    " TODO: Install similar `q` mapping for the source code window.
    " TODO: If  there's  no other  tabpage,  and  only  one other  window  which
    " contains an empty unnamed buffer, `q` should quit Vim.
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
    "     let t:cheat_cmd = cmd
    "     nno <buffer><nowait><silent> r :<c-u>q<bar>call cheat#open(t:cheat_cmd)<cr>
    nno <buffer><nowait><silent> r :<c-u>call <sid>reload()<cr>
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
    let b:source_file = s:cheat_dir..'/'..cmd..'.txt'
    nno <buffer><nowait><silent> -s :<c-u>call <sid>edit_source_file()<cr>
endfu

fu! cheat#completion(_a, _l, _p) abort "{{{2
    sil return join(map(systemlist('find '..s:cheat_dir..' -type f'),
        \ {_,v -> fnamemodify(v, ':t:r')}), "\n")
endfu
"}}}1
" Core {{{1
fu! s:close_window() abort "{{{2
    if reg_recording() isnot# ''
        return feedkeys('q', 'in')[-1]
    endif
    wincmd p
    exe winnr('#')..'q'
endfu

fu! s:focus_previous_window_if_on_right() abort "{{{2
    if s:previous_window_is_on_right()
        wincmd p
    else
        wincmd l
    endif
endfu

fu! s:edit_source_file() abort "{{{2
    exe 'rightb 40vs '..b:source_file
    setl bh=delete nobl noswf wfw
endfu

fu! s:reload() abort "{{{2
    let cmd = matchstr(expand('%:p'), '.*/\zs.*')
    " special case: The cheat window is alone in the tab page;
    " we need another window, otherwise the next `:q` could make Vim quit.
    if winnr('$') == 1
        vnew | wincmd p
    endif
    q
    call cheat#open(cmd)
endfu
"}}}1
" Utilities {{{1
fu! s:previous_window_is_on_right() abort "{{{2
    let nr = winnr()
    let rightedge_current_window = win_screenpos(nr)[1] + winwidth(nr) - 1
    let nr = winnr('#')
    let leftedge_previous_window = win_screenpos(nr)[1]
    return rightedge_current_window + 1 == leftedge_previous_window - 1
endfu

