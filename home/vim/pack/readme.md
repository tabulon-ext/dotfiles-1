# Some notes

*   I use [dirvish.vim][] and [open-browser.vim][] to replace Netrw.  Unlike Tim Pope's
    [vinegar.vim][], [dirvish.vim][] doesn't depend on Netrw.
*   [repeat.vim][] is an auxiliary plugin that is used by at least surround.vim,
    [commentary.vim][], and unimpaired.vim.
*   The textobj-gitgutter, vim-textobj-comment, and vim-textobj-entire plugins require
    vim-textobj-user.  The first also requires vim-gitgutter.
*   See <https://redd.it/26mszm> for some discussion concerning alternatives to
    [commentary.vim][].
*   Tim Pope's [scriptease.vim][] plugin adds the `g!` operator (evaluate VimL and
    substitute the result).
*   There are two alternatives to [EasyAlign][] I know of: [Tabular][] and [Lion.vim][].
    Tabular is the oldest.  I think it doesn't provide an operator.  Lion.vim is much
    simpler than EasyAlign (its help file has less than 100 lines compared to EasyAlign's
    almost 1000), but EasyAlign tends to automagically do the *right thing* in many common
    cases (like ignoring comments).  Also see [this reddit post](https://redd.it/2lsr8d)
    about EasyAlign.
*   [vim-sleuth][] automatically adjusts 'shiftwidth' and 'expandtab' heuristically.

# TODO

*   Perhaps color schemes should reside under `opt`.  See `:h repeat.txt`.  Search for
    "Where to put what".
*   Replace [unite-spell-suggest][] with [fzf][] somehow.

[dirvish.vim]: https://github.com/justinmk/vim-dirvish
[open-browser.vim]: https://github.com/tyru/open-browser.vim
[vinegar.vim]: https://github.com/tpope/vim-vinegar
[repeat.vim]: https://github.com/tpope/vim-repeat
[commentary.vim]: https://github.com/tpope/vim-commentary
[scriptease.vim]: https://github.com/tpope/vim-scriptease
[EasyAlign]: https://github.com/junegunn/vim-easy-align
[Tabular]: https://github.com/godlygeek/tabular
[Lion.vim]: https://github.com/tommcdo/vim-lion
[vim-instant-markdown]: https://github.com/suan/vim-instant-markdown
[vim-markdown-preview]: https://github.com/JamshedVesuna/vim-markdown-preview
[vim-preview]: https://github.com/greyblake/vim-preview
[github-markdown-preview]: https://github.com/dmarcotte/github-markdown-preview
[vim-sleuth]: https://github.com/tpope/vim-sleuth
[unite-spell-suggest]: https://github.com/kopischke/unite-spell-suggest
[fzf]: https://github.com/junegunn/fzf
