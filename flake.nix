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
      flags = {
        includeCLI = true;
        includeGUI = true;
        includeBootstrappedNvim = true;
        includeIntelGPUdrives = false;
      };
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      lib = nixpkgs.lib;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
          };
        in
        {
          default = pkgs.buildEnv {
            name = "package env";
            paths =
              lib.optionals flags.includeCLI
                (import ./cli.nix { inherit pkgs; })
              ++ lib.optionals flags.includeGUI
                (import ./gui.nix { inherit pkgs system; })
              ++ lib.optionals flags.includeBootstrappedNvim [
                edvard-dotfiles.packages.${system}.neovim
              ]
              ++ lib.optionals flags.includeIntelGPUdrives [
                (import ./graphics-drivers/intel.nix { inherit pkgs; })
              ]
              ;
          };
        }
      );
    };
}
