#!/usr/bin/env zsh

# Switch to emacs mode instead of using vi mode
set -o emacs

# Treat slashes as word separators (https://stackoverflow.com/a/11200998/2465955)
WORDCHARS=''${WORDCHARS/\/}

# https://stackoverflow.com/a/29403520/2465955
# note: use iTerm2 Natural Text Editing keymappings preset
# changes hex 0x15 and 0x18 0x7f to delete everything to the left of
# the cursor, rather than the whole line.
bindkey "^U" backward-kill-line
bindkey "^X\\x7f" backward-kill-line

bindkey "^B" beginning-of-line

# Adds redo to 0x18 0x1f
bindkey "^X^_" redo

setopt APPENDHISTORY             # Append history to the history file (no overwriting)
setopt INCAPPENDHISTORY          # Immediately append to the history file, not just when a term is killed
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.
