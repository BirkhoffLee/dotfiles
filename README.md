# dotfiles

My macOS/Linux dotfiles managed by [Chezmoi](https://github.com/twpayne/chezmoi).  

# Features

* zsh, Prezto, [zinit](https://github.com/zdharma/zinit) and [p10k](https://github.com/romkatv/powerlevel10k)
* [tj/n](https://github.com/tj/n) instead of nvm
* `ls` alternative [lsd](https://github.com/Peltoche/lsd)
* Powerful tmux setup with modified [samoshkin/tmux-config](https://github.com/samoshkin/tmux-config)
* Useful [fuzzy completion](https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh) in shell with fzf
* C-t / Alt-C invokes fzf + fd + bat/tree to preview files/directories
  * Use C-u / C-d to page up/down
  * Use C-o to open in VSCode (macOS)
* [Interactive git operations w/ fzf](https://github.com/wfxr/forgit#-features)
* [git aliases](https://github.com/sorin-ionescu/prezto/tree/master/modules/git#branch)
* [Kubernetes aliases](https://github.com/belak/prezto-contrib/tree/master/kubernetes#aliases)
* Running `1 ... 9` changes the directory to the *n* previous one

# Usage

You really shouldn't install/use this dotfile repository directly. I share this mostly for references purposes only.  
You should create your own dotfiles and probably copy some of my codes/configs. But Chezmoi do offer a convenient way
to install the dotfiles.

First install Chezmoi:

```console
curl -sfL https://git.io/chezmoi | sh
```

After that, run the following to immediately apply the dotfiles and run the installation script:

```console
chezmoi init --apply https://github.com/birkhofflee/dotfiles.git
```

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
