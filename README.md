# dotfiles

My cross-platform NixOS / [nix-darwin](https://github.com/LnL7/nix-darwin) configuration. Works on Apple Silicon.

## Overview

* [Nix](https://nixos.org/) enables reproducible builds.
* On macOS, [nix-darwin](https://github.com/LnL7/nix-darwin) sets up the system configuration.
* [home-manager](https://github.com/nix-community/home-manager) manages the user environment (mostly), including Homebrew packages.

## Features

* [Ghostty](https://ghostty.org/) as the terminal emulator
* On macOS, [it sets](home/libs/wallpaper.nix) a beautiful wallpaper from [Raycast](https://www.raycast.com/wallpapers)
* Shell configuration:
  * Zsh with a customized [Pure prompt](https://starship.rs/presets/pure-preset#pure-preset) using [Starship](https://starship.rs)
  * Terminal Multiplexer: [Zellij](https://zellij.dev/) Unlock-First (non-colliding) preset with [minor customization](home/programs/zellij.nix)
  * A number of handy [aliases](home/programs/zsh.nix) and [functions](home/files/shell/functions.zsh)
  * [Automatically propagated](home/files/shell/proxy.zsh) shell proxy settings
  * Some third-party shell integrations:
    * [Atuin](https://github.com/ellie/atuin) for interactive shell history search
    * [fzf shell integration](home/programs/fzf.nix)
      * CTRL-T - Paste the path of selected files and directories onto the command-line
      * ALT-C - cd into the selected directory
    * [fzf-tab](https://github.com/Aloxaf/fzf-tab) for fuzzy-searching zsh completion results, including a [smart preview window](home/files/shell/fzf.zsh)
    * [lazygit](https://github.com/jesseduffield/lazygit) ([a quick starter video](https://www.youtube.com/watch?v=CPLdltN7wgE))
    * [nix-index-database](https://github.com/nix-community/nix-index-database) to locate the Nix package of a command, and [comma](https://github.com/nix-community/comma) to run the command without installing it.

## Usage

<details>

<summary>Installation instructions on a new macOS machine without Nix installed</summary>

```shell
xcode-select --install

# Clone the dotfiles
mkdir $HOME/.config
git clone https://github.com/birkhofflee/dotfiles $HOME/.config/dotfiles

# Install nix with Determinate Systems installer
# Choose "no" to use the upstream nix instead of their own one
# @see https://determinate.systems/blog/installer-dropping-upstream/
# @see https://github.com/NixOS/experimental-nix-installer
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm --prefer-upstream-nix

# Source the nix daemon so that the nix command is available immediately
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Build the dotfiles
nix build "$HOME/.config/dotfiles#darwinConfigurations.AlexMBP.system" --extra-experimental-features "nix-command flakes"

# Apply the dotfiles
sudo ./result/sw/bin/darwin-rebuild switch --flake "$HOME/.config/dotfiles#AlexMBP"
```

</details>

Commonly used commands are already baked into [justfile](justfile):

```shell
# Switch darwin configuration
just switch

# Updates all flake inputs
just update

# Updates one flake input
just update-input <flake-input-name>

# For more, run `just` to get all receipes.
```

<details>

<summary>Repairing the setup after a major macOS update</summary>

> [!IMPORTANT]
> The following steps were applicable to installations with upstream Nix installations.
> It is unknown whether they are needed to follow for a Determinate
> Systems installation.

1. Upgrade Xcode CLI tools
2. Uninstall nix: https://nix.dev/manual/nix/2.18/installation/uninstall.html#macos
3. A system restart may be required
4. Review [CHANGELOG](https://github.com/LnL7/nix-darwin/blob/master/CHANGELOG) of nix-darwin

```shell
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

nix build "$HOME/.config/dotfiles#darwinConfigurations.AlexMBP.system" --extra-experimental-features "nix-command flakes"

sudo ./result/sw/bin/darwin-rebuild switch --flake "$HOME/.config/dotfiles#AlexMBP"
```

</details>

## Other Notes

* Development Environments [should be managed using nix-shell](https://joshblais.com/blog/nixos-is-the-endgame-of-distrohopping/#development-environments).
* [Supercharge](https://sindresorhus.com/supercharge) has to be downloaded manually due to licensing constraints.
* While I'd like Nix to handle every app on my Mac, most GUI apps are better managed by Homebrew due to the conflicting nature of Nix and the self-updating capabilities of those apps.

## TODOs

* File completion
  * List directories first like [this](https://github.com/Aloxaf/fzf-tab/pull/518)
  * When completing with fzf-tab, there's the slash in file names which i dont like
* [Home Manager: dotfiles management](https://gvolpe.com/blog/home-manager-dotfiles-management/)
* env check https://github.com/marlonrichert/zsh-launchpad/blob/main/.config/zsh/rc.d/04-env.zsh
* Use [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) to ensure consistency across different platforms

Some other dotfiles worth looking into:

* https://github.com/malob/nixpkgs
* https://github.com/ahmedelgabri/dotfiles
* https://github.com/kornicameister/dotfiles/
* https://github.com/Aloxaf/dotfiles/tree/master/zsh/.config/zsh
* https://github.com/paulmillr/dotfiles

Some completions setups:

* https://github.com/mashehu/dotfiles/blob/236af8d7d71989f9755a6ea29ee66e33cbbce1f8/zshrc#L89-L105
* https://github.com/finnurtorfa/zsh/blob/master/completion.zsh

## Articles

Here are some reads you might find interesting:

* [Faster and enjoyable ZSH (maybe)](https://htr3n.github.io/2018/07/faster-zsh/)
* [Comparison of ZSH frameworks and plugin managers](https://gist.github.com/laggardkernel/4a4c4986ccdcaf47b91e8227f9868ded)
* [fzf examples (fzf wiki)](https://github.com/junegunn/fzf/wiki/examples)

## License

This project is released under the [MIT License](LICENSE).
