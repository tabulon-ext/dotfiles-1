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
" reserved for users.
augroup vimrc_common
   autocmd!
augroup END

" vim-plug section {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup vim-plug (https://github.com/junegunn/vim-plug).  Plugins are loaded after vimrc
" files (:h initialization).
call plug#begin('~/.vim/plugged')

Plug 'benekastah/neomake'
Plug 'tpope/vim-dispatch'

Plug 'tpope/vim-repeat' " Used for surround.vim and commentary.vim.

Plug 'moll/vim-bbye' " :bufdo :Bdelete unloads all buffers.
" Plug 'qpkorr/vim-bufkill'

Plug 'wellle/visual-split.vim'

" New or modified text objects and operators.
Plug 'michaeljsmith/vim-indent-object'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'vim-utils/vim-line'
Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user' " Required for vim-textobj-entire
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-operator-user'
Plug 'Chiel92/vim-autoformat'
Plug 'rhysd/vim-clang-format' " Doesn't honor 'textwidth' and breaks undo.  TODO: remove?

" http://reddit.com/r/vim/comments/26mszm/what_is_everyones_favorite_commenting_plugin_and
Plug 'tpope/vim-commentary'
" Plug 'scrooloose/nerdcommenter'
" Plug 'tomtom/tcomment_vim'

" Plug 'easymotion/vim-easymotion'
" Plug 'goldfeld/vim-seek'
" Plug 'justinmk/vim-sneak'

Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
" Plug 'godlygeek/tabular'

Plug 'dhruvasagar/vim-table-mode'

" Plug 'plasticboy/vim-markdown' " Depends on tabular?

" I'm using [Grip](https://github.com/joeyespo/grip) to preview Markdown files at the
" moment which actually lets GitHub do the rendering.  The best Vim plugin might be
" suan/vim-instant-markdown.  JamshedVesuna/vim-markdown-preview is somewhat buggy.
" greyblake/vim-preview doesn't seem to do GitHub Flavored Markdown (it uses the redcarpet
" Gem).  There's also the github-markdown-preview Gem and several Chromium extensions that
" render Markdown (http://stackoverflow.com/q/9212340).  TODO: add a mapping for Grip?

Plug 'itchyny/lightline.vim'
" Plug 'bling/vim-airline'

" Both slow Vim down on my lapotp.
" Plug 'nathanaelkane/vim-indent-guides'
" Plug 'Yggdroot/indentLine'

Plug 'tpope/vim-eunuch'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter', { 'on': 'GitGutterToggle' }

" Automatically close parens, brackets, braces, quotes, etc.  See
" http://vim.wikia.com/wiki/Automatically_append_closing_characters
Plug 'Raimondi/delimitMate'
" Plug 'ervandew/matchem'
" Plug 'cohama/lexima.vim'
" Plug 'rstacruz/vim-closer'
" Plug 'jiangmiao/auto-pairs' " Breaks repeat and undo/redo.
" Plug 'Townk/vim-autoclose'  " Inactive.  Try anyway?
" Plug 'kana/vim-smartinput'  " Breaks repeat and undo/redo?
Plug 'tpope/vim-endwise'

Plug 'tpope/vim-unimpaired'

" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-easytags'
" Plug 'szw/vim-tags'
" Plug 'majutsushi/tagbar'

Plug 'vim-scripts/a.vim'
" Plug 'derekwyatt/vim-fswitch'

" Plug 'simnalamburt/vim-mundo'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

Plug 'meribold/vim-man'
" Plug 'lambdalisue/vim-manpager'

" FIXME: pastery.vim increases Vim's startup time by half a second when not using
" on-demand loading.
if has('unix')
   Plug 'skorokithakis/pastery.vim', { 'on': ['PasteCode', 'PasteFile'] }
endif

if has('unix')
   Plug 'beloglazov/vim-online-thesaurus'
   Plug 'szw/vim-dict'
endif
" Plug 'szw/vim-g'

Plug 'tpope/vim-obsession'
" Plug 'xolox/vim-session'

" Automatically adjusts 'shiftwidth' and 'expandtab' heuristically.
Plug 'tpope/vim-sleuth'

" Snippet engine using Python.  Doesn't define any snippets by itself; they are in
" honza/vim-snippets (but I'm only using my own snippets at the moment).  TODO: check that
" we have Python.
if has('unix')
   Plug 'SirVer/ultisnips'
endif

" Plug 'Shougo/neocomplete'
" Plug 'Shougo/neosnippet.vim'
" Plug 'Shougo/neosnippet-snippets'

