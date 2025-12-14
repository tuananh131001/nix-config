{ pkgs }:

pkgs.stdenv.mkDerivation (
  let
    name = "ww-run-raise";

  in
  {
    pname = name;
    version = "";

    meta = with pkgs.lib; {
      description = "don't feel like describing :)";
      platforms = platforms.linux;
    };

    src = pkgs.fetchFromGitHub {
      owner = "academo";
      repo = "ww-run-raise";
      rev = "9cf2b3860f04a3b0124363ec4a5aaa864c4e9a86";
      hash = "sha256-XAlVWITZk3tCwC25zvs6Zn00YDUs/7PdlvOVK4nnoQM=";
    };

    # configurePhase = ''
    #   qmake -config release "CONFIG += release_lin build_original"
    # '';
    # buildPhase = ''
    #   make -j8
    # '';
    installPhase = ''
      mkdir -p $out/bin

      # remember to change from ww_kde6 -> ww after switching back from the fork 
      cp ww $out/bin/ww
    '';
  }
)
