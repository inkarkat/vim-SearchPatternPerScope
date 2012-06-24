" SearchPatternPerTab.vim: Maintain separate search patterns (@/) per tab page. 
"
" DESCRIPTION:
" USAGE:
" INSTALLATION:
"   Put the script into your user or system Vim plugin directory (e.g.
"   ~/.vim/plugin). 

" DEPENDENCIES:
"   - Requires Vim 7.0 or higher. 

" CONFIGURATION:
" INTEGRATION:
" LIMITATIONS:
" ASSUMPTIONS:
" KNOWN PROBLEMS:
"   - The 'hlsearch' setting is still global, so a search / goto match / etc. in
"     one tab undoes the effects of a :nohlsearch command in another tab. This
"     cannot be solved within the autocmds, because the effects of :nohlsearch
"     are undone; cp. |function-search-undo|. 
"
" TODO:
"
" Copyright: (C) 2009 by Ingo Karkat
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

augroup SearchPatternPerTab
    autocmd! TabEnter * if exists('t:SearchPattern') | let @/ = t:SearchPattern | endif
    autocmd! TabLeave * let t:SearchPattern = @/
augroup END

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
