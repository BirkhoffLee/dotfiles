{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      features = "side-by-side line-numbers decorations";
      syntax-theme = "ansi";

      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
        hunk-header-decoration-style = "cyan box ul";
      };

      navigate = true;
    };
  };
}
