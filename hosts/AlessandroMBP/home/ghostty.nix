{ home, ... }:

{
  home.file.".config/ghostty/config" = {
    text = ''
      # https://ghostty.org/docs/config/reference

      font-family = Menlo
      font-size = 15
      # bold-is-bright = true
      # font-thicken = true
      keybind = cmd+r=reset
      keybind = cmd+z=text:\x1f
      keybind = cmd+shift+z=text:\x18\x1f

      # For compatibility:
      term = xterm-256color

      ## Initial Window Size
      window-height = 35
      window-width = 110
      ## End of Initial Window Size

      ## Cursor & Shell Integration
      cursor-style = block
      cursor-style-blink = true
      shell-integration = zsh
      shell-integration-features = no-cursor,sudo,title
      ## End of Cursor & Shell Integration

      ## Quick Terminal
      keybind = global:cmd+escape=toggle_quick_terminal
      quick-terminal-animation-duration = 0
      ## End of Quick Terminal

      ## Color Theme
      # theme = Horizon
      # theme = Rapture
      # theme = Snazzy

      # Lighter Themes
      # theme = Sublette
      # theme = xcodedark

      # Darker Themes
      # theme = NightLion v2
      # theme = Peppermint

      # Snazzy:
      palette = 0=#000000
      palette = 1=#fc4346
      palette = 2=#50fb7c
      palette = 3=#f0fb8c
      palette = 4=#49baff
      palette = 5=#fc4cb4
      palette = 6=#8be9fe
      palette = 7=#ededec
      palette = 8=#555555
      palette = 9=#fc4346
      palette = 10=#50fb7c
      palette = 11=#f0fb8c
      palette = 12=#49baff
      palette = 13=#fc4cb4
      palette = 14=#8be9fe
      palette = 15=#ededec
      background = #1e1f29
      foreground = #ebece6
      cursor-color = #e4e4e4
      cursor-text = #f6f6f6
      selection-background = #81aec6
      selection-foreground = #000000
      ## End of Color Theme
    '';
  };
}