" I have vim-youcompleteme-git from the AUR installed.  Upstream is on GitHub at
" Valloric/YouCompleteMe.  I'm not sure I like it, though, and it slows Vim down
" noticeably on my laptop.  It's disabled for now.  See [How to turn-off a plugin in Vim
" temporarily?](http://stackoverflow.com/q/601412) and [How do you disable a specific
" plugin in Vim?](http://stackoverflow.com/q/2888970).
if has('unix')
   let g:loaded_youcompleteme = 1
   " Plug 'rdnetto/YCM-Generator'
endif
" Plug 'scrooloose/syntastic'

Plug 'justinmk/vim-dirvish'
" Plug 'tpope/vim-vinegar'

Plug 'thinca/vim-visualstar'

" Plug 'kien/ctrlp.vim'
" Plug 'wincent/command-t'
" Plug 'szw/vim-ctrlspace'
Plug 'Shougo/unite.vim'
" I'm using the fzf package build from the AUR, so I removed the install command from the
" next line (which is copied from https://github.com/junegunn/fzf#install-as-vim-plugin).
" TODO: don't I really just need to curl the .vim file?
if has('unix')
   Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
   Plug 'junegunn/fzf.vim'
endif

Plug 'vim-utils/vim-husk'
" Plug 'tpope/vim-rsi'

Plug 'tpope/vim-speeddating'

" Plug 'terryma/vim-multiple-cursors'

Plug 'junegunn/goyo.vim', { 'on':  'Goyo' }
Plug 'reedes/vim-pencil'
" Plug 'junegunn/limelight.vim', { 'on':  'Limelight' }
" autocmd! User GoyoEnter Limelight
" autocmd! User GoyoLeave Limelight!

