{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "commitmono-nerd-font";
  version = "1.143";

  src = pkgs.fetchzip {
    url = "https://github.com/BirkhoffLee/CommitMono-Customized-NF/releases/download/v${version}/CommitMono.Nerd.Font.zip";
    sha256 = "sha256-ihnN1sbL8Nb4ks7D55Zsbwq+CiNSqCMX6UCIT7CkvGA=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    find . -type f -name '*.otf' -exec cp -v {} $out/share/fonts/truetype/ \;
  '';

  meta = with pkgs.lib; {
    description = "CommitMono Customized Nerd Font";
    homepage = "https://github.com/BirkhoffLee/CommitMono-Customized-NF";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
