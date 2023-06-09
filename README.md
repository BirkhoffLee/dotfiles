# dotfiles

My macOS dotfiles managed by [Chezmoi](https://github.com/twpayne/chezmoi) (M1 fully supported)

## Features

I primarily use Macs, therefore this repo is mainly for my own use on macOS. However I do try to make it work on Linux as well.

I'm currently transitioning to the use of [nix](https://nixos.org/). Being overwhelmed, I use a hybrid setup of nix and homebrew right now since some packages are not available on nixpkgs yet.

Here's an overview of the features:

* [Declarative](dot_nixpkgs/darwin-configuration.nix.tmpl) macOS with [nix-darwin](https://github.com/LnL7/nix-darwin)
* zsh, [zinit](https://github.com/zdharma/zinit) and [p10k](https://github.com/romkatv/powerlevel10k)
* [tj/n](https://github.com/tj/n) instead of nvm
* [gpakosz/.tmux](https://github.com/gpakosz/.tmux)
* [fzf-tab](https://github.com/Aloxaf/fzf-tab) for completion
* [Integration](dot_shell/external.zsh.tmpl) of [fzf](https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh), [fd](https://github.com/sharkdp/fd), [bat](https://github.com/sharkdp/bat) and [lsd](https://github.com/Peltoche/lsd)
  + ^T: interactively select files in cwd recursively
    - `?` to toggle preview
    - ^S ^D: page up/down
  + ^O to open in `$VISUAL` (VS Code on macOS)
  + Alt-C: interactive cd
* Interactive git operations with [forgit](https://github.com/wfxr/forgit#-features)

## Usage

While one's supposed to maintain their own dotfiles, I do suppose my dotfiles can be used as a good starting point for beginners. You can fork the repository and change whatever you like. Here's a one-liner to get started:

```console
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply birkhofflee --depth 1
```

## iTerm2 Profile Configuration

I use iTerm2 as my terminal emulator. Here are some settings that I've been using for years:

* Command: Login Shell
* Font
  + Hack Nerd Font Mono, Regular, 14
  + Anti-aliased
  + Use a different font for non-ASCII text
* Non-ASCII Font
  + Hack Nerd Font Mono, Regular, 12
  + Use ligatures
  + Anti-aliased
* Settings for New Windows - 144, 41
* Enable mouse reporting
* Silence bell
* Left Option Key: Esc+
* Right Option Key: Normal

### Key Mappings (included in [Terminal.itermkeymap](Terminal.itermkeymap)):

I use the built-in *Natural Text Editing* preset, with the following custom key mappings:

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

## TODOs

* manage python versions/dependencies with nix
* manage nodejs with nix
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
