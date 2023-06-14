{ home, ... }:

{
  home.file.".gemrc" = {
    text = ''
      gem: --no-ri --no-rdoc
    '';
  };
}
