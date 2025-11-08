{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # @see https://starship.rs/config
    settings = {
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$nix_shell"
        "$python"
        "$direnv"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      directory = {
        style = "blue";
        fish_style_pwd_dir_length = 1;
        truncate_to_repo = false; # Don't truncate to git repo name
      };

      direnv = {
        disabled = false;
        format = "[$symbol]($style)";
      };

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style) ";
        style = "cyan";
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
        staged = "";
      };

      nix_shell = {
        disabled = false;
        format = "[$symbol]($style) ";
        symbol = "❄️";
        heuristic = true;
      };

      python = {
        version_format = "\${major}\${minor}";
        symbol = "py";
      };

      git_state = {
        format = "([$state( $progress_current/$progress_total)]($style) )";
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
    };
  };
}
