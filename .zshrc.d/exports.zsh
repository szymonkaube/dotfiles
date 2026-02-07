export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# not use PEAR as php package manager (we use composer)
export PHP_CONFIGURE_OPTIONS="--with-openssl --with-curl --without-pear"

# default editor
export EDITOR=nvim
export VISUAL=$EDITOR
