{
  description = "A tabletop roleplaying supplement published on itch.io";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        projectname = "love-and-other-superweapons";
      in
      {
        packages.default = pkgs.stdenvNoCC.mkDerivation {
          name = "${projectname}-pdf";
          nativeBuildInputs = [
            pkgs.texliveConTeXt
          ];
          src = self;
          buildPhase = ''
            pushd src/
            export OSFONTDIR=$PWD/fonts
            mtxrun --generate
            mtxrun --script fonts --reload
            context ${projectname}.tex --purgeall
          '';
          installPhase = ''
            mkdir $out
            cp ${projectname}.pdf $out/
          '';
        };
        devShell = pkgs.mkShell {
          name = projectname;
          packages = [
            pkgs.texliveConTeXt
          ];
        };
      }
    );
}
