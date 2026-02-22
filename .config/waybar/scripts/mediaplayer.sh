#!/bin/bash

# use temp file to store the name of current player
PLAYER_FILE="/tmp/waybar_current_player"

truncate_string() {
  local str="$1"
  local len=25
  if [ ${#str} -gt $len ]; then
      echo "${str:0:$((len-3))}..."
  else
      echo "$str"
  fi
}

playerctl metadata --format '{{playerName}}|{{artist}}|{{title}}|{{status}}' --follow | while IFS='|' read -r player artist title status; do
  current_player=$(echo "$player" | xargs)
  artist=$(echo "$artist" | xargs)
  title=$(echo "$title" | xargs)
  status=$(echo "$status" | xargs)

  echo "$current_player" > "$PLAYER_FILE"

  clean_artist=$(truncate_string "$artist")
  clean_title=$(truncate_string "$title")

  # if browser -> show title only
  if [[ "$current_player" =~ (firefox|chromium|chrome|brave|opera|msedge|vivaldi) ]]; then
      display_text="$clean_title"
  # else show artist - title
  else
      if [[ -n "$clean_artist" ]]; then
          display_text="$clean_artist - $clean_title"
      else
          display_text="$clean_title"
      fi
  fi

  printf '{"text": "%s", "alt": "%s", "class": "%s"}\n' \
      "$display_text" "$status" "$status"
done
