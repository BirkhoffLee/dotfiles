{
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    ../../home
    ../../home/modules/1password.nix
    ../../home/modules/ghostty.nix
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  home.packages = with pkgs; [
    # ── Shell & terminal ───────────────────────────────────────────────────
    glow # render Markdown

    # ── Developer tools ────────────────────────────────────────────────────
    just
    git-open # `git open` to open the GitHub page
    gh # GitHub CLI

    # ── Nix tooling ────────────────────────────────────────────────────────
    nil # Nix LSP
    yaml-language-server

    # ── Desktop utilities ──────────────────────────────────────────────────
    libnotify # provides notify-send (required by zsh-auto-notify)
    xdg-utils
  ];

  programs.firefox = {
    enable = true;

    # Adopt the XDG layout that home-manager makes the default at
    # home.stateVersion 26.05. `configPath` feeds `home.file.<name>`, so it must
    # stay relative to $HOME — this mirrors upstream's own default expression.
    configPath = "${lib.removePrefix "${config.home.homeDirectory}/" config.xdg.configHome}/mozilla/firefox";

    profiles.default = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        onepassword-password-manager
      ];
    };
  };
}
