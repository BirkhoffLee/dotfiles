#!/usr/bin/env zsh

# `.completions` is used to configure completion-related settings.

# https://github.com/Aloxaf/dotfiles/blob/0619025cb2c2264cd0639b3697e3483454b2cadd/zsh/.config/zsh/snippets/completion.zsh

setopt COMPLETE_IN_WORD # autocomplete in middle of a word
setopt NO_BEEP # disable beep sound
setopt AUTO_PARAM_SLASH # (autocomplete) If completed parameter is a directory, add a trailing slash
unsetopt MENU_COMPLETE # Do not autoselect the first completion entry
unsetopt FLOW_CONTROL # Disable start/stop characters (^Z, ^C, etc) in shell editor

# Use new completion system
zstyle ':completion:*' use-compctl false
compctl () { }

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion:*' use-cache yes
zstyle ':completion:*:complete:*' cache-policy _COMP_CACHING_POLICY
_COMP_CACHING_POLICY() {
  # If cache don't exist or are older than 14 days, consider them invalid
  [[ ! -f $1 && -n "$1"(Nm+14) ]]
}

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
  clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
  gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
  ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
  operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
  usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# 补全顺序:
# _complete - 普通补全函数  _extensions - 通过 *.\t 选择扩展名
# _match    - 和 _complete 类似但允许使用通配符
# _expand_alias - 展开别名 _ignored - 被 ignored-patterns 忽略掉的
# zstyle ':completion:*' completer _expand_alias _complete _extensions _match _files
# 由于某些 completer 调用的代价比较昂贵，第一次调用时不考虑它们
zstyle -e ':completion:*' completer '
  if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]]; then
    _last_try="$HISTNO$BUFFER$CURSOR"
    reply=(_expand_alias _complete _extensions _match _files)
  else
    reply=(_complete _ignored _correct _approximate)
  fi'

# 增强版文件名补全
# 0 - 完全匹配 ( Abc -> Abc )      1 - 大写修正 ( abc -> Abc )
# 2 - 单词补全 ( f-b -> foo-bar )  3 - 后缀补全 ( .cxx -> foo.cxx )
zstyle ':completion:*:(argument-rest|files):*' matcher-list '' \
    'm:{[:lower:]-}={[:upper:]_}' \
    'r:|[.,_-]=* r:|=*' \
    'r:|.=* r:|=*'
# zstyle ':completion:*' matcher-list 'b:=*'

# 不展开普通别名
zstyle ':completion:*' regular false

# color
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 结果样式
zstyle ':completion:*' menu no
zstyle ':completion:*' list-separator ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:descriptions' format '[%d]'

# 补全当前用户所有进程列表
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':completion:*:kill:*' ignored-patterns '0'

function kubectl() {
  if ! type __start_kubectl >/dev/null 2>&1; then
    source <(command kubectl completion zsh)
  fi

  command kubectl "$@"
}

# complete manual by their section, from grml
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true

# 补全第三方 Git 子命令
# 直接用 git-extras 提供的补全更好
# zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}

# Docker: Short-option stacking can be enabled
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# fg/bg 补全时使用 jobs id
zstyle ':completion:*:jobs' verbose true
zstyle ':completion:*:jobs' numbers true

zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:exa' sort false
zstyle ':completion:*:docker' sort false
zstyle ':completion:files' sort false
