if exists('b:current_syntax')
    finish
endif

" TODO: Conceal some syntax items installed by `vim-lg`.
" Mainly (are there others?) `cheatCommentLeader` and `cheatCommentCodeBlock`.
"
" You could try sth like:
"
"     syn match cheatCommentLeader /\%(^\s*\)\@<=#\m/ contained conceal
"                                                               ^^^^^^^
"
"     syn region cheatCommentCodeBlock matchgroup=Comment start=/#\m \{5,}/ end=/$/ concealends contained oneline keepend containedin=CheatComment
"                                                                                   ^^^^^^^^^^^
"
" But I don't think it can be run from this script; it needs to be run later.
" Also, regarding `cheatCommentCodeBlock`, it would  be nice to only conceal the
" comment leader, not the leading spaces.

syn case ignore
syn sync fromstart
let [s:fmr_start, s:fmr_end] = map(split(&l:fmr, ','), {_,v -> v..'\d*'})

syn match CheatDescr           /\%1v.*\%25v./
" Why `\%<40v` instead of `\%40v`?{{{
"
" There could be no mode character in the 40th column.
" In which case, the command will end somewhere before the 40th column.
"}}}
syn match CheatCommand         /\%26v.*\%<41v./ contains=CheatMode,CheatAngle,CheatDblAngle
exe 'syn match CheatSection /^.*'..s:fmr_start..'$/ contains=CheatFoldMarkerStart'
exe 'syn match CheatFoldMarkerStart /'..s:fmr_start..'/ contained conceal'
exe 'syn match CheatFoldMarkerEnd   /^'..s:fmr_end..'$/ conceal'
exe 'syn region CheatAbout start=/^About.*'..s:fmr_start..'$/ end=/\ze.*'..s:fmr_start..'$/'
\ ..' keepend contains=CheatFoldMarkerStart,CheatFoldMarkerEnd,CheatTag,CheatAngle,CheatDblAngle'

syn match CheatTag      /`[^` \t]\+`/hs=s+1,he=e-1 contained contains=CheatBacktick,CheatRuntime
syn match CheatBacktick /`/ contained conceal
syn match CheatMode     /[NICVTOM*]\+\%>40v/ contained
syn match CheatAngle    /‹[^› \t]\+›/ contained
syn match CheatDblAngle /«[^» \t]\+»/ contained
syn match CheatComment  /^#.*$/ contains=CheatHash,CheatFoldMarkerStart
syn match CheatHash     /^#\s\=/ contained conceal
syn match CheatRuntime  +\$VIMRUNTIME/doc/+ contained conceal

hi link CheatDescr           Normal
hi link CheatCommand         Constant
hi link CheatSection         Title
hi link CheatAbout           Comment
hi link CheatFoldMarkerStart Ignore
hi link CheatFoldMarkerEnd   Ignore
hi link CheatTag             Tag
hi link CheatBacktick        Ignore
hi link CheatMode            Type
hi link CheatAngle           Identifier
hi link CheatDblAngle        Label
hi link CheatComment         Comment
hi link CheatHash            Ignore
hi link CheatRuntime         Ignore

let b:current_syntax = 'cheat'

