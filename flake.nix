{
  description = "Packwiz devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      with pkgs;
      {
        devShells.default = mkShell { buildInputs = [ packwiz ]; };

        apps = {
          pack =
            let
              app = pkgs.writeShellApplication {
                name = "pack";
                runtimeInputs = with pkgs; [ packwiz ];
                text = ''
                  packwiz modrinth export -o Yofo.mrpack
                '';
              };
            in
            {
              type = "app";
              program = "${app}/bin/${app.name}";
            };
        };
      }
    );
}
