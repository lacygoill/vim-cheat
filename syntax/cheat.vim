if exists('b:current_syntax')
    finish
endif

" TODO: Conceal some syntax items installed by `vim-lg`.
" Mainly (are there others?) `cheatCommentLeader` and `cheatCommentCodeBlock`.
"
" You could try sth like:
"
"     syn match cheatCommentLeader /\%(^\s*\)\@<=#/ contained conceal
"                                                             ^-----^
"
"     syn region cheatCommentCodeBlock matchgroup=Comment start=/# \{5,}/ end=/$/ concealends contained oneline keepend containedin=CheatComment
"                                                                                 ^---------^
"
" But I don't think it can be run from this script; it needs to be run later.
" Also, regarding `cheatCommentCodeBlock`, it would  be nice to only conceal the
" comment leader, not the leading spaces.

syn case ignore
syn sync fromstart
let [s:fmr_start, s:fmr_end] = split(&l:fmr, ',')->map({_, v -> v .. '\d*'})

syn match CheatDescr           /\%1v.*\%35v./
" Why `\%<50v` instead of `\%50v`?{{{
"
" There could be no mode character in the 50th column.
" In which case, the command will end somewhere before the 50th column.
"}}}
syn match CheatCommand         /\%36v.*\%<51v./ contains=CheatMode,CheatAngle,CheatDblAngle
exe 'syn match CheatSection /^.*' .. s:fmr_start .. '$/ contains=CheatFoldMarkerStart'
exe 'syn match CheatFoldMarkerStart /' .. s:fmr_start .. '/ contained conceal'
exe 'syn match CheatFoldMarkerEnd   /^' .. s:fmr_end .. '$/ conceal'
exe 'syn region CheatAbout start=/^About.*' .. s:fmr_start .. '$/ end=/\ze.*' .. s:fmr_start .. '$/'
\ .. ' keepend contains=CheatFoldMarkerStart,CheatFoldMarkerEnd,CheatTag,CheatAngle,CheatDblAngle'

syn match CheatTag      /`[^` \t]\+`/hs=s+1,he=e-1 contained contains=CheatBacktick,CheatRuntime
syn match CheatBacktick /`/ contained conceal
syn match CheatMode     /[NICVTOM*]\+\%>50v/ contained
syn match CheatAngle    /‹[^› \t]\+›/ contained
syn match CheatDblAngle /«[^» \t]\+»/ contained
syn match CheatComment  /^#.*$/ contains=CheatHash,CheatFoldMarkerStart
syn match CheatHash     /^#\s\=/ contained conceal
syn match CheatRuntime  +\$VIMRUNTIME/doc/+ contained conceal

hi def link CheatDescr           Normal
hi def link CheatCommand         Constant
hi def link CheatSection         Title
hi def link CheatAbout           Comment
hi def link CheatFoldMarkerStart Ignore
hi def link CheatFoldMarkerEnd   Ignore
hi def link CheatTag             Tag
hi def link CheatBacktick        Ignore
hi def link CheatMode            Type
hi def link CheatAngle           Identifier
hi def link CheatDblAngle        Label
hi def link CheatComment         Comment
hi def link CheatHash            Ignore
hi def link CheatRuntime         Ignore

let b:current_syntax = 'cheat'

