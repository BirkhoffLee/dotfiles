# dotfiles

My macOS dotfiles managed by [Chezmoi](https://github.com/twpayne/chezmoi).  

## Features

* zsh, [zinit](https://github.com/zdharma/zinit) and [p10k](https://github.com/romkatv/powerlevel10k)
* [fzf-tab](https://github.com/Aloxaf/fzf-tab) for completion fuzzy-search
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

## Usage

You should clone & make your own verison of dotfiles instead of directly using
this repo's configurations. Anyhow, Chezmoi does offer a convenient way to
install the dotfiles.

```console
$ curl -sfL https://git.io/chezmoi | sh
$ chezmoi init --apply https://github.com/birkhofflee/dotfiles.git # this overwrites dotfiles
```

## TODOs

* https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
* https://github.com/ahmedelgabri/dotfiles/blob/main/config/zsh.d/.zshrc
* https://github.com/kornicameister/dotfiles/
* https://github.com/Aloxaf/dotfiles/tree/master/zsh/.config/zsh
* https://github.com/finnurtorfa/zsh/blob/master/completion.zsh
* https://github.com/paulmillr/dotfiles
* https://github.com/marlonrichert/.config/tree/main/zsh
* https://github.com/mashehu/dotfiles/blob/master/zshrc

## Articles

Here are some reads you might find interesting:

* [Faster and enjoyable ZSH (maybe)](https://htr3n.github.io/2018/07/faster-zsh/)
* [Comparison of ZSH frameworks and plugin managers](https://gist.github.com/laggardkernel/4a4c4986ccdcaf47b91e8227f9868ded)
* [fzf examples (fzf wiki)](https://github.com/junegunn/fzf/wiki/examples)
* [p10k git status symbols](https://github.com/romkatv/powerlevel10k#what-do-different-symbols-in-git-status-mean)

## License

This project is released under [The Unlicense](LICENSE).
