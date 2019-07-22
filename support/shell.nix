/* This file defines the build environment used for testing.
   You can ignore it if you don't know what nix is. */
let 
  pkgs = (import <nixpkgs> {});
in
  pkgs.mkShell {
      buildInputs = with pkgs; [ 
        gcc wget git flex bison file automake autoconf autoconf-archive texinfo
      ];
      hardeningDisable = ["all"];
  }
  