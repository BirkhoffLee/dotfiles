{ lib, pkgs, ... }:
{
  home.sessionVariables = {
    # Automatically attach to an existing session.
    ZELLIJ_AUTO_ATTACH = "true";

    # Exit shell on Zellij exit.
    ZELLIJ_AUTO_EXIT = "true";
  };

  programs.zsh.initContent = lib.mkOrder 155 ''
    # Go into a Zellij session only if we're using Ghostty,
    # so we don't go into Zellij sessions when in VSCode or
    # Terminal.app.
    #
    # In the future let's detect Quick Terminal (Ghostty)
    # and skip this part when there's Quick Terminal.
    #
    # @see https://github.com/ghostty-org/ghostty/discussions/3985
    if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
      eval "$(${pkgs.zellij}/bin/zellij setup --generate-auto-start zsh)"
    fi
  '';

  programs.zellij = {
    enable = true;

    # Shell Integration
    enableBashIntegration = false;
    enableZshIntegration = false; # We do it manually.
  };

  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
        default_tab_template {
            children
            pane size=1 borderless=true {
                plugin location="zjstatus" {
                    format_left   "{mode} #[fg=#89B4FA,bold]{tabs}"
                    // format_center "{tabs}"
                    format_right  "{command_git_branch}{pipe_zjstatus_hints}"
                    format_space  ""

                    // Note: this is necessary or else zjstatus won't render the pipe:
                    pipe_zjstatus_hints_format "{output}"

                    border_enabled  "false"
                    border_char     "─"
                    border_format   "#[fg=#6C7086]{char}"
                    border_position "top"

                    // Setting to true can cause some issues during rapid resizing.
                    // Also this reduces visual discomfort when switching between
                    // tabs.
                    hide_frame_for_single_pane "false"

                    mode_locked      "#[bg=#6e5fb7,fg=#ffffff] "
                    mode_normal      "#[bg=blue] "
                    mode_resize      "#[bg=#ff9969,fg=#7f3513,bold] RESIZE "
                    mode_pane        "#[bg=#9FFBB6,fg=#30563a,bold] PANE "
                    mode_move        "#[bg=#FFD896,fg=#905b00,bold] MOVE "
                    mode_tab         "#[bg=#80BDFF,fg=#0051a8,bold] TAB "
                    mode_scroll      "#[bg=#412da2,fg=#c9c0ff,bold] SCROLL "
                    mode_search      "#[bg=#e28e00,fg=#ffe9c4,bold] SEARCH "
                    mode_entersearch "#[bg=#e28e00,fg=#ffe9c4,bold] ENTER SEARCH "
                    mode_renametab   "#[bg=#0051a8,fg=#80BDFF,bold] RENAME TAB "
                    mode_renamepane  "#[bg=#30563a,fg=#9FFBB6,bold] RENAME PANE "
                    mode_session     "#[bg=#FF87A5,fg=#7d001f,bold] SESSION "

                    tab_normal   "#[fg=#6C7086] {name} "
                    tab_active   "#[fg=#9399B2,bold,italic] {name} "

                    command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                    command_git_branch_format      "#[fg=blue] {stdout} "
                    command_git_branch_interval    "10"
                    command_git_branch_rendermode  "static"
                }
            }
        }
    }
  '';

  xdg.configFile."zellij/config.kdl".text = ''
    keybinds clear-defaults=true {
        normal {
        }
        locked {
            bind "Super g" { SwitchToMode "normal"; }
        }
        pane {
            bind "left" { MoveFocus "left"; }
            bind "down" { MoveFocus "down"; }
            bind "up" { MoveFocus "up"; }
            bind "right" { MoveFocus "right"; }
            bind "c" { SwitchToMode "renamepane"; PaneNameInput 0; }
            bind "d" { NewPane "down"; SwitchToMode "locked"; }
            bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "locked"; }
            bind "f" { ToggleFocusFullscreen; SwitchToMode "locked"; }
            bind "h" { MoveFocus "left"; }
            bind "i" { TogglePanePinned; SwitchToMode "locked"; }
            bind "j" { MoveFocus "down"; }
            bind "k" { MoveFocus "up"; }
            bind "l" { MoveFocus "right"; }
            bind "n" { NewPane; SwitchToMode "locked"; }
            bind "p" { SwitchToMode "normal"; }
            bind "r" { NewPane "right"; SwitchToMode "locked"; }
            bind "w" { ToggleFloatingPanes; SwitchToMode "locked"; }
            bind "x" { CloseFocus; SwitchToMode "locked"; }
            bind "z" { TogglePaneFrames; SwitchToMode "locked"; }
            bind "tab" { SwitchFocus; }
        }
        tab {
            bind "left" { GoToPreviousTab; }
            bind "down" { GoToNextTab; }
            bind "up" { GoToPreviousTab; }
            bind "right" { GoToNextTab; }
            bind "1" { GoToTab 1; SwitchToMode "locked"; }
            bind "2" { GoToTab 2; SwitchToMode "locked"; }
            bind "3" { GoToTab 3; SwitchToMode "locked"; }
            bind "4" { GoToTab 4; SwitchToMode "locked"; }
            bind "5" { GoToTab 5; SwitchToMode "locked"; }
            bind "6" { GoToTab 6; SwitchToMode "locked"; }
            bind "7" { GoToTab 7; SwitchToMode "locked"; }
            bind "8" { GoToTab 8; SwitchToMode "locked"; }
            bind "9" { GoToTab 9; SwitchToMode "locked"; }
            bind "[" { BreakPaneLeft; SwitchToMode "locked"; }
            bind "]" { BreakPaneRight; SwitchToMode "locked"; }
            bind "b" { BreakPane; SwitchToMode "locked"; }
            bind "h" { GoToPreviousTab; }
            bind "j" { GoToNextTab; }
            bind "k" { GoToPreviousTab; }
            bind "l" { GoToNextTab; }
            bind "n" { NewTab; SwitchToMode "locked"; }
            bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
            bind "s" { ToggleActiveSyncTab; SwitchToMode "locked"; }
            bind "t" { SwitchToMode "normal"; }
            bind "x" { CloseTab; SwitchToMode "locked"; }
            bind "tab" { ToggleTab; }
        }
        resize {
            bind "left" { Resize "Increase left"; }
            bind "down" { Resize "Increase down"; }
            bind "up" { Resize "Increase up"; }
            bind "right" { Resize "Increase right"; }
            bind "+" { Resize "Increase"; }
            bind "-" { Resize "Decrease"; }
            bind "=" { Resize "Increase"; }
            bind "H" { Resize "Decrease left"; }
            bind "J" { Resize "Decrease down"; }
            bind "K" { Resize "Decrease up"; }
            bind "L" { Resize "Decrease right"; }
            bind "h" { Resize "Increase left"; }
            bind "j" { Resize "Increase down"; }
            bind "k" { Resize "Increase up"; }
            bind "l" { Resize "Increase right"; }
            bind "r" { SwitchToMode "normal"; }
        }
        move {
            bind "left" { MovePane "left"; }
            bind "down" { MovePane "down"; }
            bind "up" { MovePane "up"; }
            bind "right" { MovePane "right"; }
            bind "h" { MovePane "left"; }
            bind "j" { MovePane "down"; }
            bind "k" { MovePane "up"; }
            bind "l" { MovePane "right"; }
            bind "m" { SwitchToMode "normal"; }
            bind "n" { MovePane; }
            bind "p" { MovePaneBackwards; }
            bind "tab" { MovePane; }
        }
        scroll {
            bind "Alt left" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
            bind "Alt down" { MoveFocus "down"; SwitchToMode "locked"; }
            bind "Alt up" { MoveFocus "up"; SwitchToMode "locked"; }
            bind "Alt right" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
            bind "e" { EditScrollback; SwitchToMode "locked"; }
            bind "f" { SwitchToMode "entersearch"; SearchInput 0; }
            bind "Alt h" { MoveFocusOrTab "left"; SwitchToMode "locked"; }
            bind "Alt j" { MoveFocus "down"; SwitchToMode "locked"; }
            bind "Alt k" { MoveFocus "up"; SwitchToMode "locked"; }
            bind "Alt l" { MoveFocusOrTab "right"; SwitchToMode "locked"; }
            bind "s" { SwitchToMode "normal"; }
        }
        search {
            bind "c" { SearchToggleOption "CaseSensitivity"; }
            bind "n" { Search "down"; }
            bind "o" { SearchToggleOption "WholeWord"; }
            bind "p" { Search "up"; }
            bind "w" { SearchToggleOption "Wrap"; }
        }
        session {
            bind "a" {
                LaunchOrFocusPlugin "zellij:about" {
                    floating true
                    move_to_focused_tab true
                }
                SwitchToMode "locked"
            }
            bind "c" {
                LaunchOrFocusPlugin "configuration" {
                    floating true
                    move_to_focused_tab true
                }
                SwitchToMode "locked"
            }
            bind "d" { Detach; }
            bind "o" { SwitchToMode "normal"; }
            bind "p" {
                LaunchOrFocusPlugin "plugin-manager" {
                    floating true
                    move_to_focused_tab true
                }
                SwitchToMode "locked"
            }
            bind "w" {
                LaunchOrFocusPlugin "session-manager" {
                    floating true
                    move_to_focused_tab true
                }
                SwitchToMode "locked"
            }
        }
        shared_among "normal" "locked" {
            bind "Super Shift Enter" { ToggleFocusFullscreen; }

            // bind "Super Shift left" { MoveFocusOrTab "left"; }
            // bind "Super Shift down" { MoveFocus "down"; }
            // bind "Super Shift up" { MoveFocus "up"; }
            // bind "Super Shift right" { MoveFocusOrTab "right"; }

            bind "Super Shift h" { MoveFocusOrTab "left"; }
            bind "Super Shift j" { MoveFocus "down"; }
            bind "Super Shift k" { MoveFocus "up"; }
            bind "Super Shift l" { MoveFocusOrTab "right"; }

            bind "Super +" { Resize "Increase"; }
            bind "Super -" { Resize "Decrease"; }
            bind "Super =" { Resize "Increase"; }

            bind "Alt [" { PreviousSwapLayout; }
            bind "Alt ]" { NextSwapLayout; }

            bind "Super f" { ToggleFloatingPanes; }

            // bind "Super i" { MoveTab "left"; }
            // bind "Super o" { MoveTab "right"; }

            bind "Super t" { NewTab; }
            bind "Super d" { NewPane; }
            bind "Super Shift d" { NewPane "Down"; }
        }
        shared_except "locked" "renametab" "renamepane" {
            bind "Super g" { SwitchToMode "locked"; }
            bind "Ctrl q" { Quit; }
        }
        shared_except "locked" "entersearch" {
            bind "enter" { SwitchToMode "locked"; }
        }
        shared_except "locked" "entersearch" "renametab" "renamepane" {
            bind "esc" { SwitchToMode "locked"; }
        }
        shared_except "locked" "entersearch" "renametab" "renamepane" "move" {
            bind "m" { SwitchToMode "move"; }
        }
        shared_except "locked" "entersearch" "search" "renametab" "renamepane" "session" {
            bind "o" { SwitchToMode "session"; }
        }
        shared_except "locked" "tab" "entersearch" "renametab" "renamepane" {
            bind "t" { SwitchToMode "tab"; }
        }
        shared_except "locked" "tab" "scroll" "entersearch" "renametab" "renamepane" {
            bind "s" { SwitchToMode "scroll"; }
        }
        shared_among "normal" "resize" "tab" "scroll" "prompt" "tmux" {
            bind "p" { SwitchToMode "pane"; }
        }
        shared_except "locked" "resize" "pane" "tab" "entersearch" "renametab" "renamepane" {
            bind "r" { SwitchToMode "resize"; }
        }
        shared_among "scroll" "search" {
            bind "PageDown" { PageScrollDown; }
            bind "PageUp" { PageScrollUp; }
            bind "left" { PageScrollUp; }
            bind "down" { ScrollDown; }
            bind "up" { ScrollUp; }
            bind "right" { PageScrollDown; }
            bind "Ctrl b" { PageScrollUp; }
            bind "Ctrl c" { ScrollToBottom; SwitchToMode "locked"; }
            bind "d" { HalfPageScrollDown; }
            bind "Ctrl f" { PageScrollDown; }
            bind "h" { PageScrollUp; }
            bind "j" { ScrollDown; }
            bind "k" { ScrollUp; }
            bind "l" { PageScrollDown; }
            bind "u" { HalfPageScrollUp; }
        }
        entersearch {
            bind "Ctrl c" { SwitchToMode "scroll"; }
            bind "esc" { SwitchToMode "scroll"; }
            bind "enter" { SwitchToMode "search"; }
        }
        renametab {
            bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
        }
        shared_among "renametab" "renamepane" {
            bind "Ctrl c" { SwitchToMode "locked"; }
        }
        renamepane {
            bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
        }
    }

    // Plugin aliases - can be used to change the implementation of Zellij
    // changing these requires a restart to take effect
    plugins {
        about location="zellij:about"
        compact-bar location="zellij:compact-bar"
        configuration location="zellij:configuration"
        filepicker location="zellij:strider" {
            cwd "/"
        }
        plugin-manager location="zellij:plugin-manager"
        session-manager location="zellij:session-manager"
        status-bar location="zellij:status-bar"
        strider location="zellij:strider"
        tab-bar location="zellij:tab-bar"
        welcome-screen location="zellij:session-manager" {
            welcome_screen true
        }
        zjstatus location="file:${pkgs.zjstatus}/bin/zjstatus.wasm"
        zjstatus-hints location="file:${pkgs.zjstatus-hints}/bin/zjstatus-hints.wasm" {
            max_length "0"
            overflow_str ""
            pipe_name "zjstatus_hints"
        }
    }

    // Plugins to load in the background when a new session starts
    // eg. "file:/path/to/my-plugin.wasm"
    // eg. "https://example.com/my-plugin.wasm"
    load_plugins {
        zjstatus-hints
    }

    // Use a simplified tab without special fonts (arrow glyphs)
    // Options:
    //   - true
    //   - false (Default)
    //
    // simplified_ui true

    // Choose the theme that is specified in the themes section.
    // Default: default
    //
    // theme "dracula"

    // Choose the base input mode of zellij.
    // Default: normal
    //
    default_mode "locked"

    // Choose the path to the default shell that zellij will use for opening new panes
    // Default: $SHELL
    //
    // default_shell "fish"

    // Choose the path to override cwd that zellij will use for opening new panes
    //
    // default_cwd "/tmp"

    // The name of the default layout to load on startup
    // Default: "default"
    //
    // default_layout "compact"

    // The folder in which Zellij will look for layouts
    // (Requires restart)
    //
    // layout_dir "/tmp"

    // The folder in which Zellij will look for themes
    // (Requires restart)
    //
    // theme_dir "/tmp"

    // Toggle enabling the mouse mode.
    // On certain configurations, or terminals this could
    // potentially interfere with copying text.
    // Options:
    //   - true (default)
    //   - false
    //
    // mouse_mode false

    // Toggle having pane frames around the panes
    // Options:
    //   - true (default, enabled)
    //   - false
    //
    // pane_frames false

    // When attaching to an existing session with other users,
    // should the session be mirrored (true)
    // or should each user have their own cursor (false)
    // (Requires restart)
    // Default: false
    //
    // mirror_session true

    // Choose what to do when zellij receives SIGTERM, SIGINT, SIGQUIT or SIGHUP
    // eg. when terminal window with an active zellij session is closed
    // (Requires restart)
    // Options:
    //   - detach (Default)
    //   - quit
    //
    // on_force_close "quit"

    // Configure the scroll back buffer size
    // This is the number of lines zellij stores for each pane in the scroll back
    // buffer. Excess number of lines are discarded in a FIFO fashion.
    // (Requires restart)
    // Valid values: positive integers
    // Default value: 10000
    //
    // scroll_buffer_size 10000

    // Provide a command to execute when copying text. The text will be piped to
    // the stdin of the program to perform the copy. This can be used with
    // terminal emulators which do not support the OSC 52 ANSI control sequence
    // that will be used by default if this option is not set.
    // Examples:
    //
    // copy_command "xclip -selection clipboard" // x11
    // copy_command "wl-copy"                    // wayland
    // copy_command "pbcopy"                     // osx
    //
    // copy_command "pbcopy"

    // Choose the destination for copied text
    // Allows using the primary selection buffer (on x11/wayland) instead of the system clipboard.
    // Does not apply when using copy_command.
    // Options:
    //   - system (default)
    //   - primary
    //
    // copy_clipboard "primary"

    // Enable automatic copying (and clearing) of selection when releasing mouse
    // Default: true
    //
    // copy_on_select true

    // Path to the default editor to use to edit pane scrollbuffer
    // Default: $EDITOR or $VISUAL
    // scrollback_editor "/usr/bin/vim"

    // A fixed name to always give the Zellij session.
    // Consider also setting `attach_to_session true,`
    // otherwise this will error if such a session exists.
    // Default: <RANDOM>
    //
    // session_name "My singleton session"

    // When `session_name` is provided, attaches to that session
    // if it is already running or creates it otherwise.
    // Default: false
    //
    // attach_to_session true

    // Toggle between having Zellij lay out panes according to a predefined set of layouts whenever possible
    // Options:
    //   - true (default)
    //   - false
    //
    // auto_layout false

    // Whether sessions should be serialized to the cache folder (including their tabs/panes, cwds and running commands) so that they can later be resurrected
    // Options:
    //   - true (default)
    //   - false
    //
    // session_serialization false

    // Whether pane viewports are serialized along with the session, default is false
    // Options:
    //   - true
    //   - false (default)
    //
    // serialize_pane_viewport false

    // Scrollback lines to serialize along with the pane viewport when serializing sessions, 0
    // defaults to the scrollback size. If this number is higher than the scrollback size, it will
    // also default to the scrollback size. This does nothing if `serialize_pane_viewport` is not true.
    //
    // scrollback_lines_to_serialize 10000

    // Enable or disable the rendering of styled and colored underlines (undercurl).
    // May need to be disabled for certain unsupported terminals
    // (Requires restart)
    // Default: true
    //
    // styled_underlines false

    // How often in seconds sessions are serialized
    //
    // serialization_interval 10000

    // Enable or disable writing of session metadata to disk (if disabled, other sessions might not know
    // metadata info on this session)
    // (Requires restart)
    // Default: false
    //
    // disable_session_metadata false

    // Enable or disable support for the enhanced Kitty Keyboard Protocol (the host terminal must also support it)
    // (Requires restart)
    // Default: true (if the host terminal supports it)
    //
    // support_kitty_keyboard_protocol false

    // Whether to stack panes when resizing beyond a certain size
    // Default: true
    //
    // stacked_resize false

    // Whether to show tips on startup
    // Default: true
    //
    show_startup_tips false

    // Whether to show release notes on first version run
    // Default: true
    //
    // show_release_notes false
  '';

  # Reconfigure Swap Layouts since we are overriding the layout configuration
  # due to the usage of zjstatus.
  #
  # The following is from `zellij setup --dump-swap-layout default`
  xdg.configFile."zellij/layouts/default.swap.kdl".text = ''
    // tab_template name="ui" {
    //     pane size=1 borderless=true {
    //         plugin location="tab-bar"
    //     }
    //     children
    //     pane size=1 borderless=true {
    //         plugin location="status-bar"
    //     }
    // }

    swap_tiled_layout name="vertical" {
        tab max_panes=5 {
            pane split_direction="vertical" {
                pane
                pane { children; }
            }
        }
        tab max_panes=8 {
            pane split_direction="vertical" {
                pane { children; }
                pane { pane; pane; pane; pane; }
            }
        }
        tab max_panes=12 {
            pane split_direction="vertical" {
                pane { children; }
                pane { pane; pane; pane; pane; }
                pane { pane; pane; pane; pane; }
            }
        }
    }

    swap_tiled_layout name="horizontal" {
        tab max_panes=4 {
            pane
            pane
        }
        tab max_panes=8 {
            pane {
                pane split_direction="vertical" { children; }
                pane split_direction="vertical" { pane; pane; pane; pane; }
            }
        }
        tab max_panes=12 {
            pane {
                pane split_direction="vertical" { children; }
                pane split_direction="vertical" { pane; pane; pane; pane; }
                pane split_direction="vertical" { pane; pane; pane; pane; }
            }
        }
    }

    swap_tiled_layout name="stacked" {
        tab min_panes=5 {
            pane split_direction="vertical" {
                pane
                pane stacked=true { children; }
            }
        }
    }

    swap_floating_layout name="staggered" {
        floating_panes
    }

    swap_floating_layout name="enlarged" {
        floating_panes max_panes=10 {
            pane { x "5%"; y 1; width "90%"; height "90%"; }
            pane { x "5%"; y 2; width "90%"; height "90%"; }
            pane { x "5%"; y 3; width "90%"; height "90%"; }
            pane { x "5%"; y 4; width "90%"; height "90%"; }
            pane { x "5%"; y 5; width "90%"; height "90%"; }
            pane { x "5%"; y 6; width "90%"; height "90%"; }
            pane { x "5%"; y 7; width "90%"; height "90%"; }
            pane { x "5%"; y 8; width "90%"; height "90%"; }
            pane { x "5%"; y 9; width "90%"; height "90%"; }
            pane { x 10; y 10; width "90%"; height "90%"; }
        }
    }

    swap_floating_layout name="spread" {
        floating_panes max_panes=1 {
            pane {y "50%"; x "50%"; }
        }
        floating_panes max_panes=2 {
            pane { x "1%"; y "25%"; width "45%"; }
            pane { x "50%"; y "25%"; width "45%"; }
        }
        floating_panes max_panes=3 {
            pane { y "55%"; width "45%"; height "45%"; }
            pane { x "1%"; y "1%"; width "45%"; }
            pane { x "50%"; y "1%"; width "45%"; }
        }
        floating_panes max_panes=4 {
            pane { x "1%"; y "55%"; width "45%"; height "45%"; }
            pane { x "50%"; y "55%"; width "45%"; height "45%"; }
            pane { x "1%"; y "1%"; width "45%"; height "45%"; }
            pane { x "50%"; y "1%"; width "45%"; height "45%"; }
        }
    }
  '';
}
