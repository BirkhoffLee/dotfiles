{ pkgs, ... }:

{
  imports = [
    ../../home
  ];

  # Greet interactive login shells (i.e. `ssh nixos-server-01`) with a system
  # report. `.zlogin` only runs for login shells, so `ssh <host> <cmd>`, scp and
  # rsync stay untouched; the interactive guard covers `ssh -T`.
  programs.zsh.loginExtra = ''
    if [[ -o interactive ]]; then
      ${pkgs.machinereport}/bin/machinereport --title "BIRKHOFF INTERNAL SYSTEMS"
    fi
  '';

  home.packages = with pkgs; [
    # ── Shell & terminal ───────────────────────────────────────────────────
    glow # render Markdown
    machinereport # system fetch tool, shown on login

    # ── Developer tools ────────────────────────────────────────────────────
    just
    git-open # `git open` to open the GitHub page
    gh # GitHub CLI

    # ── Nix tooling ────────────────────────────────────────────────────────
    nil # Nix LSP
    yaml-language-server
  ];
}
