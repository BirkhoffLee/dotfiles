# dotfiles

My macOS dotfiles managed by [Chezmoi](https://github.com/twpayne/chezmoi).  

# Features

* zsh, [zinit](https://github.com/zdharma/zinit) and [p10k](https://github.com/romkatv/powerlevel10k)
* [tj/n](https://github.com/tj/n) instead of nvm
* `ls` alternative [lsd](https://github.com/Peltoche/lsd)
* Powerful tmux setup with modified [samoshkin/tmux-config](https://github.com/samoshkin/tmux-config)
* [fzf](https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh) + [fd](https://github.com/sharkdp/fd) + [bat](https://github.com/sharkdp/bat)/tree integration
  * Ctrl-T: select files in cwd recursively & interactively
    * press `?` to activate preview with [bat](https://github.com/sharkdp/bat)
      * Use Ctrl-U / Ctrl-D to page up/down
  * Use Ctrl-O to open in `$VISUAL`, or VSCode by default on macOS
  * Alt-C: interactive cd
* [Interactive git operations](https://github.com/wfxr/forgit#-features)
* Running `1 ... 9` changes the directory to the *n* previous one

# Usage

You should clone & make your own verison of dotfiles instead of directly using
this repo's configurations. Anyhow, Chezmoi does offer a convenient way to
install the dotfiles.

```console
$ curl -sfL https://git.io/chezmoi | sh
$ chezmoi init --apply https://github.com/birkhofflee/dotfiles.git # this overwrites dotfiles
```

# Performance

Two consecutive runs:

```shell
$ for i in $(seq 1 10); do /usr/bin/time /bin/zsh -i -c exit; done;
        0.22 real         0.13 user         0.04 sys
        0.17 real         0.13 user         0.03 sys
        0.24 real         0.16 user         0.04 sys
        0.22 real         0.15 user         0.04 sys
        0.17 real         0.13 user         0.03 sys
        0.16 real         0.13 user         0.03 sys
        0.21 real         0.15 user         0.04 sys
        0.25 real         0.17 user         0.04 sys
        0.22 real         0.15 user         0.04 sys
        0.18 real         0.13 user         0.03 sys

$ for i in $(seq 1 10); do /usr/bin/time /bin/zsh -i -c exit; done;
        0.18 real         0.13 user         0.03 sys
        0.18 real         0.14 user         0.03 sys
        0.22 real         0.16 user         0.04 sys
        0.19 real         0.14 user         0.04 sys
        0.20 real         0.15 user         0.04 sys
        0.23 real         0.17 user         0.04 sys
        0.19 real         0.15 user         0.04 sys
        0.17 real         0.13 user         0.03 sys
        0.16 real         0.12 user         0.03 sys
        0.17 real         0.13 user         0.03 sys
```

# Articles

Here are some reads you might find interesting:

* [Faster and enjoyable ZSH (maybe)](https://htr3n.github.io/2018/07/faster-zsh/)
* [Comparison of ZSH frameworks and plugin managers](https://gist.github.com/laggardkernel/4a4c4986ccdcaf47b91e8227f9868ded)
* [fzf examples (fzf wiki)](https://github.com/junegunn/fzf/wiki/examples)
* [p10k git status symbols](https://github.com/romkatv/powerlevel10k#what-do-different-symbols-in-git-status-mean)

# License

This project is released under [The Unlicense](LICENSE).
