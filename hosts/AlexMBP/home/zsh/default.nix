{ home, pkgs, lib, ... }:

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

    shellAliases =
      let
        macAliases = lib.mkIf (pkgs.stdenv.isDarwin) {
          mtr = "sudo mtr";
          htop = "sudo htop";
          pbc = "pbcopy"; # Copy to clipboard
          pbp = "pbpaste"; # Paste from clipboard
          yoink = "open -a Yoink";
          a = "terminal-notifier -sound default -message 'Command complete' -title 'Shell'";
          afk = "/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession -suspend";
          pubkey = "cat ~/.ssh/id_ed25519.pub | pbcopy | echo '=> Public key (ed25519) copied to pasteboard.'";
          sshkey = "pubkey";
          brewery = "brew update && brew upgrade && brew cleanup";
          files-to-prompt = "uvx files-to-prompt";
          o = "open"; # Open with default app
        };
        generalAliases = {
          # Disable correction
          ack = "nocorrect ack";
          cd = "nocorrect cd";
          cp = "nocorrect cp -i"; # Safe ops
          gcc = "nocorrect gcc";
          grep = "nocorrect grep --color=auto"; # use color
          ln = "nocorrect ln -i"; # Safe ops
          man = "nocorrect man";
          mkdir = "nocorrect mkdir";
          mv = "nocorrect mv -i"; # Safe ops
          rm = "nocorrect rm -i"; # Safe ops

          # Disable globbing
          curl = "noglob curl";
          wget = "noglob wget";
          fc = "noglob fc";
          find = "noglob find";
          history = "noglob history";
          locate = "noglob locate";
          rake = "noglob rake";
          rsync = "noglob rsync";
          scp = "noglob scp";
          sftp = "noglob sftp";

          # List files
          sl = "ls";
          l = "ls";
          ls = "eza -1 --group-directories-first --icons --hyperlink --no-quotes";
          ll = "ls -l";
          la = "ls -la";
          tree = "ls --tree --level 3";
          lr = "ll -R";
          lx = "ll -XB";
          lc = "lt -c";
          lu = "lt -u";

          # Directory stack
          po = "popd";
          pu = "pushd";

          # Shell
          sa = "alias | grep -i"; # Search shell aliases
          history-stat = "history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head"; # Lists the ten most used commands
          type = "type -a"; # Show all definitions of a command
          
          # Nix
          nix-update-dotfiles = "nix flake update --flake \"$HOME/.config/nix\" && sudo darwin-rebuild switch --flake \"$HOME/.config/nix#AlexMBP\"";
          nix-info = "nix-shell -p nix-info --run \"nix-info -m\"";
          nix-gc = "sudo nix-collect-garbage -d && nix-store --optimise";
          
          # LLM
          llm = "OPENAI_API_KEY=$(op read 'op://Private/OpenAI API Key/api key') uvx llm";
          llmf = "OPENAI_API_KEY=$(op read 'op://Private/OpenAI API Key/api key') uvx llm --no-stream";
          # uvx --with llm-anthropic llm -m claude-3.5-haiku 'fun facts about skunks'
          chat = "llm chat -m chatgpt";

          # Text processing
          p = "$PAGER"; # Pager
          j = "jq -C | less -R"; # jq with pager
          diffu = "diff --unified"; # diff

          # Utilities
          http-serve = "python3 -m http.server";
          urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))'";
          urlencode = "python3 -c 'import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))'";
          
          # Utilities
          clear_history = "> ~/.zsh_history ; exec $SHELL -l";
          help = "cht.sh";
          du = "ncdu --color dark -rr -x --exclude .git --exclude node_modules";
          gist = "gh gist create";
          
          # Network
          get = "curl --continue-at - --location --progress-bar --remote-name --remote-time";
          dig = "kdig";
          q = "ssh -v";
          testdown = "http https://mensura.cdn-apple.com/api/v1/gm/config | jq -r .urls.large_https_download_url | xargs wget -O /dev/null"; # Test download speed from Apple CDN

          # Docker
          d = "docker";
          dp = "docker ps -a";
          dr = "docker rm";
          di = "docker inspect";
          dvl = "docker volume ls";
          dvi = "docker volume inspect";
          dvp = "docker volume inspect --format '{{ .Mountpoint }}'";
          dc = "docker compose";
          dclf = "docker compose logs -f";
          dcu = "docker compose up -d";
          dcr = "docker compose restart";
          dcub = "docker compose up -d --build";
          dcb = "docker compose build";
          dcd = "docker compose down";
        };
      in
        lib.mkMerge [
          generalAliases
          macAliases
        ];

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

    # Content to be added to `.zshrc`.
    #
    # To specify the order, use `lib.mkOrder`. Common order values:
    # - 500 (mkBefore): Early initialization (replaces initExtraFirst)
    # - 550: Before completion initialization (replaces initExtraBeforeCompInit)
    # - 1000 (default): General configuration (replaces initExtra)
    # - 1500 (mkAfter): Last to run configuration
    initContent = let
      # This runs instantly
      zshConfigEarlyInit = lib.mkBefore ''
        # Ghostty shell integration
        # This ensures that shell integration works in more scenarios (such as when you switch shells within Ghostty).
        # @see https://ghostty.org/docs/features/shell-integration#manual-shell-integration-setup
        if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
            builtin source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
        fi

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

      # This runs before compinit (completion initialization)
      zshConfigBeforeCompInit = lib.mkOrder 550 ''
        source "${home.homeDirectory}/.shell/external.zsh"
        source "${home.homeDirectory}/.shell/completions.zsh"
      '';

      # General configuration
      zshConfig = ''
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

        source "${home.homeDirectory}/.shell/exports.zsh"
        source "${home.homeDirectory}/.shell/functions.zsh"
        source "${home.homeDirectory}/.shell/proxy.zsh"

        # atuin
        eval "$(${pkgs.atuin}/bin/atuin init zsh)"
      '';
    in
      lib.mkMerge [ zshConfigEarlyInit zshConfigBeforeCompInit zshConfig ];

    # https://nix-community.github.io/home-manager/options.html#opt-programs.zsh.plugins
    # Get hash with:
    # `nix flake prefetch github:<owner>/<repo>/<rev> --json | jq -r '.hash'`
    # or just leave empty and apply, it will tell you the hash
    plugins = [
      {
        name = "forgit";
        src = pkgs.fetchFromGitHub {
          # https://github.com/wfxr/forgit
          owner = "wfxr";
          repo = "forgit";
          rev = "25.06.0";
          sha256 = "sha256-D1we3pOPXNsK8KgEaRBAmD5eH1i2ud4zX1GwYbOyZvY=";
        };
      }
      {
        name = "extract";
        src = pkgs.fetchFromGitHub {
          # https://github.com/birkhofflee/zsh-plugin-extract
          owner = "birkhofflee";
          repo = "zsh-plugin-extract";
          rev = "1.0.0";
          sha256 = "sha256-KjQoMGqbrjuvfy+Lf3eI32aN09sLpHjh5S/tRTnhAco=";
        };
      }
      {
        name = "you-should-use";
        src = pkgs.fetchFromGitHub {
          # https://github.com/MichaelAquilina/zsh-you-should-use
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "030ac861f5f1536747407ac7baf208fd3990602a";
          sha256 = "sha256-iPVB1LxbE/eBsZy7U1Zo7/uMtqko3edL4LsM3Yp+pz8=";
        };
      }
      {
        name = "auto-notify";
        src = pkgs.fetchFromGitHub {
          # https://github.com/MichaelAquilina/zsh-auto-notify
          owner = "MichaelAquilina";
          repo = "zsh-auto-notify";
          rev = "b51c934d88868e56c1d55d0a2a36d559f21cb2ee";
          sha256 = "sha256-s3TBAsXOpmiXMAQkbaS5de0t0hNC1EzUUb0ZG+p9keE=";
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
          # https://github.com/Aloxaf/fzf-tab
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "2abe1f2f1cbcb3d3c6b879d849d683de5688111f";
          sha256 = "sha256-zc9Sc1WQIbJ132hw73oiS1ExvxCRHagi6vMkCLd4ZhI=";
        };
      }
    ];
  };
}
