# dotfiles

My macOS dotfiles managed by [Chezmoi](https://github.com/twpayne/chezmoi) (M1 fully supported)

## Features

* zsh, [zinit](https://github.com/zdharma/zinit) and [p10k](https://github.com/romkatv/powerlevel10k)
* [fzf-tab](https://github.com/Aloxaf/fzf-tab) for completion
* [tj/n](https://github.com/tj/n) instead of nvm
* `ls` alternative [lsd](https://github.com/Peltoche/lsd)
* [gpakosz/.tmux](https://github.com/gpakosz/.tmux)
* [fzf](https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh) + [fd](https://github.com/sharkdp/fd) + [bat](https://github.com/sharkdp/bat)/[lsd](https://github.com/Peltoche/lsd) integration
  + ^T: interactively select files in cwd recursively
    - `?` to toggle preview
    - ^E ^D: page up/down
  + ^O to open in `$VISUAL` (VS Code on macOS)
  + Alt-C: interactive cd
* [Interactive git operations](https://github.com/wfxr/forgit#-features)

## Usage

You should clone & make your own verison of dotfiles instead of directly using
this repo's configurations. Anyhow, Chezmoi does offer a convenient way to
install the dotfiles.

```console
sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply birkhofflee
```

## iTerm2 Profile Configuration

* Command: `/bin/zsh -c "tmux new -As0"`
* Font
  + Monaco Regular 13
  + Anti-aliased
  + Use a different font for non-ASCII text
* Non-ASCII Font
  + Hack Nerd Font Regular 13
  + Use ligatures
  + Anti-aliased
* Settings for New Windows - 144, 41
* Enable mouse reporting
* Silence bell
* Left Option Key: Esc+
* Right Option Key: Normal

### Key Mappings (included in [Terminal.itermkeymap](Terminal.itermkeymap)):

Using Natural Text Editing preset, and the following:

| Key     | Send Hex Codes | Description                          |
| ------- | -------------- | ------------------------------------ |
| ⌘Z     | `0x1f`       | undo                                 |
| ⇧⌘Z   | `0x18 0x1f`  | redo                                 |
| ⌥Del→ | `0x17`       | delete word                          |
| ⌘←    | `0x2`        | go to beginning of line              |
| ⇧⌘↵  | `0x1 0x7a`   | maximize pane in current window      |
| ⌃⌘F   | `0x1 0x2b`   | move pane to new window              |
| ⇧⌘D   | `0x1 0x2d`   | splits the current pane vertically   |
| ⌘D     | `0x1 0x5f`   | splits the current pane horizontally |
| ⇧⌘R   | `0x1 0x72`   | reload tmux config                   |
| ⇧⌘←  | `0x1 0x68`   | navigate to the pane on the left     |
| ⇧⌘↓  | `0x1 0x6a`   | navigate to the pane on the bottom   |
| ⇧⌘↑  | `0x1 0x6b`   | navigate to the pane on the top      |
| ⇧⌘→  | `0x1 0x6c`   | navigate to the pane on the right    |
| ⌥⌘←  | `0x1 0x8`    | switch to previous window            |
| ⌥⌘→  | `0x1 0xc`    | switch to next window                |

## Notes

* VirtualBox is not and will not implement support towards ARM64.
* avifenc is not currently available on ARM64.
*

## TODOs

* pbcopy reattach to user namespace
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
