#!/usr/bin/env zsh

# `functions.zsh` provides helper functions and utilities.

function take {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

function tt {
  builtin cd $(mktemp -d)
}

# Changes to a directory and lists its contents.
function cdls {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# e: edit with default editor or open cwd with editor
function e {
  if [[ ! -z $1 ]]; then
    $VISUAL $1
  else
    # file=$(__fsel); [[ ! -z $file ]] && $VISUAL $file
    # # __fsel is the actual selector function used by fzf-file-widget
    $VISUAL .
  fi
}

# Remove history entries with fzf
# Note: doesn't work with atuin
function smite() {
  # https://esham.io/2025/05/shell-history
  setopt LOCAL_OPTIONS ERR_RETURN PIPE_FAIL

  local opts=( -I )
  if [[ $1 == '-a' ]]; then
    opts=()
  elif [[ -n $1 ]]; then
    print >&2 'usage: smite [-a]'
    return 1
  fi

  fc -l -n $opts 1 | \
    fzf --no-sort --tac --multi | \
    while IFS='' read -r command_to_delete; do
      printf 'Removing history entry "%s"\n' $command_to_delete
      local HISTORY_IGNORE="${(b)command_to_delete}"
      fc -W
      fc -p $HISTFILE $HISTSIZE $SAVEHIST
    done
}

# Decrypt all PDFs in the current directory
# Example: decrypt_pdfs "password"
function decrypt_pdfs {
  local password="$1"
  for file in *.pdf; do
    # Skip if it's not a regular file
    [ -f "$file" ] || continue

    # Check if it's encrypted
    if qpdf --check "$file" 2>&1 | grep -q "is encrypted"; then
      echo "Decrypting: $file"
      local tmp_file="tmp_decrypted.pdf"
      if qpdf --decrypt --password="$password" "$file" "$tmp_file"; then
        mv "$tmp_file" "$file"
        echo "Decrypted: $file"
      else
        echo "Failed to decrypt: $file"
        rm -f "$tmp_file"
      fi
    else
      echo "Already decrypted: $file"
    fi
  done
}

# Traceroute with Trippy
function t {
  # Update geoip.mmdb if it's older than 30 days
  if [ ! -f $HOME/.cache/geoip.mmdb ] || [ $(find $HOME/.cache/geoip.mmdb -mtime +30 2>/dev/null | wc -l) -gt 0 ]; then
    wget -O $HOME/.cache/geoip.mmdb https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
  fi

  sudo trip $1 -r google -z --geoip-mmdb-file $HOME/.cache/geoip.mmdb --tui-geoip-mode short --tui-address-mode both --tui-as-mode name
}

# Show TLS certificate details for a given domain
# @note     use testssl.sh for complete analysis
# @example  `https google.com 443`
function https {
  local port=${2:-443}
  echo | openssl s_client -showcerts -servername $1 -connect $1:$port 2>/dev/null | openssl x509 -inform pem -noout -text | less
}

# Measure TTFB (Time To First Byte)
# https://gist.github.com/sandeepraju/1f5fbdbdd89551ba7925abe2645f92b5
# @example  `ttfb google.com`
function ttfb {
  curl -Is \
    -H 'Cache-Control: no-cache' \
    -w "Connect: %{time_connect}s TTFB: %{time_starttransfer}s Total time: %{time_total}s\n" \
    "$@"
}

# List all processes listening on a port
function listening {
  if [ $# -eq 0 ]; then
    sudo lsof -iTCP -sTCP:LISTEN -n -P
  elif [ $# -eq 1 ]; then
    sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
  else
    echo "Usage: listening [pattern]"
  fi
}

# ping until success or cancelled
function pingu {
  local ping_cancelled
  ping_cancelled=false    # Keep track of whether the loop was cancelled, or succeeded
  until ping -c1 "$1" >/dev/null 2>&1; do :; done &    # The "&" backgrounds it
  trap "kill $!; ping_cancelled=true" SIGINT
  wait $!          # Wait for the loop to exit, one way or another
  trap - SIGINT    # Remove the trap, now we're done with it
  echo "Done pinging, cancelled=$ping_cancelled"
}

# Lookup an IP address
function lip {
  http -b https://api.birkhoff.me/v3/ip/$1
}

# Lookup IP address of an A record of a domain
function dns {
  lip $(kdig @8.8.4.4 +short $1 | tail -n1)
}

# Example:
# $ nix-pkgdir paho-mqtt-c
# /nix/store/92h4cbrnnxcmqvdzzkdyajfm3b6yvf13-paho.mqtt.c-1.3.12
function nix-pkgdir {
  nix eval -f '<nixpkgs>' --raw $1
}

# Run a nix package from nixpkgs
# @example  `nr paho-mqtt-c`
function nr {
  nix run "nixpkgs#$1"
}

# Run a nix package from nixpkgs unstable
# @example  `nru paho-mqtt-c`
function nru {
  nix run "github:NixOS/nixpkgs/nixpkgs-unstable#$1"
}

# Get a shell for a nix package from nixpkgs
# @example  `ns paho-mqtt-c`
function ns {
  nix shell nixpkgs#$1
}

# Get a shell for a nix package from nixpkgs unstable
# @example  `nsu paho-mqtt-c`
function nsu {
  nix shell "github:NixOS/nixpkgs/nixpkgs-unstable#$1"
}

# Apply scanner effect to a PDF
# https://gist.github.com/andyrbell/25c8632e15d17c83a54602f6acde2724
# https://github.com/NixOS/nixpkgs/issues/138638#issuecomment-1068569761
function dirtypdf {
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
function favicon {
  convert $1 -background white \
    \( -clone 0 -resize 16x16 -extent 16x16 \) \
    \( -clone 0 -resize 32x32 -extent 32x32 \) \
    \( -clone 0 -resize 48x48 -extent 48x48 \) \
    \( -clone 0 -resize 64x64 -extent 64x64 \) \
    -delete 0 -alpha off -colors 256 favicon.ico
}

# Search in files, then pipe files with 10 line buffer into fzf preview using bat.
# https://github.com/issmirnov/dotfiles/blob/df92f79a760740a7d389605f2f0f5085ca95a713/zsh/config/fzf.zsh#L149-L161
# Notes:
#  - if you want to replace ag for rg feel free (https://blog.burntsushi.net/ripgrep/)
#  - Same goes for bat, although ccat and others are definitely worse
#  - the $ext extraction uses a ZSH specific text globber
function s {
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

function pyclean {
  # Cleans py[cod] and __pychache__ dirs in the current tree:
  find . | grep -E "(__pycache__|\.py[cod]$)" | xargs rm -rf
}

function pipenv-shell {
  # pipenv shell breaks sometimes. This does not.
  source "$(pipenv --venv)/bin/activate"
}

# ftpane - switch pane (@george-b)
function ftpane {
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
