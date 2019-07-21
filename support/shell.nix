let 
  pkgs = (import <nixpkgs> {});
in
  pkgs.mkShell {
      buildInputs = with pkgs; [ gcc wget git ];
      hardeningDisable = ["all"];
  }
  