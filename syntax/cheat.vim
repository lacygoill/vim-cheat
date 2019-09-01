if exists('b:current_syntax')
    finish
endif

syn case ignore
syn sync fromstart

syn match   CheatDescr           /\%1v.*\%25v./
syn match   CheatCommand         /\%26v.*\%40v./ contains=CheatMode,CheatAngle,CheatDblAngle
syn match   CheatSection         /^.*{{\%x7b\d*$/ contains=CheatFoldMarkerStart
syn match   CheatFoldMarkerStart /{{\%x7b\d*/ contained conceal
syn match   CheatFoldMarkerEnd   /^}}\%x7d$/ conceal
syn region  CheatAbout  start=/^About.*{{\%x7b\d*$/ end=/\ze.*{{\%x7b\d*$/
    \ keepend contains=CheatFoldMarkerStart,CheatFoldMarkerEnd,CheatTag,CheatAngle,CheatDblAngle

" TODO: Highlight `codespan`.
" Note that contrary to a tag, a codespan can contain whitespace.
syn match   CheatTag          /`[^` \t]\+`/hs=s+1,he=e-1 contained contains=CheatBacktick,CheatRuntime
syn match   CheatBacktick     /`/ contained conceal
syn match   CheatMode         /[NICVTOM*]\+\%>40v/ contained
syn match   CheatAngle        /‹[^› \t]\+›/ contained
syn match   CheatDblAngle     /«[^» \t]\+»/ contained
syn match   CheatComment      /^#.*$/ contains=CheatHash
syn match   CheatHash         /^#\s\=/ contained conceal
syn match   CheatRuntime      +\$VIMRUNTIME/doc/+ contained conceal

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

