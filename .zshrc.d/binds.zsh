tmux_sessionizer_widget() {
  zle push-line
  BUFFER="tmux-sessionizer"
  zle accept-line
}
zle -N tmux_sessionizer_widget
bindkey '^f' tmux_sessionizer_widget
