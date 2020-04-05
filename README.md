SEARCH PATTERN PER SCOPE
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

Searches are essential for navigation and exploration in Vim. Type "/pattern"
or use the star command, then repeatedly jump to matches via n|/|N. The
search pattern is a global register, so the same pattern applies to all
windows. Usually, this is great, but there can be occasions where one wants to
maintain a different search pattern in a window, or an entire tab. Some use a
workflow where related files are grouped in a tab page, but different,
unrelated projects are opened in parallel in tabs. Though you can restore a
previous search pattern in the search command-line (&lt;Up&gt;), this is tedious.

This plugin segregates the search pattern quote/ into tab page- or window-local
scopes, either globally for all, or on demand for selected ones. When you
change the search pattern in one of those localized scopes, it will not affect
the other windows; i.e. as soon as you move out of the scope, the global
pattern (or a different one from another local scope) will be restored.
The provided mappings are useful for doing some quick exploration of the current
buffer. Split it, and freely perform queries, jump around, investigate. When
you close the tab page / window (or move out of it), the original search
pattern will be restored.

### HOW IT WORKS

When you define a local scope for the first time, autocmds are established
that save and restore the contents of the quote/ register.

### SEE ALSO

USAGE
------------------------------------------------------------------------------

    :SearchPatternPerTab [{pattern}]
                            Maintain a separate search pattern quote/ per tab
                            page. From now on, searches only affect the search
                            pattern of the current tab page.
    :NoSearchPatternPerTab  Revert to a single global search pattern for all tab
                            pages.

    :SearchPatternTabLocal [{pattern}]
                            Maintain a separate search pattern quote/ for the
                            current tab page. Other tab pages will keep the global
                            search pattern.
    :NoSearchPatternTabLocal
                            Discard the search pattern for the current tab page
                            and use the global one for this tab page again.

    CTRL-W T                Clone the current window to a new tab page and
                            maintain a separate search pattern in that tab page.

    :SearchPatternPerWin [{pattern}]
                            Maintain a separate search pattern quote/ per window.
                            From now on, searches only affect the search pattern
                            of the current window.
    :NoSearchPatternPerWin  Revert to a single global search pattern for all
                            windows.

    :SearchPatternWinLocal [{pattern}]
                            Maintain a separate search pattern quote/ for the
                            current window. Other windows will keep the global
                            search pattern.
    :NoSearchPatternWinLocal
                            Discard the search pattern for the current window and
                            use the global one for this window again.

    CTRL-W S                Split the current window and maintain a separate
                            search pattern in that window.

    Note that there is still a single, global history of search patterns.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-SearchPatternPerScope
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim SearchPatternPerScope*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

By default, the plugin is disabled; you need to enable it locally
(:SearchPatternTabLocal / :SearchPatternWinLocal) or globally
(:SearchPatternPerTab / :SearchPatternPerWin) first. If you always want
tab-local / window-local search patterns:

    :let g:SearchPatternPerTab = 1
    :let g:SearchPatternPerWin = 1

If you want to use different mappings, map your keys to the
&lt;Plug&gt;(SearchPatternForNew...) mapping targets _before_ sourcing the script
(e.g. in your vimrc):

    nmap <Leader>/s  <Plug>(SearchPatternForNewWin)
    nmap <Leader>/t  <Plug>(SearchPatternForNewTab)

INTEGRATION
------------------------------------------------------------------------------

It is useful to have an indication of whether there is local scoping for the
current window or tab page. You can check for the existence of the

    w:SearchPatternScoped
    t:SearchPatternScoped

variables to build a custom indicator for your 'statusline' or 'titlestring'.

LIMITATIONS
------------------------------------------------------------------------------

- The search register is still global, so with window-local search patterns,
  all other windows will show the matches of the current window's pattern, not
  the pattern that will be active when the window becomes active. This is no
  issue with tab pages because only one can be visible at a time.
- The 'hlsearch' setting is still global, so a search / goto match / etc. in
  one tab undoes the effects of a :nohlsearch command in another tab. This
  cannot be solved within the autocmds, because the effects of :nohlsearch are
  undone; cp. function-search-undo.

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-SearchPatternPerScope/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### GOAL
First published version.

##### 0.01    28-May-2009
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2009-2020 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
