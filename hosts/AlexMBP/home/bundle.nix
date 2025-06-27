{ home, ... }:

{
  # TODO
  # number_of_cores=$(/usr/sbin/sysctl -n hw.ncpu)

  # echo "[+] Set up system bundler to use $((number_of_cores - 1)) cores"
  # /usr/bin/bundle config set --global jobs $((number_of_cores - 1))

  home.file.".bundle/config" = {
    text = ''
      ----
      BUNDLE_SET: "--global jobs 7"
    '';
  };
}
