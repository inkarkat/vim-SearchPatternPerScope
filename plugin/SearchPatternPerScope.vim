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
"   1.00.004	30-Oct-2012	Change mappings.
"   1.00.003	29-Oct-2012	Split off autoload script.
"   1.00.002	25-Oct-2012	Rename and generalize for both windows and tab
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


"- commands --------------------------------------------------------------------

command! -bar   SearchPatternPerTab   let g:SearchPatternPerTab = 1 | call SearchPatternPerScope#TabLocal() | call SearchPatternPerScope#EnableTabAutocmds()
command! -bar NoSearchPatternPerTab   let g:SearchPatternPerTab = 0                                         | call SearchPatternPerScope#DisableTabAutocmds()
command! -bar   SearchPatternTabLocal                                 call SearchPatternPerScope#TabLocal() | call SearchPatternPerScope#EnableTabAutocmds()
command! -bar NoSearchPatternTabLocal                                 call SearchPatternPerScope#NoTabLocal()

command! -bar   SearchPatternPerWin   let g:SearchPatternPerWin = 1 | call SearchPatternPerScope#WinLocal() | call SearchPatternPerScope#EnableWinAutocmds()
command! -bar NoSearchPatternPerWin   let g:SearchPatternPerWin =                  0                        | call SearchPatternPerScope#DisableWinAutocmds()
command! -bar   SearchPatternWinLocal                                 call SearchPatternPerScope#WinLocal() | call SearchPatternPerScope#EnableWinAutocmds()
command! -bar NoSearchPatternWinLocal                                 call SearchPatternPerScope#NoWinLocal()


"- mappings --------------------------------------------------------------------

nnoremap <silent> <Plug>(SearchPatternForNewTab) :<C-u>tab split<Bar>SearchPatternTabLocal<CR>
if ! hasmapto('<Plug>(SearchPatternForNewTab)', 'n')
    nmap <C-w>T <Plug>(SearchPatternForNewTab)
endif
nnoremap <silent> <Plug>(SearchPatternForNewWin) :<C-u>split<Bar>SearchPatternWinLocal<CR>
if ! hasmapto('<Plug>(SearchPatternForNewWin)', 'n')
    nmap <C-w>S <Plug>(SearchPatternForNewWin)
endif


"-------------------------------------------------------------------------------

if g:SearchPatternPerTab
    SearchPatternPerTab
endif
if g:SearchPatternPerWin
    SearchPatternPerWin
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
