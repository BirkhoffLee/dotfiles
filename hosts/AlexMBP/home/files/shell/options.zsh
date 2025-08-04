#!/usr/bin/env zsh

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

setopt INCAPPENDHISTORY     # Immediately append to the history file, not just when a term is killed
setopt BANG_HIST            # Treat the '!' character specially during expansion.
setopt HIST_VERIFY          # Do not execute immediately upon history expansion.
setopt HIST_BEEP            # Beep when accessing non-existent history.

# Directory Options
# @see https://github.com/sorin-ionescu/prezto/blob/master/modules/directory/init.zsh

for index ({1..9}) alias "$index"="cd +${index}"; unset index

setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
unsetopt CLOBBER            # Do not overwrite existing files with > and >>.
                            # Use >! and >>! to bypass.