" Color schemes.
Plug 'meribold/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'jonathanfilip/vim-lucius'
Plug 'itchyny/landscape.vim'
Plug 'vim-scripts/wombat256.vim'
Plug 'vim-scripts/xoria256.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'vim-scripts/Neverness-colour-scheme'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'NLKNguyen/papercolor-theme'
Plug 'sjl/badwolf'
Plug 'junegunn/seoul256.vim'
" Plug 'zenorocha/dracula-theme', {'rtp': 'vim/'}
" Plug 'chriskempson/base16-vim'

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin settings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable netrw by [pretending it's already loaded][1].  This seemed like a good idea to
" improve startup time since [dirvish.vim][2] [doesn't depend on netrw][3], but netrw
" defines the gx mapping so I'll at least have to add a replacement for that mapping
" first.
" [1]: http://stackoverflow.com/a/21687112
" [2]: http://github.com/justinmk/vim-dirvish
" [3]: http://www.reddit.com/comments/4l00pj//d3j7a8j
" let loaded_netrwPlugin = 1

let g:neomake_echo_current_error = 0
let g:neomake_place_signs = 0

" Adjust commentstring for C++ so commentary.vim uses C++-style comments.  TODO: see
" `:h ftplugin-overrule`.
autocmd vimrc_common FileType cpp setlocal commentstring=//%s
autocmd vimrc_common FileType markdown setlocal commentstring=<!--%s-->

" Let Sneak handle f, F, t and T.
" nmap f <Plug>Sneak_f
" nmap F <Plug>Sneak_F
" xmap f <Plug>Sneak_f
" xmap F <Plug>Sneak_F
" omap f <Plug>Sneak_f
" omap F <Plug>Sneak_F
" nmap t <Plug>Sneak_t
" nmap T <Plug>Sneak_T
" xmap t <Plug>Sneak_t
" xmap T <Plug>Sneak_T
" omap t <Plug>Sneak_t
" omap T <Plug>Sneak_T

" vmap <Enter> <Plug>(EasyAlign)

" let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_no_default_key_mappings = 1

" let g:instant_markdown_slow = 1
" let g:instant_markdown_autostart = 0

let g:lightline = {
   \ 'colorscheme': 'default',
\ }
" :h line-continuation, :h dict

" Based on the snippet from :h lightline-problem-13.  Also see [Changing colorscheme on
" the fly](https://github.com/itchyny/lightline.vim/issues/9)
autocmd vimrc_common ColorScheme * call s:lightline_update()
function! s:lightline_update() " Local to this file.
   " TODO: only list color schemes where the name of the lightline color scheme differs
   " from the one of the matching Vim color scheme.  Use a directory listing of
   " lightline.vim/autoload/lightline/colorscheme/ for everything else.
   let colos = {
      \ 'molokai': 'molokai',
      \ 'wombat256mod': 'wombat',
      \ 'solarized': 'solarized_dark',
      \ 'landscape': 'landscape',
      \ 'jellybeans': 'jellybeans',
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

" let g:indent_guides_start_level = 2
" let g:indent_guides_guide_size = 1

let g:gitgutter_enabled = 0  " Turn vim-gitgutter off by default.
let g:gitgutter_realtime = 0 " Don't trigger sign updates when not typing.
let g:gitgutter_eager = 0    " Update signs less often; mostly just when writing a buffer.

let delimitMate_expand_space = 1
let delimitMate_expand_cr = 1
let delimitMate_balance_matchpairs = 1

" Always render man pages at this width, regardless of the size of the window.
" https://github.com/vim-utils/vim-man/issues/14
let g:man_width = 93

" Use local DICT daemon for speed.  These are all databases I have installed.  They are
" listed explicitly to change the order ['*'] would use.
let g:dict_hosts = [
   \ ['localhost', ['gcide', 'eng-deu', 'deu-eng', 'foldoc', 'wn']],
\ ]

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

let g:goyo_height = '100%'
function! GoyoToggle()
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
nnoremap <silent> Q :call GoyoToggle()<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" Basic settings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Stuff taken from sensible.vim {{{2

" Most (all?) of this is probably redundant for Neovim.  TODO: move it into vim/vimrc?
" There probably also are more settings scattered around this file that belong in this
" section.

" Running `syntax enable` should be redundant for both Neovim and Vim.  It's the [default
" in Neovim][1] and redundant for Vim as well because [vim-plug does it][2].
" [1]: https://github.com/neovim/neovim/issues/2676
" [2]: https://github.com/junegunn/vim-plug/wiki/faq

" TODO: plugins are loaded after personal vimrc files; should this command therefore be at
" the very end of this file or in a different file inside an after/ subdirectory?
runtime! macros/matchit.vim " Load matchit.vim.

" Don't scan included files for keyword completion.
set complete-=i " Keep?  See https://github.com/tpope/vim-sensible/issues/51.

" See https://github.com/tpope/vim-sensible/issues/13.
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

" See https://github.com/tpope/vim-sensible/issues/78.
" Removed by https://github.com/tpope/vim-sensible/commit/9e91be7e0fb42949831fe3161ef5833.
set lazyredraw

" Makes Y consistent with C and D.  See :h Y and :h &.
" Removed by https://github.com/tpope/vim-sensible/commit/e48a40534c132e6dd88176b666a8b1f.
nnoremap Y y$
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" }}}2
map <Space> <Nop>
let mapleader = ' '
let maplocalleader = '\'

" Use Unix-style line endings for new buffers and files on Windows too.
if has('win32')
   set fileformat=unix
   set fileformats=unix,dos
endif

" Ubuntu 13.10 disables this by sourcing /usr/share/vim/vim74/debian.vim.
set modeline

set showcmd      " Why does this default to off for Unix ONLY?
set history=1000 " Vim default: 50.  TODO: move this to vimrc (Neovim's default is 10000).
set incsearch    " Search while typing the search command and...
set hlsearch     " hightlight matches.

" Don't automatically yank all visual selections into the "* register.
set clipboard-=autoselect

"set autochdir

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display relative line numbers, but the absolute line number in front of the cursor line.
" Useful when preceding vertical motion commands that support it with a count, e.g. d4j.
set number
set relativenumber " Slows Vim down a lot.  Worth disabling in long files with complex
                   " syntax highlighting sometimes (unimpaired.vim maps this to [or, ]or
                   " and cor).  'cursorline' is similar.
set numberwidth=3  " Minimal number of colums to use for the line number.

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
set ruler         " Show the ruler.
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

set linebreak             " Wrap lines at characters in 'breakat', not at the last
if exists('&breakindent') " character that fits on the screen.
   set breakindent        " Continue lines at their indentation level when wrapping.
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists('&belloff')
   set belloff=all
endif

set maxmem=2000000    " Lots of memory for each buffer.
set maxmemtot=2000000 " Lots of memory for all buffers together.

set undofile " Make undo history persistent.

" TODO: what was the idea with this?
" set viminfo^=%

set shortmess+=I " Don't give the intro message when starting Vim.

" Make a persistent backup whenever writing a file, potentially overwriting an existing
" backup (even if that file isn't the one being backed up; i.e., when different files
" having the same name are edited).
set backup
set writebackup

" Not-so-basic settings {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Draw a continuous line to separate vertical splits.
if has('multi_byte') | :set fillchars=vert:│ | endif

" [Open help in the current window](http://stackoverflow.com/a/26431632)
" :h 'buftype'
command! -nargs=1 -complete=help H :enew | :set buftype=help | :h <args>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Molokai sets 'background' to light for some reason.  The issue has been reported here:
" https://github.com/tomasr/molokai/issues/22.
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
   let g:jellybeans_use_term_background_color = 1
   silent! colorscheme jellybeans
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
" Based on snippets from http://vim.wikia.com/wiki/Highlight_unwanted_spaces.
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

" Highlight first column after 'textwidth', except in help files.  TODO: autocmd isn't run
" when the filetype is empty.
set cc=+1
autocmd vimrc_common FileType * if &ft !=# 'help' | setl cc=+1 | else | setl cc= | endif

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

" Use Shift+Tab to toggle folds recursively.
nnoremap <S-Tab> zA

" Switch windows more easily.
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" Traverse the change list more quickly.  <C-P> and <C-N> are just duplicates of k and j
" by default.  I added zv to also open just enough folds after moving the cursor to make
" the current line visible.  Directly using the g; and g, mappings already seems to do
" that but the new mappings (without zv) don't for some reason.
nnoremap <C-P> g;zv
nnoremap <C-N> g,zv

" Split windows more easily: `_` splits horizontally and `|` splits vertically.  Taken
" from justinmk's comment at http://www.reddit.com/comments/4jyw8o//d3ayzox.
nnoremap <silent> <expr> \| !v:count ? '<C-W>v<C-W><Right>' : '\|'
nnoremap <silent> <expr> _  !v:count ? '<C-W>s<C-W><Down>'  : '_'

" Always go forward with n and backward with N.  Remove the cognitive dissonance after
" forgetting whether the last search was done with '/' or '?'.  See
" http://stackoverflow.com/q/18523150 and http://vi.stackexchange.com/q/2365.  :noremap
" adds the mapping for normal, visual, select and operator-pending mode.
noremap <expr> n 'Nn'[v:searchforward]
noremap <expr> N 'nN'[v:searchforward]

" Operator mappings for vim-autoformat using vim-operator-user.  They don't work when
" using nnoremap and xnoremap.
nmap <Leader>q <Plug>(operator-autoformat)
xmap <Leader>q <Plug>(operator-autoformat)
call operator#user#define_ex_command('autoformat', 'Autoformat')

" Alternative mappings using vim-clang-format.  TODO: remove?
autocmd vimrc_common FileType c,cpp,objc
   \ nmap <buffer> <LocalLeader>q <Plug>(operator-clang-format) |
   \ xmap <buffer> <LocalLeader>q <Plug>(operator-clang-format)

nnoremap <silent> <Leader>g :GitGutterToggle<CR>

" Fix the syntax highlighting.  See `:h :syn-sync-first` and
" http://vim.wikia.com/wiki/Fix_syntax_highlighting.
nnoremap <silent> <Leader>s :sy sync fromstart<CR>

" Mappings for visual-split.vim.  The default mappings from visual-split.vim also work in
" normal mode (they operate on a text object).  TODO: these mappings should have normal
" mode equivalents as well (just nmapping doesn't work).  See
" https://github.com/wellle/visual-split.vim/blob/master/plugin/visual-split.vim
xnoremap <silent> <C-W>j :VSSplitBelow<CR>
xnoremap <silent> <C-W>k :VSSplitAbove<CR>

nnoremap <silent> <Leader>c :Gcommit<CR>
nnoremap <silent> <Leader>C :Gcommit --amend<CR>

" Mappings for commands from junegunn's fzf.vim plugin.  Most commands support CTRL-T,
" CTRL-X, and CTRL-V key mappings to open in a new tab, a new split, or a new vertical
" split respectively.
nnoremap <silent> U :Windows<CR>
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>F :Files ~<CR>
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
" See https://www.reddit.com/r/vim/comments/47ivpz, http://stackoverflow.com/a/16360104,
" :h :map-local and :h :map-silent.
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
function! OnEnter()
   let filetypes = [ 'man', 'thesaurus' ]
   if empty(&buftype) || &buftype ==# 'help' || index(filetypes, &filetype) != -1
      return ':noh | echo'
   else
      return ''
   end
endfunction
nnoremap <silent> <expr> <CR> OnEnter()
" This works around E481 caused by :noh not accepting a range (just try :noh in visual
" mode).  TODO: it feels pretty inelegant, though.
xnoremap <silent> <expr> <CR> '<Esc>' . OnEnter() . 'gv'

" }}}1
" vim: tw=90 sts=-1 sw=3 et fdm=marker
