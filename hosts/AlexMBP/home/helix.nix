{ home, ... }:

{
  home.file.".config/helix/config.toml" = {
    text = ''
    theme = "snazzy"

    [editor]
    auto-save = true
    cursorline = true
    line-number = "relative"

    [keys.normal]
    C-j = "half_page_down"
    C-k = "half_page_up"
   '';
  };
}
