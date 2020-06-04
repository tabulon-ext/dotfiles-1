" Shared initialization commands.  Sourced from both init.vim (Neovim) and vimrc (Vim).

" Vim comes with some bundled plugins in various subdirectories of $VIMRUNTIME.  Those in
" plugin/ are enabled by default but there are some more in pack/dist/opt/ and macros/
" that are not.  TODO: take a look if any should be dis- or enabled.

" Remove all autocommands for the 'vimrc_common' group.  I was using the default unnamed
" group for all autocommands in my vimrc files before and just ran `autocmd!` without
" setting the group (using the default group implicitly).  This was causing issues as some
" of the bundled VimL files also use the default group so sourcing this file again after
" startup would kill their autocommands as well (e.g., syntax highlighting did stop being
" enabled automatically in new buffers).  I think the default autocommand group should be
" reserved for users, but alas...
augroup vimrc_common
   autocmd!
augroup END

" Conditonally loaded plugins {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins are loaded after vimrc files (:h initialization).

" This is needed because we call `operator#user#define_ex_command` later (by sourcing
" `vim-autoformat.vim`).  TODO: find a better way.
packadd! vim-operator-user

" FIXME: vim-man doesn't work in Neovim 0.2.2.  The :Man command fails to open any man
" page.  (The latest commit to vim-man is cfdc78f52707b4df76cbe57552a7c8c28a390da4.)
if !has('nvim')
   packadd! vim-man
endif

if has('unix')
   packadd! vim-dict
endif

" Automated management of tag files.  I chose [Gutentags][1] semi-randomly: it has some
" cool features like incremental tags generation but [there][2] [are][3] [many][4]
" [similar][5] [plugins][6], none of which I tried.
" [1]: https://github.com/ludovicchabant/vim-gutentags
" [2]: https://github.com/basilgor/vim-autotags
" [3]: https://github.com/soramugi/auto-ctags.vim
" [4]: https://github.com/craigemery/vim-autotag
" [5]: https://github.com/szw/vim-tags
" [6]: https://github.com/xolox/vim-easytags
if executable('ctags')
   packadd! vim-gutentags
end

" TODO: Investigate whether pastery.vim still considerably slows down starting Vim.  See
" <https://github.com/skorokithakis/pastery.vim/issues/2>.
if has('unix')
   packadd! pastery.vim
endif

" I'm using the fzf package from Arch's community repository, but that doesn't include the
" `fzf.vim` file.  Adding fzf as a Vim plugin here only serves to get that file.  TODO:
" find a way to only sync the .vim file?
if executable('fzf')
   packadd! fzf
   packadd! fzf.vim
endif

