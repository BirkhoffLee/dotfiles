{ pkgs, lib, ... }:
{
  # https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#running-on-macos-as-a-control-node
  home.sessionVariables = lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
  };

  home.file.".ansible.cfg" = {
    text = ''
      [defaults]
      deprecation_warnings = False
      interpreter_python = auto_silent
      nocows = 1
      timeout = 25
      forks = 25
      gathering = smart
      fact_caching = jsonfile
      fact_caching_connection = /tmp
      host_key_checking = False

      [ssh_connection]
      pipelining = True
      ssh_args = -o ControlMaster=auto -o ControlPersist=3600s -o PreferredAuthentications=publickey
    '';
  };
}
