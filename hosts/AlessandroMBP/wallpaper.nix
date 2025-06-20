{ pkgs }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://misc-assets.raycast.com/wallpapers/loupe-mono-dark.heic";
    sha256 = "sha256-MwvRU7U4tO6F1duxBrHLOd7F5Gnzv/zyiZkm5EFqkY4=";
  };

  document-wflow = pkgs.writeText "document.wflow" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>AMApplicationBuild</key>
      <string>528</string>
      <key>AMApplicationVersion</key>
      <string>2.10</string>
      <key>AMDocumentVersion</key>
      <string>2</string>
      <key>actions</key>
      <array>
        <dict>
          <key>action</key>
          <dict>
            <key>AMAccepts</key>
            <dict>
              <key>Container</key>
              <string>List</string>
              <key>Optional</key>
              <false/>
              <key>Types</key>
              <array>
                <string>com.apple.cocoa.path</string>
              </array>
            </dict>
            <key>AMActionVersion</key>
            <string>1.0.2</string>
            <key>AMApplication</key>
            <array>
              <string>Finder</string>
            </array>
            <key>AMParameterProperties</key>
            <dict/>
            <key>AMProvides</key>
            <dict>
              <key>Container</key>
              <string>List</string>
              <key>Types</key>
              <array>
                <string>com.apple.cocoa.path</string>
              </array>
            </dict>
            <key>ActionBundlePath</key>
            <string>/System/Library/Automator/Set Desktop Picture.action</string>
            <key>ActionName</key>
            <string>Set the Desktop Picture</string>
            <key>ActionParameters</key>
            <dict/>
            <key>BundleIdentifier</key>
            <string>com.apple.Automator.SetDesktopPicture</string>
            <key>CFBundleVersion</key>
            <string>1.0.2</string>
            <key>CanShowSelectedItemsWhenRun</key>
            <true/>
            <key>CanShowWhenRun</key>
            <true/>
            <key>Category</key>
            <array>
              <string>AMCategoryFilesAndFolders</string>
            </array>
            <key>Class Name</key>
            <string>Set_Desktop_Picture</string>
            <key>InputUUID</key>
            <string>25E2625F-4A0A-43DF-8F7E-FB540F254036</string>
            <key>Keywords</key>
            <array>
              <string>Set</string>
              <string>Image</string>
              <string>Photo</string>
              <string>Display</string>
            </array>
            <key>OutputUUID</key>
            <string>4EE54FE0-02A1-44A4-95E3-8DC3F804AF03</string>
            <key>UUID</key>
            <string>710A359A-DFD7-4B1F-98D8-2971FA9AAFF4</string>
            <key>UnlocalizedApplications</key>
            <array>
              <string>Finder</string>
            </array>
            <key>arguments</key>
            <dict/>
            <key>conversionLabel</key>
            <integer>0</integer>
            <key>isViewVisible</key>
            <integer>1</integer>
            <key>location</key>
            <string>207.000000:68.000000</string>
          </dict>
          <key>isViewVisible</key>
          <integer>1</integer>
        </dict>
      </array>
      <key>connectors</key>
      <dict/>
      <key>workflowMetaData</key>
      <dict>
        <key>workflowTypeIdentifier</key>
        <string>com.apple.Automator.workflow</string>
      </dict>
    </dict>
    </plist>
  '';

  info-plist = pkgs.writeText "Info.plist" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleName</key>
      <string>SetWallpaper</string>
    </dict>
    </plist>
  '';
in
pkgs.writeShellScriptBin "set-wallpaper-script" ''
  set -e
  WORKFLOW_DIR=$(mktemp -d)
  mkdir -p "$WORKFLOW_DIR/SetWallpaper.workflow/Contents"
  cp ${document-wflow} "$WORKFLOW_DIR/SetWallpaper.workflow/Contents/document.wflow"
  cp ${info-plist} "$WORKFLOW_DIR/SetWallpaper.workflow/Contents/Info.plist"
  /usr/bin/automator -i "${wallpaper}" "$WORKFLOW_DIR/SetWallpaper.workflow"
  rm -rf "$WORKFLOW_DIR"
''
