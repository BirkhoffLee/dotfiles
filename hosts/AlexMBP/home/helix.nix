{ home, ... }:

{
  home.file.".config/helix/config.toml" = {
    text = ''
    theme = "snazzy"

    [editor]
    mouse = false
    auto-save = true
    cursorline = true
    line-number = "relative"

    [editor.statusline]
    left = ["mode", "spinner", "file-absolute-path", "read-only-indicator", "file-modification-indicator"]
    right = ["version-control", "diagnostics", "selections", "register", "position", "position-percentage", "file-encoding"]

    [keys.normal]
    Cmd-s = ":write"
    Cmd-b = "page_up"
    Cmd-f = "page_down"
    C-j = "half_page_down"
    C-k = "half_page_up"

    [keys.insert]
    Cmd-s = ":write"
    Cmd-b = "page_up"
    Cmd-f = "page_down"
    
    [keys.select]
    Cmd-s = ":write"
    Cmd-b = "page_up"
    Cmd-f = "page_down"
   '';
  };
}
