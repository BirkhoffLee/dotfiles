# dotfiles
My macOS/Linux dotfiles managed by [Chezmoi](https://github.com/twpayne/chezmoi).

# Features
* Zsh with oh-my-zsh and antibody.
* Useful aliases/functions for network administrators.
* Automatic installation of macOS apps/brew packages.
* Powerful tmux setup using a modified version of [samoshkin/tmux-config](https://github.com/samoshkin/tmux-config)

# Usage
This repository is not meant to be used blindly. This is 100% what
I'm using right now so you should fork and modify it to suit your needs.

First install Chezmoi:
```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew install twpayne/taps/chezmoi

or on RHEL/CentOS:

$ yum install git -y
$ curl -sfL https://git.io/chezmoi | sh
```

After that, run the following to immediately apply the dotfiles and run the installation script:
```
$ chezmoi init --apply https://github.com/birkhofflee/dotfiles.git
```
GPG shall ask for secret key. You can delete the encrypted files in the repo so
it shouldn't ask anymore. ([dot_shell/encrypted_dot_dnsimple-secrets](dot_shell/encrypted_dot_dnsimple-secrets))

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
This is used by a function that points specified subdomain to Cloudflare proxy
IP addresses on DNSimple.

# Performance
```
~
▶ for i in $(seq 1 5); do /usr/bin/time /bin/zsh -i -c exit; done
        0.52 real         0.27 user         0.19 sys
        0.63 real         0.33 user         0.22 sys
        0.48 real         0.26 user         0.17 sys
        0.48 real         0.26 user         0.17 sys
        0.46 real         0.25 user         0.17 sys
```

# TODO
* Remove server side shell configuration. Shell on servers should be as user-hostile as possible.

# License
This projects is released under [The Unlicense](LICENSE).