" Snippet engine using Python.  Doesn't define any snippets by itself; they are in
" honza/vim-snippets (but I'm only using my own snippets at the moment).
if has('python') || has('python3') " TODO: is this what we should check?
   packadd! ultisnips
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Basic settings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Stuff taken from sensible.vim {{{2

" Most (all?) of this is probably redundant for Neovim.  TODO: move it into vim/vimrc?
" There probably also are more settings scattered around this file that belong in this
" section.

" TODO: plugins are loaded after personal vimrc files; should this command therefore be at
" the very end of this file or in a different file inside an after/ subdirectory?
runtime! macros/matchit.vim " Load matchit.vim.

" Don't scan included files for keyword completion.
set complete-=i " Keep?  See <https://github.com/tpope/vim-sensible/issues/51>.

" See <https://github.com/tpope/vim-sensible/issues/13>.
set viminfo^=!

if v:version > 703 || v:version == 703 && has('patch541')
   set formatoptions+=j " Delete comment character when joining commented lines.
endif

" Search the 'tags' file in the directory of the current file,
" then the parent directory, then the parent of that, and so on.  The leading './' tells
" Vim to use the directory of the current file rather than Vim's working directory.  The
" trailing semicolon tells it to recursively search parent directories.  See
" :h file-searching.
if has('path_extra')
   setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

" }}}2
" Stuff that used to be part of sensible.vim {{{2

" Enabling 'lazyredraw' causes slight visual glitches sometimes.  It [made][1] [it's][2]
" [way][3] into sensible.vim, but [was removed][4] again.
" [1]: https://github.com/tpope/vim-sensible/issues/78
" [2]: https://github.com/tpope/vim-sensible/pull/89
" [3]: https://github.com/tpope/vim-sensible/commit/2fb074e
" [4]: https://github.com/tpope/vim-sensible/commit/9e91be7
set nolazyredraw " This currently is the default.

" Make Y consistent with C and D.  See `:h Y` and `:h &`.  Additionally, change & to
" *exactly* repeat the last substitute (it drops any flags by default).  These three lines
" were removed from sensible.vim by [e48a405][].
nnoremap Y y$
nnoremap & :&&<CR>
xnoremap & :&&<CR>
" [e48a405]: https://github.com/tpope/vim-sensible/commit/e48a40534c132e6dd88176b666a8b1ff

" }}}2
" Use <Space> as <Leader> and <BS> as <LocalLeader>.
let mapleader = ' '
let maplocalleader = '\'
" Make sure <Space> doesn't do anything by itself.
map <Space> <Nop>

" Use Unix-style line endings for new buffers and files on Windows too.
if has('win32')
   set fileformat=unix
   set fileformats=unix,dos
endif

" Don't silently fix my shitty files.  I don't want noisy diffs.
set nofixeol

" Ubuntu 13.10 disables this by sourcing /usr/share/vim/vim74/debian.vim.
set modeline

" Don't automatically yank all visual selections into the "* register.
set clipboard-=autoselect

" Make ^X^K work without having spell checking enabled (without `:set spell`).
set dictionary+=spell

set noshowcmd

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display relative line numbers, but the absolute line number in front of the cursor line.
" Useful when preceding vertical motion commands that support it with a count, e.g. d4j.
set number
set relativenumber " Slows Vim down a lot.  Worth disabling in long files with complex
                   " syntax highlighting sometimes (unimpaired.vim maps this to [or, ]or
                   " and cor).  'cursorline' is similar.
set numberwidth=4  " Minimal number of columns to use for line numbers.  The value
                   " accounts for one space that is always added between the line numbers
                   " and the text.  4 means that the width has to be increased in buffers
                   " with 1000 or more lines.  Bigger values can look nicer when
                   " 'colorcolumn' is used, because the highlighted columns of horizontal
                   " splits are more likely to line up.

" Display relative line numbers (absolute for line cursor is in) in the focused window,
" and absolute in other windows.
" autocmd vimrc_common WinEnter,FocusGained * if &nu == 1 | setl rnu | endif
" autocmd vimrc_common WinLeave,FocusLost * if &nu == 1 | setl nornu | endif

set norelativenumber " It's just to slow on my laptop...
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Command-line completion (:h cmdline-completion)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu " Use the enhanced command-line completion menu where 'full' is specified in
             " 'wildmode'.
" When 'wildchar' (Tab) is used first, and more than one match exists, list all matches
" and complete till longest common string.  On consecutive uses (or if only one match
" exists) show the 'wildmenu'.
set wildmode=longest:full,full

" Patterns to ignore when expanding wildcards:
set wildignore+=.hg/,.git/,.svn/                     " version control stuff
set wildignore+=*.aux,*.out,*.toc                    " LaTeX auxiliary files
set wildignore+=_minted-*/                           " minted cache directory
set wildignore+=*.o                                  " object files
set wildignore+=*.bmp,*.gif,*.jpeg,*.jpg,*.pdf,*.png " more binary files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nowrap
set sidescroll=1 " Scroll horizontally smoothly (one column at a time) instead of jumping.

set title " Let vim set the terminal title.

set scrolloff=2   " Always keep 2 lines above and below the cursor.
set hidden        " Only hide (don't unload) a buffer when abandoned.
set laststatus=2  " Always show a status line.
set showtabline=0 " Never display tab labels.

" Required by delimitMate for delimitMate_expand_cr to work.  TODO: move this to vimrc:
" this already is the Neovim default.
set backspace=indent,eol,start

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" I used to prefer tabs for indenting and spaces for alignment (like item 4 from
" :h 'tabstop').  That was supposed to allow using different numbers of spaces when
" displaying a tab.
" Because different values will still cause different text widths, I prefer not to use any
" tabs now (item 2 from :h 'tabstop').

set tabstop=8      " A <Tab> counts for 8 spaces.
set softtabstop=-1 " Or does it?
set shiftwidth=3   " Use 3 spaces for each step of (auto)indent.
set shiftround     " Round indent to multiple of 'shiftwidth' when using < and >
                   " commands.
set expandtab      " Use CTRL-V<Tab> to insert a real tab.
set copyindent     " Copy the structure of an existing line's indent when autoindenting
                   " a new line; ensures spaces are used for alignment.
set preserveindent " When changing the indent of the current line, do not replace the
                   " existing indent structure by a series of tabs followed by spaces;
                   " instead preserve as many existing characters as possible, and only
                   " add additional tabs or spaces as required.
set autoindent     " The last two settings only seem to work with this enabled.

" Tweak what automatic indenting does when 'cindent' is enabled.  See `indent.txt` and
" 'cindent' and 'cinoptions'.  Maybe <https://vim.fandom.com/wiki/Indenting_source_code>
" as well.  Note that 'cindent' is automatically enabled for C and C++ files (e.g. from
" `/usr/share/nvim/runtime/indent/c.vim` or `cpp.vim`, try `:verb set cindent?`).  TODO:
" Python (see <https://orchistro.tistory.com/236>).
set cinoptions=g.501s,h.499s,N-s,(0,Ws

set linebreak             " Wrap lines at characters in 'breakat', not at the last
if exists('&breakindent') " character that fits on the screen.
   set breakindent        " Continue lines at their indentation level when wrapping.
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set undofile " Make undo history persistent.

" TODO: what was the idea with this?
" set viminfo^=%

set shortmess+=I " Don't give the intro message when starting Vim.

" Make a persistent backup whenever writing a file, potentially overwriting an existing
" backup (even if that file isn't the one being backed up; i.e., when different files
" having the same name are edited).
set backup
set writebackup

" Use the 'en_us' instead of the 'en' word list as the default for spell checking.  This
" helps with consistently using one spelling when (e.g.) American and British English
" differ (color, colour; gray, grey, ...).  I'm using the American instead of the British
" (or any other) word list for no particular reason; the point is just to have Vim help
" with spelling stuff in one way consistently (one thing I prefer about American English
" is that spellings are usually shorter than their British counterparts, though).  Note
" that the highlighting for misspellings that would be correct according to another
" regional variety of English are highlighted differently than other spelling errors.  See
" `:h spell`.
set spelllang=en_us

set winminwidth=0 winminheight=0

" Plugin settings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" netrw, vim-dirvish, open-browser.vim {{{2
" Disable netrw by [pretending it's already loaded][1].  I use [dirvish.vim][2], which
" [doesn't depend on netrw][3], and [open-browser.vim][4] (to replace netrw's gx mapping)
" instead.
" [1]: http://stackoverflow.com/a/21687112
" [2]: http://github.com/justinmk/vim-dirvish
" [3]: http://reddit.com/comments/4l00pj//d3j7a8j
" [4]: http://github.com/tyru/open-browser.vim
let loaded_netrwPlugin = 1

" Use gx to open the URL the cursor is on.  If the cursor doesn't appear to be on a URL,
" do a web search for the word it's on instead.
nmap gx <Plug>(openbrowser-smart-search)
" Ditto for visual mode.
xmap gx <Plug>(openbrowser-smart-search)

" Search with DuckDuckGo by default.
let g:openbrowser_default_search = 'duckduckgo'

" textobj-word-column.vim {{{2
" Skip the plugin's default mappings: they conflict with those of vim-textobj-comment.
let g:skip_default_textobj_word_column_mappings = 1
xnoremap <silent> ab :<C-U>call TextObjWordBasedColumn('aw')<CR>
xnoremap <silent> aB :<C-U>call TextObjWordBasedColumn('aW')<CR>
xnoremap <silent> ib :<C-U>call TextObjWordBasedColumn('iw')<CR>
xnoremap <silent> iB :<C-U>call TextObjWordBasedColumn('iW')<CR>
onoremap <silent> ab :call TextObjWordBasedColumn('aw')<CR>
onoremap <silent> aB :call TextObjWordBasedColumn('aW')<CR>
onoremap <silent> ib :call TextObjWordBasedColumn('iw')<CR>
onoremap <silent> iB :call TextObjWordBasedColumn('iW')<CR>

" Source separate configuration files.  See `:h filename-modifiers`, `:h fnamemodify` and
" <http://ryrych.pl/protips/2016-04-23-splitting-vim-config-into-modules-protip/>.  I used
" to just use the `:source` command with an absolute path (~/.vim/...); that broke when I
" symlinked to my Vim configuration from `~/vimfiles` on Windows.
let s:vimrc_path = fnamemodify($MYVIMRC, ':h') . '/'
exe 'so ' . s:vimrc_path . 'vim-autoformat.vim'

" neomake {{{2
let g:neomake_echo_current_error = 0
let g:neomake_place_signs = 0

" commentary.vim {{{2
" Adjust commentstring for C++ so commentary.vim uses C++-style comments.  TODO: see
" `:h ftplugin-overrule`.
autocmd vimrc_common FileType cpp setlocal commentstring=//%s
autocmd vimrc_common FileType markdown setlocal commentstring=<!--%s-->

" vim-markdown {{{2
" let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_no_default_key_mappings = 1

" vim-instant-markdown {{{2
" let g:instant_markdown_slow = 1
" let g:instant_markdown_autostart = 0

" lightline.vim {{{2
let g:lightline = {
   \ 'colorscheme': 'default',
\ }
" :h line-continuation, :h dict

" Based on the snippet from :h lightline-problem-13.  Also see issue #9 on Github:
" ["Changing colorscheme on the fly"](https://github.com/itchyny/lightline.vim/issues/9).
autocmd vimrc_common ColorScheme * call s:lightline_update()
function! s:lightline_update() " Local to this file.
   " FIXME: only list color schemes where the name of the lightline color scheme differs
   " from the one of the matching Vim color scheme.  Use a directory listing of
   " lightline.vim/autoload/lightline/colorscheme/ for everything else.
   let colos = {
      \ 'molokai': 'molokai',
      \ 'wombat256mod': 'wombat',
      \ 'solarized': 'solarized_dark',
      \ 'landscape': 'landscape',
      \ 'jellybeans': 'jellybeans',
      \ 'jellyjam': 'jellyjam',
      \ 'Tomorrow-Night': 'Tomorrow_Night',
      \ 'PaperColor': 'PaperColor_dark',
   \ }
   let newColo = 'default'
   " if exists('g:colors_name') && exists("colos['" . g:colors_name . "']")
   if exists('g:colors_name') && has_key(colos, g:colors_name)
      let newColo = colos[g:colors_name]
   endif
   if g:lightline.colorscheme !=# newColo
      let g:lightline.colorscheme = newColo
      if exists('g:loaded_lightline')
         call lightline#init()
         call lightline#colorscheme()
         call lightline#update()
      endif
   endif
endfunction

" }}}2
" vim-indent-guides {{{2
" let g:indent_guides_start_level = 2
" let g:indent_guides_guide_size = 1

" vim-gitgutter {{{2
let g:gitgutter_enabled = 0  " Turn vim-gitgutter off by default.
let g:gitgutter_realtime = 0 " Don't trigger sign updates when not typing.
let g:gitgutter_eager = 0    " Update signs less often; mostly just when writing a buffer.

" vim-table-mode {{{2
" Allow starting vim-table-mode with `<Leader>tm` in addition to `:TableModeToggle`.  This
" mapping is only required because I use vim-plug's on-demand loading for vim-table-mode
" (there's an equivalent vim-table-mode default mapping).
nnoremap <silent> <Leader>tm :TableModeToggle<CR>

" delimitMate {{{2
let delimitMate_expand_space = 1
let delimitMate_expand_cr = 1
let delimitMate_balance_matchpairs = 1

" vim-man {{{2
" Always render man pages at this width, regardless of the size of the window.  See
" <https://github.com/vim-utils/vim-man/issues/14>.
let g:man_width = 93

" pastery.vim {{{2
let g:pastery_open_in_browser = 1
runtime pastery-api-key.vim

" vim-rooter {{{2
let g:rooter_silent_chdir = 1

" vim-dict {{{2
" Use local DICT daemon for speed.  These are all databases I have installed.  They are
" listed explicitly to change the order ['*'] would use.
let g:dict_hosts = [
   \ ['localhost', ['gcide', 'eng-deu', 'deu-eng', 'foldoc', 'wn']],
\ ]

" vim-gutentags {{{2
" See `:helpgrep gutentags_cache_dir` and
" <https://wiki.archlinux.org/index.php/XDG_Base_Directory>.
let g:gutentags_cache_dir = '~/.cache/gutentags'

" ultisnips {{{2
" Apparently, getting <C-Tab> to work in xterm is [pretty complicated][1] so I should
" probably remap g:UltiSnipsListSnippets instead.  Meta doesn't seem to work in a terminal
" either and remapping escape has its own problems.
" [1]: http://stackoverflow.com/a/2695818
let g:UltiSnipsExpandTrigger = '<C-J>'
" let g:UltiSnipsExpandTrigger = '<Tab>'  " Makes <Tab> laggy.
" let g:UltiSnipsExpandTrigger = '<C-CR>' " Only works in gVim.
" let g:UltiSnipsExpandTrigger = 'q'
let g:UltiSnipsJumpForwardTrigger = '<C-L>'
let g:UltiSnipsJumpBackwardTrigger = '<C-B>'
" These key combinations are more or less available and could also be used:
" i_CTRL-Q, i_CTRL-L, i_CTRL-B, i_CTRL-F, i_CTRL-Z, i_CTRL-M, i_CTRL-J, i_CTRL-_ (this
" seems to be inserted by <C-?>), i_CTRL-\, i_CTRL-G

" unite.vim {{{2
" Replace the built-in z= mapping with a less obtrusive interface based on unite.vim.
nnoremap z= :Unite spell_suggest<CR>

" goyo.vim {{{2
let g:goyo_height = '100%'
function! s:GoyoToggle()
   if !exists('#goyo')
      " Set the window width based on the local 'textwidth' (unless it's 0) instead of
      " g:goyo_width.  Add 1 so Vim doesn't scroll horizontally when the cursor is behind
      " the last character in a full line.
      exe ':Goyo' . (&textwidth ? &textwidth + 1 : '')
      set showmode
   else
     Goyo
     if exists('g:loaded_lightline')
        set noshowmode
     endif
   endif
endfunction
nnoremap <silent> Q :call <SID>GoyoToggle()<CR>

" Not-so-basic settings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Draw a continuous line to separate vertical splits.
if has('multi_byte') | :set fillchars=vert:│ | endif

" [Open help in the current window](http://stackoverflow.com/a/26431632)
" :h 'buftype'
command! -nargs=1 -complete=help H :enew | :set buftype=help | :h <args>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Molokai sets 'background' to light for some reason.  The issue has been reported here:
" <https://github.com/tomasr/molokai/issues/22>.
autocmd vimrc_common ColorScheme * if exists('g:colors_name') &&
   \ (g:colors_name ==# 'molokai' || g:colors_name ==# 'jellybeans') |
   \ noa set bg=dark | endif

" Use a darker background with the lucius color scheme.
let g:lucius_contrast_bg = 'high'

" For C++ and C: don't highlight {}; inside [] and () as errors.
let c_no_curly_error = 1

set background=dark

if !has('gui_running')
   let g:solarized_termcolors = 256
   silent! colorscheme jellyjam
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" These autocommands are to slow on my laptop.  TODO: use a mapping to correct syntax
" highlighting issues when they really occur instead?
" autocmd vimrc_common BufEnter * if &ft != 'help' | syntax sync fromstart | endif
" autocmd vimrc_common BufEnter * if line('$') <= 3000 | syntax sync fromstart | endif
" To check the active synchronization method use ':sy[ntax] sync'.
" http://vim.wikia.com/wiki/Fix_syntax_highlighting

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight trailing whitespace unless it's in the current line, left of the cursor and
" Vim is in insert mode.  Always highlight tabs that aren't at the start of a line (TODO:
" disable if tabstop is 8?).  I'm using the ColorColumn highlight group instead of
" defining a new one.  TODO: disable for commit messages and netrw?

" This is much faster than using `:syntax match`.  Changing the pattern when entering and
" leaving insert mode also wasn't viable with `:syn clear ColorColumn` and `:syn match`
" since it caused noticeable delay every time.
function! s:OnInsertEnter()
   if exists('w:spaceMatch') | silent! call matchdelete(w:spaceMatch) | endif
   let w:spaceMatch = matchadd('ColorColumn', '\s\+\%#\@<!$', -1)
   " TODO: is there a potentially faster pattern?
endfunction
function! s:OnInsertLeave()
   if exists('w:spaceMatch') | silent! call matchdelete(w:spaceMatch) | endif
   " Use a cheap pattern that doesn't check the cursor position in normal mode.
   let w:spaceMatch = matchadd('ColorColumn', '\s\+$', -1)
endfunction
function! s:OnBufWinEnter()
   " if &modifiable && !&readonly
   if &filetype !=# 'help' && &filetype !=# 'man' && &filetype !=# 'unite'
      call s:OnInsertLeave()
      if !exists('w:tabMatch')
         let w:tabMatch = matchadd('ColorColumn', '[^\t]\zs\t\+', -1)
      endif
   else
      if exists('w:spaceMatch')
         silent! call matchdelete(w:spaceMatch)
         unlet w:spaceMatch
      endif
      if exists('w:tabMatch')
         silent! call matchdelete(w:tabMatch)
         unlet w:tabMatch
      endif
   endif
endfunction
function! s:OnWinEnter()
   if !exists('w:spaceMatch') || !exists('w:tabMatch')
      call s:OnBufWinEnter()
   end
endfunction
autocmd vimrc_common InsertEnter * call s:OnInsertEnter()
autocmd vimrc_common InsertLeave * call s:OnInsertLeave()
autocmd vimrc_common BufWinEnter * call s:OnBufWinEnter() " Insufficient.  Try :split
autocmd vimrc_common WinEnter    * call s:OnWinEnter()    " without this.
autocmd vimrc_common FileType    * call s:OnBufWinEnter()

" Don't break when sourcing again.
if exists('w:spaceMatch') || exists('w:tabMatch')
   silent! unlet w:spaceMatch | silent! unlet w:tabMatch
   call clearmatches()
   call s:OnBufWinEnter()
endif

" Use :echo getmatches() to confirm we don't leak matches.  This snippet should never
" create more than two.
" Based on snippets from <http://vim.wikia.com/wiki/Highlight_unwanted_spaces>.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TODO: explain.
if has('unix')
   let s:vimfiles = $HOME . '/.vim'
elseif has('win32')
   " Use $HOME or $USERPROFILE?
   let s:vimfiles = $HOME . '/vimfiles'
endif
if exists('s:vimfiles')
   if !isdirectory(s:vimfiles . '/swp')
      call mkdir(s:vimfiles . '/swp', 'p')
   endif
   if !isdirectory(s:vimfiles . '/undo')
      call mkdir(s:vimfiles . '/undo', 'p')
   endif
   if !isdirectory(s:vimfiles . '/backup')
      call mkdir(s:vimfiles . '/backup', 'p')
   endif
   let &dir = s:vimfiles . '/swp//'
   let &undodir = s:vimfiles . '/undo'
   let &backupdir = s:vimfiles . '/backup'
endif
" http://stackoverflow.com/questions/1549263/how-can-i-create-a-folder-if-it-doesnt-exist-
" http://vim.wikia.com/wiki/Automatically_create_tmp_or_backup_directories

" Use the 'colorcolumn' option to highlight the first column after 'textwidth' in the
" focused window, but only if the buffer is 'modifiable' and 'noreadonly'.
autocmd vimrc_common WinEnter * if &ma && !&ro | setl cc=+1 | endif
autocmd vimrc_common WinLeave * setl cc=
" WinEnter isn't triggered when loading a new buffer into the current window.
autocmd vimrc_common BufWinEnter * if &ma && !&ro | setl cc=+1 | endif

" Alias for the :SudoWrite command from [eunuch.vim](https://github.com/tpope/vim-eunuch):
" use :W to write the current file with sudo.
if has('unix')
   command! -bar W :SudoWrite
endif

" React to <Esc> immediately (unless it were a proper prefix of a mapping which, of
" course, it isn't).  To be honest, I don't really understand what's going on here.  I
" realize that terminal emulators send key sequences starting with Escape for (at least)
" function keys and arrow keys to the running application.  Vim will wait for more
" characters after receiving the Escape character while it's ambiguous whether those keys
" will make up an escape sequence.  With default settings, Vim will stop waiting after
" 1000 milliseconds (value of 'timeoutlen', used as key code delay when 'ttimeoutlen' is
" negative) of not receiving any additional character and handle the key sequence.  This
" delay seems extremely excessive.  Vim should receive the complete escape sequence
" resulting from function keys etc. nearly at the same instant.  I'm using 0 for
" 'ttimeoutlen' since it doesn't seem to break anything.  I guess around 10 might be more
" conservative.  See :h timeout, :h ttimeoutlen, :h timeoutlen, :h ttimeoutlen, :h esckeys
" http://stackoverflow.com/q/15550100
" http://superuser.com/q/161178
" http://aperiodic.net/phil/archives/Geekery/term-function-keys.html
if !has('gui_running')
   set ttimeoutlen=0
endif

" If we have `rg`, use it to `:grep`.  If we don't have `rg` but have Ag, use Ag.  TODO:
" There are lots of related plugins [1][2][3][4].  Do they provide worthwhile improvements
" compared to just setting 'grepprg'?
if executable('rg')
   set grepprg=rg\ --vimgrep
   set grepformat=%f:%l:%c:%m
elseif executable('ag')
   " I copied this from ag(1); search for `--vimgrep`.  Also see [5], [this comment][6] by
   " Romain Lafourcade, and these [two][7] [posts][8].  TODO: are the :Grep and :LGrep
   " commands from Romain's comment cool?
   set grepprg=ag\ --vimgrep
   set grepformat=%f:%l:%c:%m
endif
" [1]: https://github.com/rking/ag.vim
" [2]: https://github.com/mileszs/ack.vim
" [3]: https://github.com/mhinz/vim-grepper
" [4]: https://github.com/Chun-Yang/vim-action-ag
" [5]: https://www.vi-improved.org/recommendations/
" [6]: https://reddit.com/comments/4gjbqn//d2iatu9
" [7]: https://codeinthehole.com/tips/using-the-silver-searcher-with-vim/
" [8]: https://robots.thoughtbot.com/faster-grepping-in-vim

" I got this from <https://noahfrederick.com/log/vim-streamlining-grep>.  TODO: consider
" this: <https://redd.it/fu9v18>.
cnorea <expr> grep  getcmdtype() == ':' && getcmdline() =~# '^grep'  ? 'sil gr'  : 'grep'
cnorea <expr> gre   getcmdtype() == ':' && getcmdline() =~# '^gre'   ? 'sil gr'  : 'gre'
cnorea <expr> gr    getcmdtype() == ':' && getcmdline() =~# '^gr'    ? 'sil gr'  : 'gr'
cnorea <expr> lgrep getcmdtype() == ':' && getcmdline() =~# '^lgrep' ? 'sil lgr' : 'lgrep'
cnorea <expr> lgre  getcmdtype() == ':' && getcmdline() =~# '^lgre'  ? 'sil lgr' : 'lgre'
cnorea <expr> lgr   getcmdtype() == ':' && getcmdline() =~# '^lgr'   ? 'sil lgr' : 'lgr'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make K a well-behaved citizen.  See :h ft-man-plugin, :h find-manpage, :h K, :h v_K,
" :h 'keywordprg'.  TODO: add a vmap for K that works like the built-in mapping.

" XXX: will this always be run AFTER 'keywordprg' was changed?
function! s:FixK()
   if &ft ==# 'vim'
      silent! unmap <buffer> K
      setl keywordprg=:help
   elseif &keywordprg ==# ':help'
      setl keywordprg=man
   elseif &keywordprg ==# 'man'
      " I'm using the vim-man plugin.
      nmap <buffer> K <Plug>(Man)
   else
      silent! unmap <buffer> K
   endif
endfunction
autocmd vimrc_common FileType * call s:FixK()
autocmd vimrc_common BufWinEnter * if empty(&ft) | call s:FixK() | endif

" [Help for word under cursor](http://stackoverflow.com/a/15867465)
" https://github.com/vim-utils/vim-man
" http://vim.wikia.com/wiki/Open_a_window_with_the_man_page_for_the_word_under_the_cursor
" http://vim.wikia.com/wiki/View_man_pages_in_Vim
" http://usevim.com/2012/09/07/vim101-keywordprg/
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Mappings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" By default, <Tab> and <C-I> perform the same command in Vim.  Remap <Tab> to toggle
" folds without overriding <C-I> (it still goes forward in the jump list).  This is
" accomplished by configuring xterm to send ÿ (just a random replacement character I
" chose) when <C-I> is pressed, so we can distinguish <Tab> and <C-I>.  The reason this
" has to be so awful is that we can't just remap <Tab> individually because terminals
" normally send the same byte for <Tab> and <C-I>.
if !has('gui_running')
   nnoremap ÿ <C-I>
   nnoremap <Tab> za
else
   " TODO?  I think this isn't straightforward in gvim either and I don't care too much
   " right now.
endif

nnoremap j gj
nnoremap k gk

" Heresy refined.  Courtesy of Steve Losh (found in a discussion of his Vim configuration
" on Hacker News: <https://news.ycombinator.com/item?id=3252644>).
inoremap <C-A> <Home>
inoremap <C-E> <End>

" Use the semicolon key to enter Ex commands.  The key is available thanks to
" [clever-f.vim](https://github.com/rhysd/clever-f.vim).  Also see
" <http://stevelosh.com/blog/2010/09/coming-home-to-vim/>.
noremap ; :
" For consistency, also support opening the command-line window with `q;`.  Don't `nmap`
" because that also adds an operator-pending mapping which incurs a delay when using `gqq`
" (format the current line).  TODO: there's still a delay when using `q` to stop recording
" a macro.
nnoremap q; q:
vnoremap q; q:

" Use . (`:h .`) in visual mode to repeat the last change for each selected line (see
" `:h :normal-range`).  This often doesn't work as expected.  Try repeating `dd`.  The
" mapping doesn't override anything though, so it's probably still worth keeping.  Picked
" up from <https://reddit.com/comments/3y2mgt//cya0x04>.
vnoremap . :norm .<CR>

" Cycle the 'foldlevel' ('fdl').  Kind of like Org-mode's org-shifttab.
function! s:CycleFoldlevel()
   " Remember the current 'foldlevel'.
   let foldlevel = &foldlevel
   " Open more folds (mnemonic: [r]educe folding).  That is, add v:count1 to 'foldlevel'.
   norm zr
   if foldlevel == &foldlevel
      " Nothing happened, there were no more folds to open.  Close all folds (mnemonic:
      " fold [M]ore).
      norm zM
   endif
endfunction
nnoremap <silent> <S-Tab> :call <SID>CycleFoldlevel()<CR>

" Switch windows more easily.  TODO: map <C-H> to something.
nnoremap <silent> <C-J> :normal <C-V><C-W>w<CR>
nnoremap <silent> <C-K> :normal <C-V><C-W>W<CR>

" Control+Q just does the same as Control+V by default; use it to close windows.
nnoremap <C-Q> ZZ
inoremap <C-Q> <Esc>ZZ

" Correct typos in insert mode.  Copied from <https://castel.dev/post/lecture-notes-1/>.
inoremap <C-L> <C-G>u<Esc>[s1z=`]a<C-G>u

" Traverse the change list more quickly.  <C-P> and <C-N> are just duplicates of k and j
" by default.  I added zv to also open just enough folds after moving the cursor to make
" the current line visible.  Directly using the g; and g, mappings already seems to do
" that but the new mappings (without zv) don't for some reason.
nnoremap <C-P> g;zv
nnoremap <C-N> g,zv

" This is alike Emacs, Mutt, Newsboat, ncmpcpp, and cmus.
cnoremap <C-G> <C-U><BS>

let g:qf_auto_open_quickfix = 0
let g:qf_auto_open_loclist = 0
" Mappings for toggling the quickfix and location windows.  I think the default Control+L
" mapping isn't all that useful.
nmap <C-F> <Plug>(qf_qf_toggle_stay)
nmap <C-L> <Plug>(qf_loc_toggle_stay)

" More convenient mappings for maximizing the width or height of the current window.  They
" fall back to the default mappings of | and _ when no count is given (<C-W>| and <C-W>_
" can still be used with a count -- I don't really do that, though, but I don't really use
" | or _ either).  Based on the mappings from [this comment by justinmk][1].
" [1]: http://reddit.com/comments/4jyw8o//d3ayzox
nnoremap <expr> \| !v:count ? '<C-W>\|' : '\|'
nnoremap <expr> _  !v:count ? '<C-W>_'  : '_'
" I find myself using <C-W>= regrettably much; hitting + is faster.  TODO: maybe I
" shouldn't remap both + and <CR>?  XXX: this relies on 'equalalways' not being disabled;
" see <https://stackoverflow.com/a/45591177>.
nnoremap <silent> + :sp \| :q<CR>

" Always go forward with n and backward with N.  Remove the cognitive dissonance after
" forgetting whether the last search was done with '/' or '?'.  See
" <http://stackoverflow.com/q/18523150> and <http://vi.stackexchange.com/q/2365>.
" :noremap adds the mapping for normal, visual, select and operator-pending mode.
noremap <expr> n 'Nn'[v:searchforward]
noremap <expr> N 'nN'[v:searchforward]

" vim-easy-align {{{2
" Operator starting interactive EasyAlign.  Normal and visual mode.
nmap gl <Plug>(EasyAlign)
xmap gl <Plug>(EasyAlign)
" }}}2

function! s:UpdateOrEnableGitGutter()
   if !g:gitgutter_enabled
      " Some of vim-gitgutter's commands don't work after :GitGutterEnable when not also
      " running :GitGutter (e.g. :GitGutterStageHunk).
      return ':GitGutterEnable | GitGutter'
   else
      return ':GitGutter'
   end
endfunction
nnoremap <silent> <expr> <Leader>g <SID>UpdateOrEnableGitGutter() . '<CR>'
nnoremap <silent> <Leader>G :GitGutterDisable<CR>
nnoremap <silent> cog :GitGutterToggle<CR>

" Fix the syntax highlighting.  See `:h :syn-sync-first` and
" <http://vim.wikia.com/wiki/Fix_syntax_highlighting>.
nnoremap <silent> <Leader>s :sy sync fromstart<CR>

" Mappings for visual-split.vim.  They work in normal (with a motion) and visual mode.
" See [1].
xmap <C-W>j <Plug>(Visual-Split-VSSplitBelow)
nmap <C-W>j <Plug>(Visual-Split-SplitBelow)
xmap <C-W>k <Plug>(Visual-Split-VSSplitAbove)
nmap <C-W>k <Plug>(Visual-Split-SplitAbove)
" [1]: https://github.com/wellle/visual-split.vim#remapping

nnoremap <silent> <Leader>c :Gcommit<CR>
nnoremap <silent> <Leader>C :Gcommit --amend<CR>

" Mappings for commands from junegunn's fzf.vim plugin.  Most commands support CTRL-T,
" CTRL-X, and CTRL-V key mappings to open in a new tab, a new split, or a new vertical
" split respectively.
nnoremap <silent> U :Windows<CR>
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>F :Files ~/git<CR>
nnoremap <silent> <Leader>l :Buffers<CR>
nnoremap <silent> <Leader>L :History<CR>
nnoremap <silent> <Leader>a :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>A :Ag <C-R><C-A><CR>
nnoremap <silent> <Leader>: :History:<CR>
nnoremap <silent> <Leader>/ :History/<CR>
nnoremap <silent> <Leader><Leader> :Snippets<CR>
" nnoremap <silent> <Leader>c :Commits<CR>
" nnoremap <silent> <Leader>C :BCommits<CR>

nnoremap <silent> <Leader>m :Neomake<CR>
nnoremap <silent> <Leader>M :Neomake!<CR>

" Remove mappings from a.vim.  TODO: add a mapping using <LocalLeader> that's only active
" for C and C++ files?
silent! nunmap <Leader>ih
silent! nunmap <Leader>is
silent! nunmap <Leader>ihn

" Mappings for pastery.vim commands.
nnoremap <silent> <Leader>p :PasteFile<CR>
vnoremap <silent> <Leader>p :PasteCode<CR>

nnoremap <silent> <Leader>u :update<CR>
nnoremap <silent> <Leader>U :Gwrite<CR>

" Remap <CR> {{{2
" nnoremap <CR> to stop 'hlsearch' highlighting and clear any message displayed on the
" command-line (idea from http://vim.wikia.com/wiki/Highlight_all_search_pattern_matches).
" Remapping <CR> is complicated because care needs to be taken not to break its normal
" function in the command-line window or the quickfix windows (:copen, :lopen).  Fugitive
" also uses <CR> in some of its windows but this doesn't seem to override that mapping (I
" guess fugitive's mapping is added later).
" See <https://redd.it/47ivpz>, <http://stackoverflow.com/a/16360104>, :h :map-local and
" :h :map-silent.
"
" I was using this:
"
"    function! s:RemapEnter()
"       if empty(&buftype) || &buftype ==# 'help'
"          nnoremap <buffer> <silent> <CR> :noh<Bar>:echo<CR>
"       else
"          silent! nunmap <buffer> <CR>
"       end
"    endfunction
"    autocmd vimrc_common BufEnter * call s:RemapEnter()
"
" However, all autocommand events seem to have some shortcomings when used to remap <CR>:
" *   BufReadPost isn't used for buffers without a file (try :new).
" *   Using BufEnter breaks the quickfix windows when entering them with :copen or :lopen.
"     because &buftype is still empty at that point.  It's also run needlessly often.
" *   BufNew is also run too early, I think.
" *   I don't understand when exactly BufAdd is triggered but I think it's also run too
"     early.
" *   Using BufNewFile in addition to BufReadPost still doesn't work for :new (but does
"     for `:e foo` when foo doesn't exist).
" I think using BufEnter, BufReadPost and BufNewFile might work (BufEnter is executed for
" :new and running s:RemapEnter() on the other events seems to unbreak the quickfix
" windows).
" Either way, using the <expr> special argument seems like a much better approach that
" avoids this mess.  See :h <expr> and :h expression-syntax.
function! s:OnEnter()
   let filetypes = [ 'man' ]
   if empty(&buftype) || &buftype ==# 'help' || index(filetypes, &filetype) != -1
      return ':noh | echo'
   else
      return ''
   end
endfunction
nnoremap <silent> <expr> <CR> <SID>OnEnter()
" This works around E481 caused by :noh not accepting a range (just try :noh in visual
" mode).  TODO: it feels pretty inelegant, though.
xnoremap <silent> <expr> <CR> '<Esc>' . <SID>OnEnter() . 'gv'

" After entering a window (WinEnter event) and if the previous window has a height of only
" a single line, change the previous window's height to 0.  This only makes sense when
" 'winminheight' is 0, which is not the default.  XXX: Vim hasn't changed any window
" heights yet when it executes this function.
function! s:RecollapsePreviousWindow()
   let prevWindow = winnr('#')

   if winheight(prevWindow) != 1
      return
   endif

   let columnId = win_screenpos(prevWindow)[1]

   " We use win_screenpos() to determine whether two windows are part of the same column.
   " When the window number argument is invalid it returns [0, 0].
   let firstWinOfCol = prevWindow - 1
   while win_screenpos(firstWinOfCol)[1] == columnId
      let firstWinOfCol = firstWinOfCol - 1
   endwhile
   let firstWinOfCol = firstWinOfCol + 1

   let lastWinOfCol = prevWindow + 1
   while win_screenpos(lastWinOfCol)[1] == columnId
      let lastWinOfCol = lastWinOfCol + 1
   endwhile
   let lastWinOfCol = lastWinOfCol - 1

   if firstWinOfCol == lastWinOfCol
      return
   endif

   " Are we in the same column as before?
   if columnId == win_screenpos(0)[1]
      let curWindow = winnr()
      " We moved down to the column's last window and that window has height 0.
      if curWindow == lastWinOfCol && curWindow > prevWindow && winheight(0) == 0
         let rowOffset = win_screenpos(0)[0] - win_screenpos(prevWindow)[0]
         " If we moved down (e.g.) 3 windows and the row offset is 4, then all the windows
         " between the previously and newly focused one have height 0.  The previously
         " focused window has height 1, which is why we subtract 1 from rowOffset.
         if curWindow - prevWindow == rowOffset - 1
            " Vim's default behavior is all we need in this case.
            return
         endif
      endif
   endif

   " Shrinking a window increases the height of the window below (which is also the
   " numerical successor in terms of winnr()) by an equal amount.  The exception to this
   " is (necessarily) the column's bottommost window.  We don't set the height of that
   " window to 0 because doing so would just enlarge the window above again.
   for i in range(prevWindow, lastWinOfCol - 1)
      if winheight(i) == 1
         execute i . 'resize 0'
      elseif winheight(i) > 1
         return
      endif
   endfor

   " Vim hasn't changed the newly entered window's height yet when this function is
   " executed.
   if winheight(0) == 0
      resize 1
   endif

   " It wasn't sufficient to (implicitly) enlarge windows below prevWindow.  Only now do
   " we consider enlarging windows above prevWindow.  This is in line with how Vim selects
   " what window to shrink when increasing another window's height.  When resizing a
   " window, Vim prefers to accommodate the height of windows below if possible.
   if winheight(lastWinOfCol) == 1
      for i in range(prevWindow - 1, firstWinOfCol, -1)
         if winheight(i) != 0
            execute i . 'resize' (winheight(i) + 1)
            return
         endif
      endfor
   endif
endfunction
autocmd vimrc_common WinEnter * call s:RecollapsePreviousWindow()

" }}}1
" vim: fdm=marker
