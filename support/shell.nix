/* This file defines the build environment used for testing and CI.
   You can ignore it if you don't know what nix is. */
let 
  pkgs = import (builtins.fetchTarball {
    url = https://github.com/nixos/nixpkgs/archive/e467600691717e2196ae377c8b189894d4a0cbb9.tar.gz;
    sha256 = "058dj7dm0ix0ky9lw4588xn94mxi6h8ayckmpv2gphn1r5gnhidf";
  }) {};
in
  pkgs.mkShell {
      buildInputs = with pkgs; [ 
        gcc wget git flex bison file automake autoconf autoconf-archive texinfo
      ];
      hardeningDisable = ["all"];
  }
  