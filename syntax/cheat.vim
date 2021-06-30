vim9script

if exists('b:current_syntax')
    finish
endif

# TODO: Conceal some syntax items installed by `vim-lg`.
# Mainly (are there others?) `cheatCommentLeader` and `cheatCommentCodeBlock`.
#
# You could try sth like:
#
#     syntax match cheatCommentLeader /\%(^\s*\)\@<=#/ contained conceal
#                                                                ^-----^
#
#     syntax region cheatCommentCodeBlock matchgroup=Comment start=/# \{5,}/ end=/$/ concealends contained oneline keepend containedin=CheatComment
#                                                                                    ^---------^
#
# But I don't think it can be run from this script; it needs to be run later.
# Also, regarding `cheatCommentCodeBlock`, it would  be nice to only conceal the
# comment leader, not the leading spaces.

syntax case ignore
syntax sync fromstart
var fmr_start: string
var fmr_end: string
[fmr_start, fmr_end] = &l:foldmarker
    ->split(',')
    ->map((_, v: string): string => v .. '\d*')

syntax match CheatDescr           /\%1v.*\%35v./
# Why `\%<50v` instead of `\%50v`?{{{
#
# There could be no mode character in the 50th column.
# In which case, the command will end somewhere before the 50th column.
#}}}
syntax match CheatCommand         /\%36v.*\%<51v./ contains=CheatMode,CheatAngle,CheatDblAngle
execute 'syntax match CheatSection /^.*' .. s:fmr_start .. '$/ contains=CheatFoldMarkerStart'
execute 'syntax match CheatFoldMarkerStart /' .. s:fmr_start .. '/ contained conceal'
execute 'syntax match CheatFoldMarkerEnd   /^' .. s:fmr_end .. '$/ conceal'
execute 'syntax region CheatAbout start=/^About.*' .. s:fmr_start .. '$/ end=/\ze.*' .. s:fmr_start .. '$/'
\ .. ' keepend contains=CheatFoldMarkerStart,CheatFoldMarkerEnd,CheatTag,CheatAngle,CheatDblAngle'

syntax match CheatTag      /`[^` \t]\+`/hs=s+1,he=e-1 contained contains=CheatBacktick,CheatRuntime
syntax match CheatBacktick /`/ contained conceal
syntax match CheatMode     /[NICVTOM*]\+\%>50v/ contained
syntax match CheatAngle    /‹[^› \t]\+›/ contained
syntax match CheatDblAngle /«[^» \t]\+»/ contained
syntax match CheatComment  /^#.*$/ contains=CheatHash,CheatFoldMarkerStart
syntax match CheatHash     /^#\s\=/ contained conceal
syntax match CheatRuntime  +\$VIMRUNTIME/doc/+ contained conceal

highlight def link CheatDescr           Normal
highlight def link CheatCommand         Constant
highlight def link CheatSection         Title
highlight def link CheatAbout           Comment
highlight def link CheatFoldMarkerStart Ignore
highlight def link CheatFoldMarkerEnd   Ignore
highlight def link CheatTag             Tag
highlight def link CheatBacktick        Ignore
highlight def link CheatMode            Type
highlight def link CheatAngle           Identifier
highlight def link CheatDblAngle        Label
highlight def link CheatComment         Comment
highlight def link CheatHash            Ignore
highlight def link CheatRuntime         Ignore

b:current_syntax = 'cheat'

