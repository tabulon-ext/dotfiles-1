![](/../media/screenshot.png?raw=true "Screenshot showing Vim, Conky, and vis")

**Dotfiles** for [Vim][vim/] (and [Neovim][]), [i3-gaps][i3/], [Mutt][mutt/] (and
[NeoMutt][]), Bash, [and][conky/] [more][dunst/] [programs][screen/][...][xresources] some
[scripts][bin/], Bash [functions and aliases][bashrc], [keybindings][xbindkeysrc], ...

[Click here for more screenshots](https://imgur.com/a/1bnaT).

## Project Structure

The repository is split into three main directories: [`home/`](home/), [`root/`](root/),
and [`misc/`](misc/).
*   `home` contains files that should be linked to from `$HOME` and mirrors that directory
    structure.
*   `root` contains files that should be linked to from *outside* `$HOME`.  Paths reflect
    where symlinks should be created relative to the filesystem root directory.
*   `misc` contains configuration files that don't require linking.

For example, [`home/vim/vimrc`](home/vim/vimrc) would be the target of a link at
`~/.vim/vimrc` and
[`root/usr/local/share/cows/dynamic-duo.cow`](root/usr/local/share/cows/dynamic-duo.cow)
should be linked to from `/usr/local/share/cows/dynamic-duo.cow`.

## Installation

You probably shouldn't blindly use these (or anyone's) dotfiles: my setup is personal,
opinionated, and sometimes my own information is hard-coded.  Some configuration is not
portable and specific to [Arch][] or my ThinkPad.

That being said, the installation is based on [GNU Make][make] (you probably already have
it installed) and you can try out the configuration for specific programs:

*   Clone this repository to `~/dotfiles`.
*   Cherry-pick the configuration for programs you're interested in by giving Make their
    names.  The makefile doesn't replace most conflicting files, they should be removed or
    moved manually first.

    ```bash
    mv ~/.vim ~/.vim.backup
    make vim
    ```

    >   **Don't** install all configuration, some of it is not portable,  **always**
    >   specify targets when running `make`.

    The currently implemented targets are: `vim`, `nvim`, `git`, `screen`, `mutt`, and
    `conky`.

Make may consider targets to be up to date because of existing files that conflict with
the links it should create.  The `-B` flag (e.g. `make -B vim`) forces remaking of all
considered targets.  This only results in the removal of conflicting **symlinks**, but not
regular files.

Use the `-n` flag (e.g. `make -n vim`) to preview the commands Make would execute.

[vim/]: home/vim/
[neovim]: https://neovim.io
[i3/]: home/config/i3/
[mutt/]: home/mutt/
[neomutt]: https://neomutt.org
[conky/]: home/config/conky/
[dunst/]: home/config/dunst/
[screen/]: home/screenrc
[xresources]: home/Xresources
[bin/]: home/bin/
[bashrc]: home/bashrc
[xbindkeysrc]: home/xbindkeysrc
[make]: https://www.gnu.org/software/make/
[arch]: https://archlinux.org
<!--
[vim]: http://vim.org
[i3-gaps]: https://github.com/Airblader/i3
[mutt]: http://mutt.org
[bash]: https://www.gnu.org/software/bash/
[screen]: https://gnu.org/software/screen/
[irssi/]: home/irssi/
-->

<!-- vim: set tw=90 sts=-1 sw=4 et spell: -->
