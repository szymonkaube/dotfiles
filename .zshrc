HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt notify

# emacs editing configuration
bindkey -e

# Load modular configuration files from ~/.zshrc.d
if [ -d ~/.zshrc.d ]; then
  for config_file in ~/.zshrc.d/*.zsh; do
    [ -f "$config_file" ] && source "$config_file"
  done
fi
