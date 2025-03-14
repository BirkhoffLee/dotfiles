#!/usr/bin/env zsh

# `.external` handles all external tools.
#
# This file is used as a part of `.shell_env`

( gpg-agent --daemon > /dev/null 2>&1 & )

# zsh-auto-notify (https://github.com/MichaelAquilina/zsh-auto-notify)
AUTO_NOTIFY_IGNORE+=("tmux" "bat")

# macOS only
if [[ "$OSTYPE" = darwin* ]]; then
  # OrbStack
  # This adds fpath so needs to be before compinit
  if test -f ~/.orbstack/shell/init.zsh; then
    source ~/.orbstack/shell/init.zsh 2>/dev/null || :
  fi

  # micromamba lazy load
  mm () {
    export MAMBA_EXE="$HOMEBREW_PREFIX/opt/micromamba/bin/micromamba";
    export MAMBA_ROOT_PREFIX="$HOME/micromamba";
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        if [ -f "$HOME/micromamba/etc/profile.d/micromamba.sh" ]; then
            . "$HOME/micromamba/etc/profile.d/micromamba.sh"
        else
            export  PATH="$HOME/micromamba/bin:$PATH"  # extra space after export prevents interference from conda init
        fi
    fi
    unset __mamba_setup

    micromamba activate
  }
fi

# forgit (https://github.com/wfxr/forgit)

# --ansi is required for forgit to display colors

export FORGIT_FZF_DEFAULT_OPTS="
  --ansi
  --exact
  --border
  --cycle
  --reverse
  --height '80%'
  --preview-window='right:55%:nohidden:nowrap'
"

# fzf (https://github.com/junegunn/fzf)

typeset -AU __FZF

__FZF[PREVIEW_DIR]="lsd --tree --icon always --depth 2 --color=always --timesort"

# TAB / Shift-TAB: multiple selections
# ^S: preview page up, ^D: preview page down
# ?: toggle preview window
# ^O: open with $VISUAL (`code` on macOS)
export FZF_DEFAULT_OPTS="
  --border
  --inline-info
  --reverse
  --tabstop 2
  --multi
  --prompt='» '
  --pointer=' '
  --marker='✓ '
  --bind 'ctrl-s:preview-page-up'
  --bind 'ctrl-d:preview-page-down'
  --bind 'ctrl-o:execute($VISUAL {})+abort'
  --bind '?:toggle-preview'"

#FIXME: file type
export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {} || cat {} || ${__FZF[PREVIEW_DIR]} {}"

export FZF_CTRL_T_OPTS="
  --preview '($FZF_PREVIEW_COMMAND)'
  --preview-window right:60%:border"

export FZF_CTRL_R_OPTS="
  --layout default
  --height 20
  --preview 'echo {}'
  --preview-window down:3:wrap:hidden
  --bind '?:toggle-preview,ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'Press ^Y to copy command into clipboard'"

export FZF_ALT_C_OPTS="--preview '${__FZF[PREVIEW_DIR]} {}'"

export FZF_COMPLETION_OPTS='+c -x'

zstyle ':fzf-tab:*' fzf-command fzf

# env
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

# kill/ps
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-flags \
  --height=20 \
  --preview-window 'down:3:wrap'

if [[ "$OSTYPE" = darwin* ]]; then
  zstyle ':completion:*:processes-names' command "ps -wwrcau$USER -o comm | uniq" # killall
  zstyle ':completion:*:*:*:*:processes' command "ps -wwrcau$USER -o pid,user,%cpu,%mem,stat,comm"
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps -wwp$word -o comm='
fi

if [[ "$OSTYPE" = solaris* ]]; then
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm"
fi

if [[ "$OSTYPE" = linux* ]]; then
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
  zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
fi
