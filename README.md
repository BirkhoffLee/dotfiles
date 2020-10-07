# dotfiles

My macOS dotfiles managed by [Chezmoi](https://github.com/twpayne/chezmoi).  

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
* ... it's countless.

# Usage

You really shouldn't install or use this dotfile repository directly. I share
this so people can look at my configurations or codes, then you can copy & paste
them into your own dotfiles.  

Every developers should maintain their own dotfiles repo, IMHO.

Anyhow, Chezmoi does offer a convenient way to install the dotfiles.

First install Chezmoi:

```console
$ curl -sfL https://git.io/chezmoi | sh # this installs chezmoi
$ chezmoi init --apply https://github.com/birkhofflee/dotfiles.git # this runs scripts and overwrites your dotfiles
```

# Performance

**EDIT** This way of measuring shell opening time is not accurate because of Instant Prompt. The loading of plugins are postponed to after interactive prompt starts.

Either way, I've been trying my best to make it faster.

```shell
> for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
        0.21 real         0.14 user         0.06 sys
        0.22 real         0.14 user         0.06 sys
        0.24 real         0.15 user         0.07 sys
        0.22 real         0.15 user         0.06 sys
        0.22 real         0.14 user         0.06 sys
        0.25 real         0.16 user         0.07 sys
        0.26 real         0.17 user         0.07 sys
        0.26 real         0.17 user         0.08 sys
        0.26 real         0.17 user         0.07 sys
        0.27 real         0.16 user         0.08 sys
```

# TODO

* Sync iTerm2 settings in here

# Articles

Here are some reads you might find interesting:

* [Faster and enjoyable ZSH (maybe)](https://htr3n.github.io/2018/07/faster-zsh/)
* [Comparison of ZSH frameworks and plugin managers](https://gist.github.com/laggardkernel/4a4c4986ccdcaf47b91e8227f9868ded)
* [fzf examples (fzf wiki)](https://github.com/junegunn/fzf/wiki/examples)
* [p10k git status symbols](https://github.com/romkatv/powerlevel10k#what-do-different-symbols-in-git-status-mean)

# License

This projects is released under [The Unlicense](LICENSE).
