{
  programs.zellij = {
    enable = true;

    # Shell Integration
    enableBashIntegration = false;
    enableZshIntegration = true;

    # Ensure we're always in a Zellij session when using
    # the shell.
    attachExistingSession = true;
    exitShellOnExit = true;

    # Layouts
    # @see https://zellij.dev/documentation/layouts.html
    layouts = { };
  };
}
