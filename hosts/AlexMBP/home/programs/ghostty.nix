{
  enable = true;
  package = null; # broken on Darwin

  # This ensures that shell integration works in more scenarios (such as when you switch shells within Ghostty).
  # @see https://ghostty.org/docs/features/shell-integration#manual-shell-integration-setup
  enableZshIntegration = true;

  # https://ghostty.org/docs/config/reference

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

  settings = {
    theme = "Snazzy";
    font-family = "CommitMono Nerd Font";
    font-size = 15;
    # bold-is-bright = true
    # font-thicken = true
    keybind = [
      "cmd+r=reset"
      "cmd+z=text:\x1f"
      "cmd+shift+z=text:\x18\x1f"
      "global:cmd+escape=toggle_quick_terminal"
    ];
    macos-option-as-alt = true;

    # For compatibility:
    # @see https://ghostty.org/docs/help/terminfo
    # term = xterm-256color

    ## Initial Window Size
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
}
