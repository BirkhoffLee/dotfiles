{ home, pkgs, ... }:

{
  # https://github.com/jnunyez/home-manager/blob/master/modules/programs/zsh.nix
  programs.zsh = {
    enable = true;

    defaultKeymap = "emacs";

    completionInit = ''
      autoload -Uz compinit
      for dump in ~/.zcompdump(N.mh+24); do
        compinit
      done
      compinit -C
      
      # Completions for git-extras doesn't load automatically
      # due to the lack of #compdef directive. We need to source it manually.
      source ${pkgs.git-extras}/share/zsh/site-functions/_git_extras
    '';

    dirHashes = {
      dl = "$HOME/Downloads";
    };

    history = {
      extended = true;
      expireDuplicatesFirst = true;
      ignorePatterns = [ "rm * " ];
    };

    historySubstringSearch.enable = true;

    # Substituted anywhere on a line
    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
      G = "| grep";
    };

    profileExtra = ''
      export HOMEBREW_PREFIX="/opt/homebrew";

      export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
      export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";

      # Ensure path arrays do not contain duplicates.
      typeset -gU cdpath fpath mailpath path

      # Set the list of directories that Zsh searches for programs.
      path=(
        # $HOME/.rvm/bin
        $HOME/.cargo/bin
        $HOME/go/bin
        $HOME/.local/bin
        # $HOME/Library/Python/*/bin

        $HOMEBREW_PREFIX/{bin,sbin}
        # $HOMEBREW_PREFIX/opt/binutils/bin

        $path
      )

      # Less

      # Set the default Less options.
      # Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
      # Remove -X and -F (exit if the content fits on one screen) to enable it.
      export LESS='-F -g -i -M -R -S -w -X -z-4'

      # Set the Less input preprocessor.
      # Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
      if (( $#commands[(i)lesspipe(|.sh)] )); then
        export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
      fi
    '';

    initExtraFirst = ''
      # Powerlevel10k instant prompt
      if [[ -r "${home.homeDirectory}/.cache/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "${home.homeDirectory}/.cache/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source "${home.homeDirectory}/.shell/p10k.zsh"

      source "${home.homeDirectory}/.shell/options.zsh"

      # Load Zsh's rename utility `zmv`
      autoload -Uz zmv
    '';
    
    initExtraBeforeCompInit = ''
      source "${home.homeDirectory}/.shell/external.zsh"
      source "${home.homeDirectory}/.shell/completions.zsh"
    '';

    initExtra = ''
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

      source "${home.homeDirectory}/.shell/exports.zsh"
      source "${home.homeDirectory}/.shell/aliases.zsh"
      source "${home.homeDirectory}/.shell/functions.zsh"
      source "${home.homeDirectory}/.shell/proxy.zsh"

      # atuin
      eval "$(${pkgs.atuin}/bin/atuin init zsh)"
    '';

    # https://nix-community.github.io/home-manager/options.html#opt-programs.zsh.plugins
    # Get hash with:
    # `nix flake prefetch github:<owner>/<repo>/<rev> --json | jq -r '.hash'`
    plugins = [
      {
        name = "forgit";
        src = pkgs.fetchFromGitHub {
          owner = "wfxr";
          repo = "forgit";
          rev = "23.06.0";
          sha256 = "sha256-HxdTRv4OFf7Bh3FnTB7FMjhizCLH5DbuOHzQq2SYfAE=";
        };
      }
      {
        name = "extract";
        src = pkgs.fetchFromGitHub {
          owner = "birkhofflee";
          repo = "zsh-plugin-extract";
          rev = "1.0.0";
          sha256 = "sha256-KjQoMGqbrjuvfy+Lf3eI32aN09sLpHjh5S/tRTnhAco=";
        };
      }
      {
        name = "you-should-use";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "1f9cb008076d4f2011d5f814dfbcfbece94a99e0";
          sha256 = "sha256-lKs6DhG3x/oRA5AxnRT+odCZFenpS86wPnPqxLonV2E=";
        };
      }
      {
        name = "auto-notify";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-auto-notify";
          rev = "22b2c61ed18514b4002acc626d7f19aa7cb2e34c";
          sha256 = "sha256-x+6UPghRB64nxuhJcBaPQ1kPhsDx3HJv0TLJT5rjZpA=";
        };
      }
      {
        name = "gnu-utility";
        file = "";
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/sorin-ionescu/prezto/8d00c51900dfce3b2bc1e5bd99bd58f238c5668a/modules/gnu-utility/init.zsh";
          sha256 = "sha256-5sx3r71NGT9DokDVwfjlKomYzIgpRwaA2Ky01QRN9sY=";
        };
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "2abe1f2f1cbcb3d3c6b879d849d683de5688111f";
          sha256 = "sha256-zc9Sc1WQIbJ132hw73oiS1ExvxCRHagi6vMkCLd4ZhI=";
        };
      }
    ];
  };
}
