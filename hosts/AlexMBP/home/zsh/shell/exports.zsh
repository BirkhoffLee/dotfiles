#!/usr/bin/env zsh

# `exports.zsh` is used to setup general environment variables.

# Language
export LANG=en_US.UTF-8
export LC_ALL="en_US.UTF-8"

# LS_COLORS
# https://github.com/sharkdp/vivid?tab=readme-ov-file#usage
export LS_COLORS="$(vivid generate snazzy)"

# Editor
export EDITOR="$(which vim)"
cursor_path=$(which cursor 2>/dev/null)
code_path=$(which code 2>/dev/null)

if [ -f "$cursor_path" ]; then
  export VISUAL=$cursor_path
elif [ -f "$code_path" ]; then
  export VISUAL=$code_path
else
  export VISUAL=$EDITOR
fi

unset cursor_path
unset code_path

# macOS only
if [[ "$OSTYPE" = darwin* ]]; then
  # 1Password SSH Key Agent
  export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi

# grep colors
export GREP_COLOR='37;45'           # BSD.
export GREP_COLORS="mt=$GREP_COLOR" # GNU.

# Pagers:
export LESS="-R"  # argument to allow less to show colors

# Colored man pages
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_us=$(tput bold; tput setaf 2)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
