# dotfiles
My macOS/Linux dotfiles managed by [Chezmoi](https://github.com/twpayne/chezmoi).  

# Features
* zsh, Prezto, [zinit](https://github.com/zdharma/zinit) and [p10k](https://github.com/romkatv/powerlevel10k)
* Uses tj/n instead of nvm
* Wraps GNU utilities in functions without a prefix for interactive use
* Running `1 ... 9` changes the directory to the *n* previous one
* Interactive git operations w/ fzf: https://github.com/wfxr/forgit#-features
* And some git aliases: https://github.com/sorin-ionescu/prezto/tree/master/modules/git#branch
* Kubernetes aliases: https://github.com/belak/prezto-contrib/tree/master/kubernetes#aliases
* [lsd](https://github.com/Peltoche/lsd) for the win! The `ls` alternative that is good to the eyes.
* Some useful aliases/functions for network administrators
* Automatic installation of macOS apps/brew packages
* Powerful tmux setup w/ modified [samoshkin/tmux-config](https://github.com/samoshkin/tmux-config)

# Usage
This repository is not meant to be used blindly. This is 100% what
I'm using right now so apparently you shouldn't follow this usage  
guide but instead fork this repo and make some changes before applying.

First install Chezmoi:

```console
curl -sfL https://git.io/chezmoi | sh
```

After that, run the following to immediately apply the dotfiles and run  
the installation script:

```console
chezmoi init --apply https://github.com/birkhofflee/dotfiles.git
```

GPG shall ask for secret key. You can delete the encrypted files in the  
repo so it shouldn't ask anymore.  
([dot_shell/encrypted_dot_dnsimple-secrets](dot_shell/encrypted_dot_dnsimple-secrets))

On any machine, pull and apply the latest changes from the repo with:

```console
chezmoi update
```

# Secrets
In `.shell/.dnsimple-secrets`:

```shell
DNSIMPLE_ID="12345"
DNSIMPLE_DOMAIN="example.com"
DNSIMPLE_API_KEY="api-key-xxxxxxx"
```

This is used by a function that points specified subdomain to Cloudflare 
proxy IP addresses on DNSimple.

# Performance

```shell
$ for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
        0.36 real         0.27 user         0.10 sys
        0.36 real         0.27 user         0.10 sys
        0.35 real         0.27 user         0.10 sys
        0.36 real         0.28 user         0.11 sys
        0.36 real         0.27 user         0.11 sys
        0.35 real         0.27 user         0.10 sys
        0.37 real         0.28 user         0.11 sys
        0.37 real         0.28 user         0.11 sys
        0.40 real         0.29 user         0.12 sys
        0.51 real         0.36 user         0.15 sys
```

# TODO

* Add iTerm2 settings

# Articles

Here are some reads you might find interesting:

* [Faster and enjoyable ZSH (maybe)](https://htr3n.github.io/2018/07/faster-zsh/)
* [Comparison of ZSH frameworks and plugin managers](https://gist.github.com/laggardkernel/4a4c4986ccdcaf47b91e8227f9868ded)

# License

This projects is released under [The Unlicense](LICENSE).
