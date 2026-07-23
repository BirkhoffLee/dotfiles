{
  programs.fzf = {
    enable = true;

    # Use C-t from fzf
    # https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line
    enableZshIntegration = true;

    # Disable Ctrl-R (using Atuin instead)
    historyWidget.command = "";
  };
}
