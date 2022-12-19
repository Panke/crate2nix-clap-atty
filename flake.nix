{
  description = "Trading Engine";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      crate2nix-tools = pkgs.crate2nix.tools;
      generated = crate2nix-tools.generatedCargoNix { 
        name = "trading";
        src = ./.;
      };
      called = pkgs.callPackage "${generated}/default.nix" {};
    in
    {
      packages.${system}.default = called.workspaceMembers.engine-ui.build;
      devShell.${system} =
        pkgs.mkShell {
          nativeBuildInputs = [ pkgs.rustc pkgs.cargo pkgs.cargo-insta pkgs.pkg-config pkgs.nixpkgs-fmt pkgs.rustfmt ];
          buildInputs = [ pkgs.openssl ];
        };
    };
}
