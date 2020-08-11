# dotfiles
My macOS/Linux dotfiles managed by [Chezmoi](https://github.com/twpayne/chezmoi).  

# Features
* zsh, Prezto, [zinit plugin manager](https://github.com/zdharma/zinit) and [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
* Uses tj/n instead of nvm
* Running `1 ... 9` changes the directory to the *n* previous one
* Wraps GNU utilities in functions without a prefix for interactive use
* Fish-like autosuggestions
* Interactive git operations w/ fzf: https://github.com/wfxr/forgit#-features
* And some git aliases: https://github.com/sorin-ionescu/prezto/tree/master/modules/git#branch
* Some useful aliases/functions for network administrators
* Automatic installation of macOS apps/brew packages
* Powerful tmux setup w/ modified [samoshkin/tmux-config](https://github.com/samoshkin/tmux-config)

# Usage
This repository is not meant to be used blindly. This is 100% what
I'm using right now so apparently you shouldn't follow this usage 
guide but instead fork this repo and make some changes before applying.

First install Chezmoi:
```
$ curl -sfL https://git.io/chezmoi | sh
```

After that, run the following to immediately apply the dotfiles and run 
the installation script:
```
$ chezmoi init --apply https://github.com/birkhofflee/dotfiles.git
```
GPG shall ask for secret key. You can delete the encrypted files in the 
repo so it shouldn't ask anymore. 
([dot_shell/encrypted_dot_dnsimple-secrets](dot_shell/encrypted_dot_dnsimple-secrets))

On any machine, pull and apply the latest changes from the repo with:
```
$ chezmoi update
```

# Secrets
In `.shell/.dnsimple-secrets`:
```
DNSIMPLE_ID="12345"
DNSIMPLE_DOMAIN="example.com"
DNSIMPLE_API_KEY="api-key-xxxxxxx"
```
This is used by a function that points specified subdomain to Cloudflare 
proxy IP addresses on DNSimple.

# Performance
```
~
> for i in $(seq 1 5); do /usr/bin/time /bin/zsh -i -c exit; done
        0.24 real         0.14 user         0.08 sys
        0.32 real         0.16 user         0.10 sys
        0.25 real         0.14 user         0.08 sys
        0.27 real         0.14 user         0.10 sys
        0.27 real         0.14 user         0.09 sys
```

# Articles
Here are some reads you might find interesting:
* [Faster and enjoyable ZSH (maybe)](https://htr3n.github.io/2018/07/faster-zsh/)
* [Comparison of ZSH frameworks and plugin managers](https://gist.github.com/laggardkernel/4a4c4986ccdcaf47b91e8227f9868ded)

# License
This projects is released under [The Unlicense](LICENSE).
