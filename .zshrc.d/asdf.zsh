# asdf configuration
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# asdf completions
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
