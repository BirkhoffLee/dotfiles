# dotfiles

My macOS dotfiles managed by [nix-darwin](https://github.com/LnL7/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager), powered by [Nix](https://nixos.org/).

Works on M1 Pro, macOS Sequoia 15.5 (24F74).

## Overview

* [nix-darwin](https://github.com/LnL7/nix-darwin) sets up the macOS system environment.
  * [Nix](https://nixos.org/) enables reproducible builds.
* [home-manager](https://github.com/nix-community/home-manager) manages the user environment, including Homebrew packages.
  * However, I still use Homebrew for some packages, especially for GUI apps because they usually have self-update features that conflicts with the structure of Nix.
* Some custom scripts are included for those settings that are not supported by [nix-darwin](https://github.com/LnL7/nix-darwin) or [home-manager](https://github.com/nix-community/home-manager).

Key features:

* zsh with [p10k](https://github.com/romkatv/powerlevel10k) [instant prompt](hosts/AlessandroMBP/home/zsh/default.nix)
* [atuin](https://github.com/ellie/atuin) for shell history
* tmux configuration from [gpakosz/.tmux](https://github.com/gpakosz/.tmux)
* [fzf shell integration](hosts/AlessandroMBP/home/zsh/shell/external.zsh)
  * CTRL-T - Paste the path of selected files and directories onto the command-line
  * ALT-C - cd into the selected directory
* [fzf-tab](https://github.com/Aloxaf/fzf-tab) for zsh completion, including a smart preview window:
  * [fd](https://github.com/sharkdp/fd) for file search
  * [bat](https://github.com/sharkdp/bat) for file preview
  * [lsd](https://github.com/Peltoche/lsd) for directory listing
* A number of handy [aliases](hosts/AlessandroMBP/home/zsh/shell/aliases.zsh) and [functions](hosts/AlessandroMBP/home/zsh/shell/functions.zsh)
* [automatically propagated](hosts/AlessandroMBP/home/zsh/shell/proxy.zsh) shell proxy settings
* [Ghostty](https://ghostty.org/) as the terminal emulator, config: [ghostty.nix](hosts/AlessandroMBP/home/ghostty.nix)
* [Sets](hosts/AlessandroMBP/wallpaper.nix) a beautiful wallpaper from [Raycast](https://www.raycast.com/wallpapers)

## Usage

On a new macOS machine without Nix installed:

```console
xcode-select --install

# Install nix
bash <(curl -L https://nixos.org/nix/install) --daemon --yes --no-modify-profile

# Propagate /run
printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

# Build the dotfiles
mkdir $HOME/.config
git clone https://github.com/birkhofflee/dotfiles $HOME/.config/nix
nix build "$HOME/.config/nix#darwinConfigurations.AlessandroMBP.system" --extra-experimental-features "nix-command flakes"

./result/sw/bin/darwin-rebuild switch --flake "$HOME/.config/nix#AlessandroMBP"
```

After first successful deployment, use the following command to switch:

```console
darwin-rebuild switch --flake "$HOME/.config/nix#AlessandroMBP"
```

To update packages:

```console
nix flake update --flake "$HOME/.config/nix"
darwin-rebuild switch --flake "$HOME/.config/nix#AlessandroMBP"
```

To clean up:

```console
nix-cleanup
```

After a major macOS update:

1. Upgrade Xcode CLI tools
2. Uninstall nix: https://nix.dev/manual/nix/2.18/installation/uninstall.html#macos
3. A system restart may be required
4. Review [CHANGELOG](https://github.com/LnL7/nix-darwin/blob/master/CHANGELOG) of nix-darwin

```console
# Install nix
bash <(curl -L https://nixos.org/nix/install) --daemon --yes --no-modify-profile

# Propagate /run
printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

# Fix certs (the uninstallation of nix breaks a symbolic link)
# https://github.com/NixOS/nix/issues/2899#issuecomment-1669501326
# https://discourse.nixos.org/t/ssl-ca-cert-error-on-macos/31171/1
sudo rm /etc/ssl/certs/ca-certificates.crt
sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt

nix build "$HOME/.config/nix#darwinConfigurations.AlessandroMBP.system" --extra-experimental-features "nix-command flakes"

./result/sw/bin/darwin-rebuild switch --flake "$HOME/.config/nix#AlessandroMBP"
```

## Appendix: iTerm2 Profile Configuration

> I no longer use iTerm2, but I'll keep the configuration here for reference.

I use iTerm2 as my terminal emulator. Here are some settings that I've been using for years:

* Command: Login Shell
* Font
  + Menlo, Regular, 15
  + Anti-aliased
  + Use a different font for non-ASCII text
* Non-ASCII Font
  + Hack Nerd Font Mono, Regular, 15
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
* [Home Manager: dotfiles management](https://gvolpe.com/blog/home-manager-dotfiles-management/)
* https://xyno.space/post/nix-darwin-introduction
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
