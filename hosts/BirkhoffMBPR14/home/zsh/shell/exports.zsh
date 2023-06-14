#!/usr/bin/env zsh

# `.exports` is used to provide custom variables.

# Language
export LANG=en_US.UTF-8
export LC_ALL="en_US.UTF-8"

# Editor
code_insiders_path=$(which code-insiders 2>/dev/null)
code_path=$(which code 2>/dev/null)

if [ -f "$code_insiders_path" ]; then
  export EDITOR=$code_insiders_path
elif [ -f "$code_path" ]; then
  export EDITOR=$code_path
else
  export EDITOR=$(which vim)
fi

export VISUAL="$EDITOR"

# macOS only
if [[ "$OSTYPE" = darwin* ]]; then
  # Workaround for Ansible forking: https://github.com/ansible/ansible/issues/76322
  export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

  # GPG AGENT
  # export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

  # 1Password SSH Key Agent
  export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

  # Homebrew
  export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
  export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"
  export HOMEBREW_NO_ANALYTICS=1
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

# dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8'

# virtualenv
export PIPENV_VENV_IN_PROJECT=true # look for `.venv` dir inside project
export PIPENV_HIDE_EMOJIS=true # no emojis!
export PIPENV_COLORBLIND=true # disables colors, so colorful!
export PIPENV_NOSPIN=true # disables spinner for cleaner logs

# virtualenvwrapper
if command -v "virtualenvwrapper_lazy.sh" &> /dev/null; then
  export WORKON_HOME=$HOME/.virtualenvs
  export PROJECT_HOME=$HOME/Devel
  export VIRTUALENVWRAPPER_PYTHON=$commands[python3]
  export VIRTUALENVWRAPPER_SCRIPT=$commands[virtualenvwrapper.sh]
  source $commands[virtualenvwrapper_lazy.sh]
fi

# n
export N_PREFIX="$HOME/.n"
PATH="$N_PREFIX/bin:$PATH"

# rbenv
eval "$(rbenv init - zsh)"

# rvm
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY="$HOME/.node_history"

# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy'

# Erlang and Elixir shell history:
export ERL_AFLAGS="-kernel shell_history enabled"
