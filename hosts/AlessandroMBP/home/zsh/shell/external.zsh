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
# fzf shell integration binds C-t, C-r, Alt-C
# docs: https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line

typeset -AU __FZF

__FZF[PREVIEW_DIR]="lsd --tree --icon always --depth 2 --color=always --timesort"
__FZF[PREVIEW_FILE]="bat --style=numbers,changes --wrap never --color always {} || cat {}"
__FZF[PREVIEW_FILE_OR_DIR]="if [ -d {} ]; then ${__FZF[PREVIEW_DIR]} {}; else ${__FZF[PREVIEW_FILE]}; fi"

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
  --bind 'ctrl-s:preview-page-up'
  --bind 'ctrl-d:preview-page-down'
  --bind 'ctrl-o:execute($VISUAL {})+abort'
  --bind '?:toggle-preview'"

# FZF - File Browser (C-t)

# export FZF_CTRL_T_OPTS="
#   --preview '${__FZF[PREVIEW_FILE_OR_DIR]}'
#   --preview-window right:60%:border"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,.DS_Store
  --preview '${__FZF[PREVIEW_FILE_OR_DIR]}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# FZF - Shell History (C-r)
# Use `--with-nth 2..` to hide the history index
export FZF_CTRL_R_OPTS="
  --color header:italic
  --preview 'echo {}'
  --preview-window up:3:hidden:wrap
  --bind '?:toggle-preview'
  --bind 'ctrl-t:track+clear-query'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'CTRL-T: Track command, CTRL-Y: copy command to clipboard'"

# FZF - Interactive change directory (Alt-C)
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules
  --preview '${__FZF[PREVIEW_DIR]} {}'"

export FZF_COMPLETION_OPTS='+c -x'

# Note: fzf-tab does not use default fzf options
# ref: https://github.com/Aloxaf/fzf-tab/blob/master/lib/-ftb-fzf#L90

# Show the value of environment variables or similar parameters in the preview window
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# preview directory's content with lsd when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --tree --icon always --depth 2 --color=always --timesort $realpath'

# kill/ps
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-flags \
  --height=20 \
  --preview-window 'down:3:wrap'

# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Bind **<TAB> to select multiple entries (like the default in FZF)
# Default bindings: https://github.com/Aloxaf/fzf-tab/blob/master/lib/-ftb-fzf#L31
zstyle ':fzf-tab:*' fzf-bindings 'tab:toggle'

# Use tmux popup for fzf-tab
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

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
