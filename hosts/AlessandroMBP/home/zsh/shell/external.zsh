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

typeset -AU __FZF __FZF_TAB

# https://github.com/junegunn/fzf/blob/master/bin/fzf-preview.sh

__FZF[PREVIEW_DIR]="lsd --tree --icon always --depth 2 --color=always --timesort"
__FZF[PREVIEW_TEXT]="bat --style=numbers,changes --wrap never --color always {} || cat {}"
__FZF[PREVIEW_FILE_OR_DIR]="if [ -d {} ]; then ${__FZF[PREVIEW_DIR]} {}; else if [[ \$(file --brief --dereference --mime {}) == text/* ]]; then ${__FZF[PREVIEW_TEXT]}; else file {}; fi; fi"

__FZF_TAB[PREVIEW_TEXT]='bat --style=numbers,changes --wrap never --color always $realpath || cat $realpath'
__FZF_TAB[PREVIEW_FILE_OR_DIR]="if [ -d \$realpath ]; then ${__FZF[PREVIEW_DIR]} \$realpath; else if [[ \$(file --brief --dereference --mime \$realpath) == text/* ]]; then ${__FZF_TAB[PREVIEW_TEXT]}; else file \$realpath; fi; fi"

# TAB / Shift-TAB: multiple selections
# ^S: preview page up, ^D: preview page down
# ?: toggle preview window
# ^O: open with $VISUAL (`code` on macOS)
export FZF_DEFAULT_OPTS="
  --header '?: preview, ^s: pgup, ^d: pgdown, ^o: open editor'
  --color header:italic
  --style full
  --border
  --multi
  --tmux
  --bind 'ctrl-s:preview-page-up'
  --bind 'ctrl-d:preview-page-down'
  --bind 'ctrl-o:execute($VISUAL {})+abort'
  --bind '?:toggle-preview'
"

# FZF - File Browser (C-t)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules
  --preview '${__FZF[PREVIEW_FILE_OR_DIR]}'
  --preview-window right:60%:border:wrap"

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

# FZF - Interactive change directory (Alt-C)
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules
  --preview '${__FZF[PREVIEW_DIR]} {}'"

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
  --header '?: preview, ^s: pgup, ^d: pgdown, ^o: open editor' \
  --color header:italic \
  --style full \
  --height=-2 \
  --border \
  --preview-window 'right:40%:border:wrap' \
  --bind 'tab:toggle-out' \
  --bind 'shift-tab:toggle-in' \
  --bind 'ctrl-s:preview-page-up' \
  --bind 'ctrl-d:preview-page-down' \
  --bind "ctrl-o:execute($VISUAL {})+abort" \
  --bind '?:toggle-preview'

# FIXME: does not work
# zstyle ':fzf-tab:complete:(-command-):*' fzf-preview 'builtin type -- {}'

# Expand the value of environment variables or similar parameters in the preview window
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# preview directory or file's content when completing some commands
zstyle ':fzf-tab:complete:(cd|vim|nano|e|cursor|code|mv|cp|rm):*' \
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
