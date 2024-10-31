# dotfiles

My macOS dotfiles managed by [Nix](https://nixos.org/),
[home-manager](https://github.com/nix-community/home-manager) and
[nix-darwin](https://github.com/LnL7/nix-darwin). Works on M1 Pro, macOS Sequoia 15.1.

## Overview

Nix enables reproducible builds. It manages all the packages (and those on
Homebrew), and [nix-darwin](https://github.com/LnL7/nix-darwin) sets up the
environment for macOS. Some custom scripts are included for those settings that
are not supported by [nix-darwin](https://github.com/LnL7/nix-darwin).

Some shell features worth mentioning:

* [Declarative](dot_nixpkgs/darwin-configuration.nix.tmpl) macOS with [nix-darwin](https://github.com/LnL7/nix-darwin)
* zsh with [p10k](https://github.com/romkatv/powerlevel10k)
* [tj/n](https://github.com/tj/n) instead of nvm
* [gpakosz/.tmux](https://github.com/gpakosz/.tmux)
* [fzf-tab](https://github.com/Aloxaf/fzf-tab) for completion
* [Integration](dot_shell/external.zsh.tmpl) of [fzf](https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh), [fd](https://github.com/sharkdp/fd), [bat](https://github.com/sharkdp/bat) and [lsd](https://github.com/Peltoche/lsd)
  + ^T: interactively select files in cwd recursively
    - `?` to toggle preview
    - ^S ^D: page up/down
  + ^O to open in `$VISUAL` (VS Code on macOS)
  + ^R to fuzzy search command line history
  + Alt-C: interactive cd
* Interactive git operations with [forgit](https://github.com/wfxr/forgit#-features)

## Usage

On a new macOS machine w/o Nix installed:

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
cd $HOME/.config/nix
nix flake update .
nix flake update
darwin-rebuild switch --flake "$HOME/.config/nix#AlessandroMBP"
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

* enable pam_reattach in /etc/pam.d/sudo
  * https://gist.github.com/smunix/02d7a208a8478ebb4cbc4afe47e5ea8d
  * https://github.com/fabianishere/pam_reattach
* manage python versions/dependencies with nix
* manage nodejs with nix
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
