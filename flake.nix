{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              ansible
              ansible-lint
            ];
          };
        };

        checks = {
          formatting =
            pkgs.runCommandLocal "formatting"
              {
                src = ./.;

                env = {
                  HOME = "./"; # Hack to allow ansible-lint to create a directory to the home directory
                };

                nativeBuildInputs = with pkgs; [ ansible-lint ];
              }
              ''
                ansible-lint -v
                mkdir "$out"
              '';
        };
      }
    );
}
