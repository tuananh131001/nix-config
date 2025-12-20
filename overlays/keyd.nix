final: prev:
let
  version = "2.6.0";

  src = prev.fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    rev = "v${version}";
    hash = "sha256-l7yjGpicX1ly4UwF7gcOTaaHPRnxVUMwZkH70NDLL5M=";
  };

  pypkgs = prev.python3.pkgs;

  appMap = pypkgs.buildPythonApplication {
    pname = "keyd-application-mapper";
    inherit version src;
    format = "other";

    postPatch = ''
      substituteInPlace scripts/keyd-application-mapper \
        --replace-fail /bin/sh ${prev.runtimeShell}
    '';

    propagatedBuildInputs = with pypkgs; [ xlib ];

    dontBuild = true;

    installPhase = ''
      install -Dm555 -t $out/bin scripts/keyd-application-mapper
    '';

    meta.mainProgram = "keyd-application-mapper";
  };

in {
  keyd = prev.stdenv.mkDerivation {
    pname = "keyd";
    inherit version src;

    postPatch = ''
      substituteInPlace Makefile \
        --replace-fail /usr/local ""

      substituteInPlace keyd.service.in \
        --replace-fail @PREFIX@ $out
    '';

    installFlags = [ "DESTDIR=${placeholder "out"}" ];

    buildInputs = [ prev.systemd ];

    enableParallelBuilding = true;

    postInstall = ''
      ln -sf ${prev.lib.getExe appMap} $out/bin/${appMap.pname}
      rm -rf $out/etc
    '';

    passthru.tests.keyd = prev.nixosTests.keyd;

    meta = {
      description = "Key remapping daemon for Linux";
      license = prev.lib.licenses.mit;
      maintainers = with prev.lib.maintainers; [ alfarel ];
      platforms = prev.lib.platforms.linux;
    };
  };
}
