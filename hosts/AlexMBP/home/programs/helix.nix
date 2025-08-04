{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "snazzy";

      editor = {
        mouse = false;
        cursorline = true;
        line-number = "relative";
        statusline = {
          left = ["mode" "spinner" "file-name" "read-only-indicator" "file-modification-indicator"];
          right = ["version-control" "diagnostics" "selections" "register" "position" "position-percentage" "file-encoding"];
        };
        # Recommended default diagnostics settings
        # @see https://docs.helix-editor.com/editor.html#editorinline-diagnostics-section
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning"; # show warnings and errors on the cursorline inline
        };

        auto-save = {
          focus-lost = true;
        };
        insert-final-newline = true;
        trim-trailing-whitespace = true;
        indent-guides = {
          character = "┊";
          skip-levels = 1;
        };
        soft-wrap = {
          enable = true;
        };
      };

      # This include recommended Smart Tab keybinds
      # @ see https://docs.helix-editor.com/editor.html#editorsmart-tab-section
      keys.normal = {
        "tab" = "move_parent_node_end";
        "S-tab" = "move_parent_node_start";
        "Cmd-s" = ":write";
        "Cmd-f" = "page_down";
        "Cmd-b" = "page_up";
        "C-j" = "half_page_down";
        "C-k" = "half_page_up";
        "A-down" = ["extend_to_line_bounds" "delete_selection" "paste_after"];
        "A-up" = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
        "space" = {
          # Print the current line's git blame information to the statusline.
          "B" = ":echo %sh{git blame -L %{cursor_line},+1 %{buffer_name}}";
        };
      };

      keys.insert = {
        "S-tab" = "move_parent_node_start";
        "Cmd-s" = ":write";
        "Cmd-b" = "page_up";
        "Cmd-f" = "page_down";
      };

      keys.select = {
        "tab" = "extend_parent_node_end";
        "S-tab" = "extend_parent_node_start";
        "Cmd-s" = ":write";
        "Cmd-b" = "page_up";
        "Cmd-f" = "page_down";
      };
    };
  };
}
