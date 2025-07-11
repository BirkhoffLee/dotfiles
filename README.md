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

* zsh with [p10k](https://github.com/romkatv/powerlevel10k) [instant prompt](hosts/AlexMBP/home/zsh/default.nix)
  * Prompt theme is p10k Lean style. Git status symbols docs can be found [here](https://github.com/romkatv/powerlevel10k#what-do-different-symbols-in-git-status-mean).
* [fzf shell integration](hosts/AlexMBP/home/zsh/shell/external.zsh)
  * CTRL-T - Paste the path of selected files and directories onto the command-line
  * ALT-C - cd into the selected directory
* [fzf-tab](https://github.com/Aloxaf/fzf-tab) for zsh completion, including a smart preview window:
  * [fd](https://github.com/sharkdp/fd) for file search
  * [bat](https://github.com/sharkdp/bat) for file preview
  * [eza](https://github.com/eza-community/eza) for directory listing
* [atuin](https://github.com/ellie/atuin) for shell history
* tmux configuration from [gpakosz/.tmux](https://github.com/gpakosz/.tmux)
* A number of handy [aliases](hosts/AlexMBP/home/zsh/shell/aliases.zsh) and [functions](hosts/AlexMBP/home/zsh/shell/functions.zsh)
* [automatically propagated](hosts/AlexMBP/home/zsh/shell/proxy.zsh) shell proxy settings
* [Ghostty](https://ghostty.org/) as the terminal emulator, config: [ghostty.nix](hosts/AlexMBP/home/ghostty.nix)
* [Sets](hosts/AlexMBP/wallpaper.nix) a beautiful wallpaper from [Raycast](https://www.raycast.com/wallpapers)

## Usage

On a new macOS machine without Nix installed:

```console
xcode-select --install

# Clone the dotfiles
mkdir $HOME/.config
git clone https://github.com/birkhofflee/dotfiles $HOME/.config/nix

# Install nix with Determinate Systems installer
# Choose "no" to use the upstream nix instead of their own one
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# Source the nix daemon so that the nix command is available immediately
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Build the dotfiles
nix build "$HOME/.config/nix#darwinConfigurations.AlexMBP.system" --extra-experimental-features "nix-command flakes"

# Apply the dotfiles
sudo ./result/sw/bin/darwin-rebuild switch --flake "$HOME/.config/nix#AlexMBP"
```

After first successful deployment, use the following command to switch:

```console
sudo darwin-rebuild switch --flake "$HOME/.config/nix#AlexMBP"
```

To update packages:

```console
nix flake update --flake "$HOME/.config/nix"
sudo darwin-rebuild switch --flake "$HOME/.config/nix#AlexMBP"
```

To clean up:

```console
nix-cleanup
```

> [!IMPORTANT]
> The following steps were applicable to installations with the original Nix
> installer. It is unknown whether they are needed to follow for a Determinate
> Systems installation.

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

nix build "$HOME/.config/nix#darwinConfigurations.AlexMBP.system" --extra-experimental-features "nix-command flakes"

sudo ./result/sw/bin/darwin-rebuild switch --flake "$HOME/.config/nix#AlexMBP"
```

## TODOs

* File completion
  * List directories first like [this](https://github.com/Aloxaf/fzf-tab/pull/518)
  * When completing with fzf-tab, there's the slash in file names which i dont like
* Manage python versions/dependencies with nix
* Manage nodejs with nix
* [Home Manager: dotfiles management](https://gvolpe.com/blog/home-manager-dotfiles-management/)
* Use [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) to ensure consistency across different platforms

Some other dotfiles worth looking into:

* https://github.com/malob/nixpkgs
* https://github.com/ahmedelgabri/dotfiles
* https://github.com/kornicameister/dotfiles/
* https://github.com/Aloxaf/dotfiles/tree/master/zsh/.config/zsh
* https://github.com/paulmillr/dotfiles
* https://github.com/marlonrichert/zsh-launchpad
* https://github.com/mashehu/dotfiles/blob/master/zshrc

Some completions setups:

* https://github.com/finnurtorfa/zsh/blob/master/completion.zsh

## Articles

Here are some reads you might find interesting:

* [Declarative macOS Configuration Using nix-darwin And home-manager](https://xyno.space/post/nix-darwin-introduction)
* [Faster and enjoyable ZSH (maybe)](https://htr3n.github.io/2018/07/faster-zsh/)
* [Comparison of ZSH frameworks and plugin managers](https://gist.github.com/laggardkernel/4a4c4986ccdcaf47b91e8227f9868ded)
* [fzf examples (fzf wiki)](https://github.com/junegunn/fzf/wiki/examples)

## License

This project is released under [The Unlicense](LICENSE).
