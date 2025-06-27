#!/usr/bin/env zsh

# https://github.com/sorin-ionescu/prezto/blob/master/modules/utility/init.zsh

# Disable correction.
alias ack='nocorrect ack'
alias cd='nocorrect cd'
alias cp='nocorrect cp'
alias ebuild='nocorrect ebuild'
alias gcc='nocorrect gcc'
alias gist='nocorrect gist'
alias grep='nocorrect grep'
alias heroku='nocorrect heroku'
alias ln='nocorrect ln'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias mysql='nocorrect mysql'
alias rm='nocorrect rm'

# Disable globbing.
alias bower='noglob bower'
alias fc='noglob fc'
alias find='noglob find'
alias ftp='noglob ftp'
alias history='noglob history'
alias locate='noglob locate'
alias rake='noglob rake'
alias rsync='noglob rsync'
alias scp='noglob scp'
alias sftp='noglob sftp'

# Define general aliases.
alias _='sudo'
alias b='${(z)BROWSER}'

alias diffu="diff --unified"
alias p='${(z)PAGER}'
alias po='popd'
alias pu='pushd'
alias sa='alias | grep -i'
alias type='type -a'

# Safe ops. Ask the user before doing anything destructive.
alias rmi="${aliases[rm]:-rm} -i"
alias mvi="${aliases[mv]:-mv} -i"
alias cpi="${aliases[cp]:-cp} -i"
alias lni="${aliases[ln]:-ln} -i"
if zstyle -T ':prezto:module:utility' safe-ops; then
  alias rm="${aliases[rm]:-rm} -i"
  alias mv="${aliases[mv]:-mv} -i"
  alias cp="${aliases[cp]:-cp} -i"
  alias ln="${aliases[ln]:-ln} -i"
fi

# ls
alias sl='ls'
alias l='ls'

command -v eza > /dev/null && {
  alias ls='eza -1 --group-directories-first --icons --hyperlink --no-quotes'
  alias ll='ls -l' # long format
  alias la='ls -la' # long format + show hidden and 'dot' files
  alias tree='ls --tree --level 3'
} || {
  # command -v lsd > /dev/null && {
  #   alias ls='lsd --group-dirs first --hyperlink auto --icon always'
  #   alias tree='ls -lhA --tree'
  # }

  alias ls='ls -1A'
  alias ll='ls -lh'
  alias lr='ll -R'
  alias la='ll -A'
  
  # GNU ls only
  alias lx='ll -XB' # Lists sorted by extension
  alias lc='lt -c' # Lists sorted by date, most recent last, shows change time
  alias lu='lt -u' # Lists sorted by date, most recent last, shows access time
}

alias grep="${aliases[grep]:-grep} --color=auto"

# jq with pager
alias j="jq -C | less -R"

# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

alias http-serve='python3 -m http.server'

alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'

alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'

# Clear ZSH history
alias clear_history='> ~/.zsh_history ; exec $SHELL -l'

# File Download
if (( $+commands[curl] )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
elif (( $+commands[wget] )); then
  alias get='wget --continue --progress=bar --timestamping'
fi

# dig
command -v kdig > /dev/null && alias dig='kdig'

command -v gh > /dev/null && alias gist='gh gist create'

command -v cht.sh > /dev/null && alias help='cht.sh'

# View disk usage
command -v ncdu > /dev/null && alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"

# docker
command -v docker > /dev/null && {
  alias d='docker'
  alias dp='docker ps -a'
  alias dr='docker rm'
  alias di='docker inspect'
  alias dvl='docker volume ls'
  alias dvi='docker volume inspect'
  alias dvp='docker volume inspect --format ''{{ .Mountpoint }}'''

  # compose
  alias dc='docker-compose'
  alias dclf='docker-compose logs -f'
  alias dcu='docker-compose up -d'
  alias dcr='docker-compose restart'
  alias dcub='docker-compose up -d --build'
  alias dcb='docker-compose build'
  alias dcd='docker-compose down'
}

if [[ "$OSTYPE" != darwin* ]]; then
  # not darwin
  alias pbcopy='xclip'
else
  # darwin
  if [[ -f "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]]; then
    alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
  fi

  alias mtr='sudo mtr'
  alias htop='sudo htop'

  alias pbc='pbcopy'
  alias pbp='pbpaste'

  alias o='open'

  # Send file to yoink
  alias yoink="open -a Yoink"

  # Bell when the program is finished, e.g.: `npm install | a`
  alias a="terminal-notifier -sound default -message 'Command complete' -title 'Shell'"

  # Lock the screen (when going AFK)
  alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

  # Copy SSH public key to clipboard
  alias pubkey="cat ~/.ssh/id_ed25519.pub | pbcopy | echo '=> Public key (ed25519) copied to pasteboard.'"
  alias sshkey="pubkey"

  # Homebrew
  command -v brew > /dev/null && alias brewery='brew update && brew upgrade && brew cleanup'

  # Quick connect
  alias q='ssh -v'
  
  # LLM
  alias files-to-prompt='uvx files-to-prompt'
fi
