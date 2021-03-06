" SearchPatternPerScope.vim: Maintain separate search patterns ("/) per window / tab page.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.

" Copyright: (C) 2009-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_SearchPatternPerScope') || (v:version < 700)
    finish
endif
let g:loaded_SearchPatternPerScope = 1

let s:save_cpo = &cpo
set cpo&vim

"- configuration ---------------------------------------------------------------

if ! exists('g:SearchPatternPerTab')
    let g:SearchPatternPerTab = 0
endif
if ! exists('g:SearchPatternPerWin')
    let g:SearchPatternPerWin = 0
endif


"- commands --------------------------------------------------------------------

command! -bar -nargs=? SearchPatternPerTab
\   let g:SearchPatternPerTab = 1 |
\   call SearchPatternPerScope#TabLocal() |
\   if ! empty(<q-args>) | let @/ = <q-args> | call histadd('search', @/) | endif |
\   call SearchPatternPerScope#EnableTabAutocmds()
command! -bar NoSearchPatternPerTab
\   let g:SearchPatternPerTab = 0 |
\   call SearchPatternPerScope#DisableTabAutocmds()

command! -bar -nargs=? SearchPatternTabLocal
\   call SearchPatternPerScope#TabLocal() |
\   if ! empty(<q-args>) | let @/ = <q-args> | call histadd('search', @/) | endif |
\   call SearchPatternPerScope#EnableTabAutocmds()
command! -bar NoSearchPatternTabLocal
\   call SearchPatternPerScope#NoTabLocal()


command! -bar -nargs=? SearchPatternPerWin
\   let g:SearchPatternPerWin = 1 |
\   call SearchPatternPerScope#WinLocal() |
\   if ! empty(<q-args>) | let @/ = <q-args> | call histadd('search', @/) | endif |
\   call SearchPatternPerScope#EnableWinAutocmds()
command! -bar NoSearchPatternPerWin
\   let g:SearchPatternPerWin = 0 |
\   call SearchPatternPerScope#DisableWinAutocmds()

command! -bar -nargs=? SearchPatternWinLocal
\   call SearchPatternPerScope#WinLocal() |
\   if ! empty(<q-args>) | let @/ = <q-args> | call histadd('search', @/) | endif |
\   call SearchPatternPerScope#EnableWinAutocmds()
command! -bar NoSearchPatternWinLocal
\   call SearchPatternPerScope#NoWinLocal()


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

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
