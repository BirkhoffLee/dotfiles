{ lib, ... }:
{
  # This is an attempt to fix a rare bug where after we go into a new
  # zellij session, the shell is completely broken with the message
  # `tput: No value for $TERM and no -T specified`
  #
  # This ensures that shell integration works in more scenarios (such as when you switch shells within Ghostty).
  # @see https://ghostty.org/docs/features/shell-integration#manual-shell-integration-setup
  programs.zsh.initContent = lib.mkOrder 150 ''
    if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
      source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
    fi
  '';

  programs.ghostty = {
    enable = true;
    package = null; # broken on Darwin

    # Clear the default keybinds so we have super
    # key (i.e. Command) key available to terminal
    # programs.
    clearDefaultKeybinds = true;

    # We do this ourselves because this puts the init code
    # too late (we need it to be at top of .zshrc)
    # but this fix is largely a guess.
    enableZshIntegration = false;

    # https://ghostty.org/docs/config/reference

    settings = {
      # Some other themes to choose from:
      # theme = Horizon
      # theme = Rapture
      # theme = Snazzy

      # Lighter Themes
      # theme = Sublette
      # theme = xcodedark

      # Darker Themes
      # theme = NightLion v2
      # theme = Peppermint

      theme = "Snazzy";
      font-family = "CommitMono Nerd Font";
      font-size = 15;
      # bold-is-bright = true
      # font-thicken = true

      # For compatibility:
      # @see https://ghostty.org/docs/help/terminfo
      # term = xterm-256color

      macos-option-as-alt = true;
      keybind = [
        "super+q=quit"
        "super+n=new_window"
        "super+shift+comma=reload_config"
        "super+c=copy_to_clipboard"
        "super+v=paste_from_clipboard"
        # "super+backspace=text:\\x15"
        # "super+right=etext:\\x05"
        # "super+left=etext:\\x01"
        "super+z=text:\\x1f"
        "super+shift+z=text:\\x18\\x1f"
        # "global:super+escape=toggle_quick_terminal"
      ];

      ## Initial Window Size
      maximize = true;
      window-height = 35;
      window-width = 98;
      ## End of Initial Window Size

      ## Window Padding
      # window-padding-balance = true;
      # window-padding-color = "extend";
      # window-padding-x = "2";
      window-padding-y = "2,0";
      ## End of Window Padding

      ## Cursor & Shell Integration
      cursor-style = "block";
      cursor-style-blink = true;
      shell-integration = "zsh";
      shell-integration-features = "no-cursor,sudo,title";
      ## End of Cursor & Shell Integration

      ## Quick Terminal
      quick-terminal-animation-duration = 0;
      ## End of Quick Terminal
    };
  };
}
