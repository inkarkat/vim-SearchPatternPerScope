" SearchPatternPerScope.vim: Maintain separate search patterns (@/) per window / tab page.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.

" Copyright: (C) 2009-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	002	25-Oct-2012	Rename and generalize for both windows and tab
"				pages.
"				Add mappings to clone and localize the search.
"	001	28-May-2009	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_SearchPatternPerScope') || (v:version < 700)
    finish
endif
let g:loaded_SearchPatternPerScope = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:SearchPatternPerTab')
    let g:SearchPatternPerTab = 0
endif
if ! exists('g:SearchPatternPerWin')
    let g:SearchPatternPerWin = 0
endif


"- functions -------------------------------------------------------------------

let s:save_tab_search = ''
function! s:OnTabEnter()
    if exists('t:SearchPatternScoped')
	let @/ = t:SearchPatternScoped
    else
	let @/ = s:save_tab_search
    endif
endfunction
function! s:OnTabLeave()
    if g:SearchPatternPerTab || exists('t:SearchPatternScoped')
	let t:SearchPatternScoped = @/
    else
	let s:save_tab_search = @/
    endif
endfunction

function! s:TabLocal()
    if exists('t:SearchPatternScoped') | return | endif

    let s:save_tab_search = @/
    let t:SearchPatternScoped = @/
endfunction
function! s:NoTabLocal()
    let @/ = s:save_tab_search
    unlet! t:SearchPatternScoped
endfunction

function! s:EnableTabAutocmds()
    augroup SearchPatternPerTab
	autocmd! TabEnter * call <SID>OnTabEnter()
	autocmd! TabLeave * call <SID>OnTabLeave()
    augroup END
endfunction
function! s:DisableTabAutocmds()
    autocmd! SearchPatternPerTab
endfunction


let s:save_win_search = ''
function! s:OnWinEnter()
    if exists('w:SearchPatternScoped')
	let @/ = w:SearchPatternScoped
    else
	let @/ = s:save_win_search
    endif
endfunction
function! s:OnWinLeave()
    if g:SearchPatternPerWin || exists('w:SearchPatternScoped')
	let w:SearchPatternScoped = @/
    else
	let s:save_win_search = @/
    endif
endfunction

function! s:WinLocal()
    if exists('w:SearchPatternScoped') | return | endif

    let s:save_win_search = @/
    let w:SearchPatternScoped = @/
endfunction
function! s:NoWinLocal()
    let @/ = s:save_win_search
    unlet! w:SearchPatternScoped
endfunction

function! s:EnableWinAutocmds()
    augroup SearchPatternPerWin
	autocmd! WinEnter * call <SID>OnWinEnter()
	autocmd! WinLeave * call <SID>OnWinLeave()
    augroup END
endfunction
function! s:DisableWinAutocmds()
    autocmd! SearchPatternPerWin
endfunction


"- commands --------------------------------------------------------------------

command! -bar   SearchPatternPerTab   let g:SearchPatternPerTab = 1 | call <SID>TabLocal() | call <SID>EnableTabAutocmds()
command! -bar NoSearchPatternPerTab   let g:SearchPatternPerTab = 0                        | call <SID>DisableTabAutocmds()
command! -bar   SearchPatternTabLocal                                 call <SID>TabLocal() | call <SID>EnableTabAutocmds()
command! -bar NoSearchPatternTabLocal                                 call <SID>NoTabLocal()

command! -bar   SearchPatternPerWin   let g:SearchPatternPerWin = 1 | call <SID>WinLocal() | call <SID>EnableWinAutocmds()
command! -bar NoSearchPatternPerWin   let g:SearchPatternPerWin = 0                        | call <SID>DisableWinAutocmds()
command! -bar   SearchPatternWinLocal                                 call <SID>WinLocal() | call <SID>EnableWinAutocmds()
command! -bar NoSearchPatternWinLocal                                 call <SID>NoWinLocal()


"- mappings --------------------------------------------------------------------

nnoremap <silent> <Plug>(SearchPatternForNewTab) :<C-u>tab split<Bar>SearchPatternTabLocal<CR>
if ! hasmapto('<Plug>(SearchPatternForNewTab)', 'n')
    nmap <C-w>/<C-t> <Plug>(SearchPatternForNewTab)
endif
nnoremap <silent> <Plug>(SearchPatternForNewWin) :<C-u>split<Bar>SearchPatternWinLocal<CR>
if ! hasmapto('<Plug>(SearchPatternForNewWin)', 'n')
    nmap <C-w>/<C-n> <Plug>(SearchPatternForNewWin)
endif


"-------------------------------------------------------------------------------

if g:SearchPatternPerTab
    SearchPatternPerTab
endif
if g:SearchPatternPerWin
    SearchPatternPerWin
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
