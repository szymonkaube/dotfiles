export PATH="$HOME/.local/bin:$PATH"

# not use PEAR as php package manager (we use composer)
export PHP_CONFIGURE_OPTIONS="--with-openssl --with-curl --without-pear"
