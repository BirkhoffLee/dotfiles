#!/usr/bin/env zsh

# `external.zsh` is used to load external shell tools and their configs.

# GPG AGENT
( gpg-agent --daemon > /dev/null 2>&1 & )

# rbenv
eval "$(rbenv init - zsh)"

# macOS only
if [[ "$OSTYPE" = darwin* ]]; then
  # Workaround for Ansible forking: https://github.com/ansible/ansible/issues/76322
  export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

  # Homebrew
  export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
  export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"
  export HOMEBREW_NO_ANALYTICS=1
fi

# Zoxide
# https://github.com/ajeetdsouza/zoxide/blob/main/README.md#environment-variables
export _ZO_ECHO=1 # print the matched directory before navigating to it

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

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY="$HOME/.node_history"

# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy'

# Erlang and Elixir shell history:
export ERL_AFLAGS="-kernel shell_history enabled"

# zsh-auto-notify (https://github.com/MichaelAquilina/zsh-auto-notify)
AUTO_NOTIFY_IGNORE+=("tmux" "bat" "cat" "less" "man" "zi")

# macOS only
if [[ "$OSTYPE" = darwin* ]]; then
  # OrbStack
  # This adds fpath so needs to be before compinit
  if test -f ~/.orbstack/shell/init.zsh; then
    source ~/.orbstack/shell/init.zsh 2>/dev/null || :
  fi
fi

# forgit (https://github.com/wfxr/forgit)
export FORGIT_FZF_DEFAULT_OPTS="
  --exact
  --cycle
  --reverse
  --height '100%'
  --preview-window='right:55%:nohidden:nowrap'
"

# fzf (https://github.com/junegunn/fzf)
# fzf shell integration binds C-t, C-r, Alt-C
# docs: https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line

typeset -AU __FZF __FZF_TAB

# https://github.com/junegunn/fzf/blob/master/bin/fzf-preview.sh

__FZF[PREVIEW_DIR]="eza -a --tree --level 3 --color=always --icons --no-quotes --group-directories-first --show-symlinks"

__FZF[PREVIEW_TEXT]="bat --style=numbers,changes --wrap never --color always {} || cat {}"

