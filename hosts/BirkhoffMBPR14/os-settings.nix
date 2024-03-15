{ hostname, ... }:

{
  # The trick to get those configuration keys:
  # defaults read > before
  # defaults read > after
  # diff before after

  # Hostname
  networking.computerName = "${hostname}";
  networking.hostName = "${hostname}";
  system.defaults.smb.NetBIOSName = "${hostname}";

  system.defaults = {
    LaunchServices = {
      # Disable quarantine for downloaded applications.
      LSQuarantine = false;
    };

    trackpad = {
      # Enable tap to click
      Clicking = true;

      # Enable three finger drag
      TrackpadThreeFingerDrag = true;
    };

    finder = {
      # Always show hidden files
      "AppleShowAllFiles" = true;

      # Always show file extensions
      "AppleShowAllExtensions" = true;

      # Show status bar at bottom of finder windows with item/disk space stats
      "ShowStatusBar" = true;

      # Show path breadcrumbs in finder windows
      "ShowPathbar" = true;

      # Show the full POSIX filepath in the window title
      "_FXShowPosixPathInTitle" = true;

      # When performing a search, search the current folder by default
      "FXDefaultSearchScope" = "SCcf";

      # Disable the warning when changing a file extension
      "FXEnableExtensionChangeWarning" = false;

      # Use list view in all Finder windows by default
      "FXPreferredViewStyle" = "Nlsv";
    };

    screencapture = {
      # Save screenshots to the desktop
      "location" = "~/Desktop";

      # Save screenshots in PNG format
      "type" = "png";
    };

    dock = {
      # Do not show recent apps
      "show-recents" = false;

      # Do not automatically rearrange spaces based on most recent use
      "mru-spaces" = false;

      # Autohide immediately
      "autohide-delay" = 0.0;

      # Speed of the animation when hiding/showing the Dock
      "autohide-time-modifier" = 0.0;

      # Automatically hide and show the dock
      "autohide" = true;

      # Position of the dock on screen
      "orientation" = "left";

      # Size of the icons in the dock (default 64)
      "tilesize" = 40;
    };

    NSGlobalDomain = {
      # Automatically switch between light and dark mode
      AppleInterfaceStyleSwitchesAutomatically = true;

      # Trackpad: enable tap to click
      "com.apple.mouse.tapBehavior" = 1;

      # Expand save panel by default
      "NSNavPanelExpandedStateForSaveMode" = true;
      "NSNavPanelExpandedStateForSaveMode2" = true;

      # Expand print panel by default
      "PMPrintingExpandedStateForPrint" = true;
      "PMPrintingExpandedStateForPrint2" = true;

      # Finder: show all filename extensions
      "AppleShowAllExtensions" = true;

      # Save to disk (not to iCloud) by default
      "NSDocumentSaveNewDocumentsToCloud" = false;
    };

    CustomUserPreferences = {
      "NSGlobalDomain" = {
        # Add a context menu item for showing the Web Inspector in web views
        "WebKitDeveloperExtras" = true;
      };

      "com.apple.Safari.SandboxBroker" = {
        # Enable the Develop menu and the Web Inspector
        "ShowDevelopMenu" = 1;
      };

      "com.apple.finder" = {
        # Keep folders on top when sorting by name
        "_FXSortFoldersFirst" = true;

        # Expand some File Info panes
        # "FXInfoPanesExpanded" = {
        #   "General" = true;
        #   "OpenWith" = true;
        #   "Privileges" = true;
        # };
      };

      "com.apple.terminal" = {
        # Only use UTF-8
        StringEncodings = (4);
      };

      "com.apple.TimeMachine" = {
        # Prevent Time Machine from prompting to use new hard drives as backup volume
        DoNotOfferNewDisksForBackup = true;
      };

      "com.apple.TextEdit" = {
        # Use plain text mode for new documents
        RichText = 0;

        # Open and save files as UTF-8
        PlainTextEncoding = 4;
        PlainTextEncodingForWrite = 4;
      };

      "com.apple.DiskUtility" = {
        # Enable the debug menu
        DUDebugMenuEnabled = true;
        "advanced-image-options" = true;
      };

      "com.apple.QuickTimePlayerX" = {
        # Auto-play videos
        MGPlayMovieOnOpen = true;
      };

      "com.apple.appstore" = {
        # Enable the WebKit Developer Tools in the Mac App Store
        WebKitDeveloperExtras = true;

        # Enable Debug Menu in the Mac App Store
        ShowDebugMenu = true;
      };

      "com.apple.SoftwareUpdate" = {
        # Enable the automatic update check
        AutomaticCheckEnabled = true;

        # Download newly available updates in background
        AutomaticDownload = 1;

        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };

      "com.apple.commerce" = {
        # Turn on app auto-update
        AutoUpdate = true;
      };

      "com.apple.ImageCapture" = {
        # Prevent Photos from opening automatically when devices are plugged in
        disableHotPlug = true;
      };

      "com.apple.ActivityMonitor" = {
        # Show the main window when launching
        OpenMainWindow = true;

        # Visualize CPU usage in the Dock icon
        IconType = 5;

        # Show all processes
        ShowCategory = 0;

        # Sort results by CPU usage
        SortColumn = "CPUUsage";
        SortDirection = 0;
      };

      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network volumes
        "DSDontWriteNetworkStores" = true;

        # Avoid creating .DS_Store files on USB volumes
        "DSDontWriteUSBStores" = true;
      };

      # FIXME: doesn't work
      # "com.apple.Safari" = {
      #   # Press Tab to highlight each item on a web page
      #   "WebKitTabToLinksPreferenceKey" = true;
      #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;

      #   # Show the full URL in the address bar (note: this still hides the scheme)
      #   "ShowFullURLInSmartSearchField" = true;

      #   # Prevent Safari from opening ‘safe’ files automatically after downloading
      #   "AutoOpenSafeDownloads" = false;

      #   # Enable continuous spellchecking
      #   "WebContinuousSpellCheckingEnabled" = true;

      #   # Disable auto-correct
      #   "WebAutomaticSpellingCorrectionEnabled" = false;

      #   # Enable warns about fraudulent websites
      #   "WarnAboutFraudulentWebsites" = true;

      #   # Enable DNT header
      #   "SendDoNotTrackHTTPHeader" = true;

      #   # Set home page to `about:blank` for faster loading
      #   "HomePage" = "about:blank";

      #   # Enable Safari’s debug menu
      #   "IncludeInternalDebugMenu" = true;

      #   # Enable the Develop menu and the Web Inspector
      #   "IncludeDevelopMenu" = 1;
      #   "WebKitPreferences.developerExtrasEnabled" = 1;
      #   "WebKitDeveloperExtrasEnabledPreferenceKey" = true;
      #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;

      #   # use 1Password autofill instead of the built-in one
      #   "AutoFillCreditCardData" = 0;
      #   "AutoFillFromAddressBook" = 0;
      #   "AutoFillMiscellaneousForms" = 0;
      #   "AutoFillPasswords" = 0;
      # };
    };
  };

  # Enable sudo authentication with Touch ID
  security.pam.enableSudoTouchIdAuth = true;
}
