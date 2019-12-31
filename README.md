# dotfiles
My macOS/Linux dotfiles managed by Chezmoi.

# Features
* Zsh with oh-my-zsh and antibody.
* Powerful tmux setup using a modified version of [samoshkin/tmux-config](https://github.com/samoshkin/tmux-config)

# Usage
First install [Chezmoi](https://github.com/twpayne/chezmoi): https://github.com/twpayne/chezmoi/blob/master/docs/INSTALL.md#one-line-package-install.

After that, run the following to immediately apply the dotfiles and run the installation script:
```
$ chezmoi init --apply https://github.com/birkhofflee/dotfiles.git
```

On any machine, pull and apply the latest changes from the repo with:
```
$ chezmoi update
```

# License
This projects is with [The Unlicense](LICENSE).