__FZF[PREVIEW_FILE_OR_DIR]="
  if [ -d {} ]; then
    ${__FZF[PREVIEW_DIR]} {};
  else
    if [[ \$(file --brief --dereference --mime {}) == text/* ]]; then
      ${__FZF[PREVIEW_TEXT]};
    else
      file {};
    fi;
  fi
"

__FZF_TAB[PREVIEW_TEXT]='bat --style=numbers,changes --wrap never --color always $realpath || cat $realpath'

__FZF_TAB[PREVIEW_FILE_OR_DIR]="
  if [ -d \$realpath ]; then
    ${__FZF[PREVIEW_DIR]} \$realpath;
  else
    if [[ \$(file --brief --dereference --mime \$realpath) == text/* ]]; then
      ${__FZF_TAB[PREVIEW_TEXT]};
    else
      file \$realpath;
    fi;
  fi
"

# TAB / Shift-TAB: multiple selections
# Alt-Up: preview page up, Alt-Down: preview page down
# ?: toggle preview window
# ^O: open with $VISUAL (`code` on macOS)
export FZF_DEFAULT_OPTS="
  --header '?: preview, alt-up: pgup, alt-down: pgdown, ^o: open editor'
  --color header:italic
  --style full
  --multi
  --tmux
  --bind 'alt-up:preview-page-up'
  --bind 'alt-down:preview-page-down'
  --bind 'ctrl-o:execute($VISUAL {})+abort'
  --bind '?:toggle-preview'
"

# FZF - File Browser (C-t) and Alt-C
# Override FZF_CTRL_T_COMMAND and FZF_ALT_C_COMMAND to use fd and xargs
#
# Ref: https://github.com/niksingh710/cdots/blob/bc79fa30cd62f5655b45c64cc79401082b4bd791/home/.shell/fzf.zsh#L101-L106
#
# Explanation of the options:
# -0: tells both fd and xargs to use a null character (\0) as a separator
#     instead of whitespace, which avoids issues with filenames containing
#     spaces, quotes, or other special characters.
# -tf: only regular files
# --follow: follow symlinks
# -H: follow hidden files
# -d: only directories
# -t: sort by modification time
exclude_list=(
  "--exclude .git"
  "--exclude node_modules"
  "--exclude .DS_Store"
)
export FZF_CTRL_T_COMMAND="fd -H -tf --follow ${exclude_list[*]} -0 | xargs -0 ls -t"
export FZF_ALT_C_COMMAND="fd $dirPATH -td ${exclude_list[*]} -0 | xargs -0 ls -dt"
unset exclude_list

# FZF - File Browser (C-t)
export FZF_CTRL_T_OPTS="
  --preview '${__FZF[PREVIEW_FILE_OR_DIR]}'
  --preview-window right:60%:border:wrap"

# FZF - Interactive change directory (Alt-C)
export FZF_ALT_C_OPTS="
  --preview '${__FZF[PREVIEW_DIR]} {}'"

# FZF - Shell History (C-r)
# Use `--with-nth 2..` to hide the history index
# NOTE: right now atuin is used so this is of no use
export FZF_CTRL_R_OPTS="
  --color header:italic
  --preview 'echo {}'
  --preview-window up:3:hidden:wrap
  --bind '?:toggle-preview'
  --bind 'ctrl-t:track+clear-query'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'CTRL-T: Track command, CTRL-Y: copy command to clipboard'"

# FZF - Completion Options
# https://github.com/junegunn/fzf?tab=readme-ov-file#customizing-fzf-options-for-completion

# fzf-tab (https://github.com/Aloxaf/fzf-tab)

# Use tmux popup for fzf-tab
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Note: fzf-tab does not use default fzf options
# Note: bind **<TAB> to select multiple entries (like the default in FZF)
# Note: some other flags are already set in fzf-tab code,
# refer to: https://github.com/Aloxaf/fzf-tab/blob/master/lib/-ftb-fzf#L90
zstyle ':fzf-tab:*' fzf-flags \
  --header '?: preview, alt-up: pgup, alt-down: pgdown, ^o: open editor' \
  --color header:italic \
  --style full \
  --height=-2 \
  --preview-window 'right:40%:border:wrap' \
  --bind 'tab:toggle-out' \
  --bind 'shift-tab:toggle-in' \
  --bind 'alt-up:preview-page-up' \
  --bind 'alt-down:preview-page-down' \
  --bind "ctrl-o:execute($VISUAL {})+abort" \
  --bind '?:toggle-preview'

# FIXME: does not work
# zstyle ':fzf-tab:complete:(-command-):*' fzf-preview 'builtin type -- {}'

zstyle ':fzf-tab:*:file:*' fzf-flags --height=~80% --style=full --query='!^.' --header-label=' File Type '
zstyle ':fzf-tab:*:file:*' fzf-bindings 'focus:transform-header(
    {_FTB_INIT_} {
        file -LIb ${realpath} || echo "No file selected";
        exiftool -m -fast -printFormat '' ${ImageWidth}x${ImageHeight}'' -i ${realpath} ${realpath}
    } | paste -d ";" - -
)'

# Expand the value of environment variables or similar parameters in the preview window
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# preview directory or file's content when completing some commands
zstyle ':fzf-tab:complete:(cd|vim|nano|e|cursor|code|mv|cp|rm|file):*' \
  fzf-preview "${__FZF_TAB[PREVIEW_FILE_OR_DIR]}"

# kill/ps
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-flags \
  --height=20 \
  --preview-window 'down:3:wrap'

if [[ "$OSTYPE" = darwin* ]]; then
  zstyle ':completion:*:processes-names' command "ps -wwrcau$USER -o comm | uniq" # killall
  zstyle ':completion:*:*:*:*:processes' command "ps -wwrcau$USER -o pid,user,%cpu,%mem,stat,comm"
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps -wwp$word -o comm='
elif [[ "$OSTYPE" = linux* ]]; then
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
fi

unset __FZF
unset __FZF_TAB

# Atuin (shell history)
eval "$(atuin init zsh)"
