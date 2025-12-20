final: prev: {
  keyd = prev.keyd.overrideAttrs (oldAttrs: rec {
    version = "2.6.0";
    src = prev.fetchFromGitHub {
      owner = "rvaiya";
      repo = "keyd";
      rev = "v${version}";
      # Use lib.fakeHash to trigger hash mismatch error that shows correct hash
      hash = prev.lib.fakeHash;
    };
  });
}
