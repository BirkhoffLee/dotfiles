{
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        overrideGpg = true;

        pagers = [
          {
            pager = "DELTA_FEATURES=decorations delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
            colorArg = "always";
          }
        ];

        commit = {
          signOff = true;
        };
      };
    };
  };
}
