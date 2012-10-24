" SearchPatternPerTab.vim: Maintain separate search patterns (@/) per tab page.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.

" Copyright: (C) 2009-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	28-May-2009	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_SearchPatternPerTab') || (v:version < 700)
    finish
endif
let g:loaded_SearchPatternPerTab = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:SearchPatternPerTab')
    let g:SearchPatternPerTab = 0
endif


"- functions -------------------------------------------------------------------

let s:save_search = ''
function! s:OnTabEnter()
    if exists('t:SearchPattern')
	let @/ = t:SearchPattern
    else
	let @/ = s:save_search
    endif
endfunction
function! s:OnTabLeave()
    if g:SearchPatternPerTab || exists('t:SearchPattern')
	let t:SearchPattern = @/
    else
	let s:save_search = @/
    endif
endfunction

function! s:TabLocal()
    if exists('t:SearchPattern') | return | endif

    let s:save_search = @/
    let t:SearchPattern = @/
endfunction
function! s:NoTabLocal()
    let @/ = s:save_search
    unlet! t:SearchPattern
endfunction

function! s:EnableAutocmds()
    augroup SearchPatternPerTab
	autocmd! TabEnter * call <SID>OnTabEnter()
	autocmd! TabLeave * call <SID>OnTabLeave()
    augroup END
endfunction
function! s:DisableAutocmds()
    autocmd! SearchPatternPerTab
endfunction


"- commands --------------------------------------------------------------------

command! -bar   SearchPatternPerTab   let g:SearchPatternPerTab = 1 | call <SID>TabLocal() | call <SID>EnableAutocmds()
command! -bar NoSearchPatternPerTab   let g:SearchPatternPerTab = 0                        | call <SID>DisableAutocmds()
command! -bar   SearchPatternTabLocal                                 call <SID>TabLocal() | call <SID>EnableAutocmds()
command! -bar NoSearchPatternTabLocal                                 call <SID>NoTabLocal()


"-------------------------------------------------------------------------------

if g:SearchPatternPerTab
    SearchPatternPerTab
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
