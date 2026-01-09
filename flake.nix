{
  description = "Packages";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    edvard-dotfiles = {
      url = "github:edvardsire/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      edvard-dotfiles,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = { };
          };
          graphics-drivers = import ./graphics-drivers.nix { inherit pkgs; };
        in
        {
          default = pkgs.buildEnv {
            name = "package env";
            paths =
              (import ./cli.nix { inherit pkgs; })
              ++ (import ./gui.nix { inherit pkgs; })
              ++ [
                edvard-dotfiles.packages.${system}.neovim
                edvard-dotfiles.packages.${system}.q-cli
              ]
              ++ [ graphics-drivers ];
          };
        }
      );
    };
}
