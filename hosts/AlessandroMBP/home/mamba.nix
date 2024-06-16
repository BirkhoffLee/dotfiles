{ home, ... }:

{
  home.file.".mambarc" = {
    text = ''
      channels:
        - conda-forge
    '';
  };
}
