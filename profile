export VISUAL=nvim
export EDITOR=nvim
export BROWSER=firefox-developer

# Export an environment variable for executing the pgpewrap program bundled with Mutt.
# See http://stackoverflow.com/a/677212.
if command -v pgpewrap >/dev/null 2>&1; then
   # It's in $PATH.  E.g. the case with Arch's package.
   export PGPEWRAP=pgpewrap
elif command -v /usr/lib/mutt/pgpewrap >/dev/null 2>&1; then
   # This is the location used by Ubuntu's package.
   export PGPEWRAP=/usr/lib/mutt/pgpewrap
fi

# Makes wiki-search-html from the arch-wiki-light package work.
export wiki_browser=$BROWSER

# Make RubyGems available (http://guides.rubygems.org/faqs/#user-install).
if which ruby >/dev/null && which gem >/dev/null; then
   PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# Make `jpm` available.
# https://developer.mozilla.org/en-US/Add-ons/SDK/Tools/jpm#Installing_jpm_locally
PATH="$HOME/node_modules/.bin/:$PATH"

# Set PATH to include ~/bin if it exists.  See http://askubuntu.com/a/402410.
if [ -d "$HOME/bin" ]; then
   PATH="$HOME/bin:$PATH"
fi

# vim: tw=90 sts=-1 sw=3 et ft=sh
