{
  enable = true;
  defaultEditor = true;
  settings = {
    theme = "snazzy";
  
    editor = {
      mouse = false;
      auto-save = true;
      cursorline = true;
      line-number = "relative";
      statusline = {
        left = ["mode" "spinner" "file-name" "read-only-indicator" "file-modification-indicator"];
        right = ["version-control" "diagnostics" "selections" "register" "position" "position-percentage" "file-encoding"];
      };
    };
  
    keys.normal = {
      "Cmd-s" = ":write";
      "Cmd-b" = "page_up";
      "Cmd-f" = "page_down";
      "C-j" = "half_page_down";
      "C-k" = "half_page_up";
      "A-down" = ["extend_to_line_bounds" "delete_selection" "paste_after"];
      "A-up" = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
    };
  
    keys.insert = {
      "Cmd-s" = ":write";
      "Cmd-b" = "page_up";
      "Cmd-f" = "page_down";
    };
  
    keys.select = {
      "Cmd-s" = ":write";
      "Cmd-b" = "page_up";
      "Cmd-f" = "page_down";
    };
  };
}
