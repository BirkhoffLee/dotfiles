#!/usr/bin/env zsh

# `.functions` provides helper functions for shell.

function t {
  if [ ! -f $HOME/.cache/geoip.mmdb ]; then
    wget -O $HOME/.cache/geoip.mmdb https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
  fi

  sudo trip $1 -r google -z --geoip-mmdb-file $HOME/.cache/geoip.mmdb --tui-geoip-mode short --tui-address-mode both --tui-as-mode name
}

# Example:
# $ nix-pkgdir paho-mqtt-c
# /nix/store/92h4cbrnnxcmqvdzzkdyajfm3b6yvf13-paho.mqtt.c-1.3.12
function nix-pkgdir {
  nix eval -f '<nixpkgs>' --raw $1
}

function nix-cleanup {
  sudo nix-collect-garbage -d
  nix-store --optimise
}

function nix-update-dotfiles {
  nix flake update --flake "$HOME/.config/nix"
  darwin-rebuild switch --flake "$HOME/.config/nix#AlessandroMBP"
}

function nix-info {
  nix-shell -p nix-info --run "nix-info -m"
}

# https google.com 443
# use testssl.sh for complete analysis
function https {
  echo | openssl s_client -showcerts -servername $1 -connect $1:$2 2>/dev/null | openssl x509 -inform pem -noout -text | less
}

# https://gist.github.com/sandeepraju/1f5fbdbdd89551ba7925abe2645f92b5
function ttfb {
  curl -Is \
    -H 'Cache-Control: no-cache' \
    -w "Connect: %{time_connect}s TTFB: %{time_starttransfer}s Total time: %{time_total}s\n" \
    "$@"
}

# https://github.com/sorin-ionescu/prezto/blob/master/modules/utility/init.zsh

function take {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

function taketemp {
  builtin cd $(mktemp -d)
}

# Changes to a directory and lists its contents.
function cdls {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

listening() {
  if [ $# -eq 0 ]; then
    sudo lsof -iTCP -sTCP:LISTEN -n -P
  elif [ $# -eq 1 ]; then
    sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
  else
    echo "Usage: listening [pattern]"
  fi
}

# Apply scanner effect to a PDF
# https://gist.github.com/andyrbell/25c8632e15d17c83a54602f6acde2724
# https://github.com/NixOS/nixpkgs/issues/138638#issuecomment-1068569761
dirtypdf () {
  if [ $# -ne 2 ]; then
    echo "Usage: dirtypdf <input_pdf> <output_pdf>"
    return 1
  fi

  input_file="$1"
  output_file="$2"

  if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' does not exist"
    return 1
  fi

  nix-shell --packages 'imagemagickBig' --run "magick -density 90 \"$input_file\" -rotate 0.5 -attenuate 0.2 +noise Multiplicative -colorspace Gray \"$output_file\""
  
  # open the output file in finder
  open -R "$output_file"
}

# `favicon 1.png` will generate 4 sizes of favicon.ico
favicon () {
  convert $1 -background white \
    \( -clone 0 -resize 16x16 -extent 16x16 \) \
    \( -clone 0 -resize 32x32 -extent 32x32 \) \
    \( -clone 0 -resize 48x48 -extent 48x48 \) \
    \( -clone 0 -resize 64x64 -extent 64x64 \) \
    -delete 0 -alpha off -colors 256 favicon.ico
}

# e: edit with default editor or open cwd with editor
e () {
  if [[ ! -z $1 ]]; then
    $VISUAL $1
  else
    # file=$(__fsel); [[ ! -z $file ]] && $VISUAL $file
    # # __fsel is the actual selector function used by fzf-file-widget
    $VISUAL .
  fi
}

# Search in files, then pipe files with 10 line buffer into fzf preview using bat.
# https://github.com/issmirnov/dotfiles/blob/df92f79a760740a7d389605f2f0f5085ca95a713/zsh/config/fzf.zsh#L149-L161
# Notes:
#  - if you want to replace ag for rg feel free (https://blog.burntsushi.net/ripgrep/)
#  - Same goes for bat, although ccat and others are definitely worse
#  - the $ext extraction uses a ZSH specific text globber
s () {
  local margin=5 # number of lines above and below search result.
  local preview_cmd='search={};file=$(echo $search | cut -d':' -f 1 );'
  preview_cmd+="margin=$margin;" # Inject value into scope.
  preview_cmd+='line=$(echo $search | cut -d':' -f 2 );'
  preview_cmd+='tail -n +$(( $(( $line - $margin )) > 0 ? $(($line-$margin)) : 0)) $file | head -n $(($margin*2+1)) |'
  preview_cmd+='bat --paging=never --color=always --style=full --file-name $file --highlight-line $(($margin+1))'
  local full=$(ag --silent "$*" \
    | fzf --no-height --no-reverse --select-1 --exit-0 --preview-window up:$(($margin*2+1)) --preview $preview_cmd)
  local file="$(echo $full | awk -F: '{print $1}')"
  local line="$(echo $full | awk -F: '{print $2}')"
  [ -n "$file" ] && \
    (code -g "$file":$line || $VISUAL "$file" +$line)
}

pingu () {
  ping_cancelled=false    # Keep track of whether the loop was cancelled, or succeeded
  until ping -c1 "$1" >/dev/null 2>&1; do :; done &    # The "&" backgrounds it
  trap "kill $!; ping_cancelled=true" SIGINT
  wait $!          # Wait for the loop to exit, one way or another
  trap - SIGINT    # Remove the trap, now we're done with it
  echo "Done pinging, cancelled=$ping_cancelled"
}

# lookup ip
lip () {
  http -b https://api.birkhoff.me/v3/ip/$1
}

dns () {
  lip $(kdig @8.8.4.4 +short $1 | tail -n1)
}

testdown() {
  http https://mensura.cdn-apple.com/api/v1/gm/config | jq -r .urls.large_https_download_url | xargs wget -O /dev/null
}

pyclean () {
  # Cleans py[cod] and __pychache__ dirs in the current tree:
  find . | grep -E "(__pycache__|\.py[cod]$)" | xargs rm -rf
}

pipenv-shell () {
  # pipenv shell breaks sometimes. This does not.
  source "$(pipenv --venv)/bin/activate"
}

# ftpane - switch pane (@george-b)
ftpane() {
  local panes current_window current_pane target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_pane=$(tmux display-message -p '#I:#P')
  current_window=$(tmux display-message -p '#I')

  target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

  target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
  target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

  if [[ $current_window -eq $target_window ]]; then
    tmux select-pane -t ${target_window}.${target_pane}
  else
    tmux select-pane -t ${target_window}.${target_pane} &&
    tmux select-window -t $target_window
  fi
}
