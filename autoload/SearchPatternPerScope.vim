" SearchPatternPerScope.vim: Maintain separate search patterns ("/) per window / tab page.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.

" Copyright: (C) 2009-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.003	29-Oct-2012	Split off autoload script.
"   1.00.002	25-Oct-2012	Rename and generalize for both windows and tab
"				pages.
"				Add mappings to clone and localize the search.
"	001	28-May-2009	file creation

let s:save_search = ''

" The event order is WinLeave, TabLeave, WinEnter, TabEnter.
function! s:OnWinLeave()
    if g:SearchPatternPerWin || exists('w:SearchPatternScoped')
	let w:SearchPatternScoped = @/
    elseif ! exists('t:SearchPatternScoped')
	let s:save_search = @/
    endif
endfunction
function! s:OnTabLeave()
    if ! exists('w:SearchPatternScoped')
	if g:SearchPatternPerTab || exists('t:SearchPatternScoped')
	    let t:SearchPatternScoped = @/
	else
	    let s:save_search = @/
	endif
    endif
endfunction
function! s:OnWinEnter()
    if exists('w:SearchPatternScoped')
	let @/ = w:SearchPatternScoped
    elseif exists('t:SearchPatternScoped')
	let @/ = t:SearchPatternScoped
    else
	let @/ = s:save_search
    endif
endfunction
function! s:OnTabEnter()
    if ! exists('w:SearchPatternScoped')
	if exists('t:SearchPatternScoped')
	    let @/ = t:SearchPatternScoped
	else
	    let @/ = s:save_search
	endif
    endif
endfunction

function! SearchPatternPerScope#TabLocal()
    if exists('t:SearchPatternScoped') | return | endif

    if exists('w:SearchPatternScoped')
	let t:SearchPatternScoped = s:save_search
    else
	let t:SearchPatternScoped = @/
	let s:save_search = @/
    endif
endfunction
function! SearchPatternPerScope#NoTabLocal()
    if ! exists('w:SearchPatternScoped')
	let @/ = s:save_search
    endif
    unlet! t:SearchPatternScoped
endfunction
function! SearchPatternPerScope#WinLocal()
    if exists('w:SearchPatternScoped') | return | endif

    let w:SearchPatternScoped = @/
    if ! exists('t:SearchPatternScoped')
	let s:save_search = @/
    endif
endfunction
function! SearchPatternPerScope#NoWinLocal()
    if exists('t:SearchPatternScoped')
	let @/ = t:SearchPatternScoped
    else
	let @/ = s:save_search
    endif
    unlet! w:SearchPatternScoped
endfunction

function! SearchPatternPerScope#EnableTabAutocmds()
    augroup SearchPatternPerTab
	autocmd! TabEnter * call <SID>OnTabEnter()
	autocmd! TabLeave * call <SID>OnTabLeave()
    augroup END
endfunction
function! SearchPatternPerScope#DisableTabAutocmds()
    autocmd! SearchPatternPerTab
endfunction
function! SearchPatternPerScope#EnableWinAutocmds()
    augroup SearchPatternPerWin
	autocmd! WinEnter * call <SID>OnWinEnter()
	autocmd! WinLeave * call <SID>OnWinLeave()
    augroup END
endfunction
function! SearchPatternPerScope#DisableWinAutocmds()
    autocmd! SearchPatternPerWin
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
