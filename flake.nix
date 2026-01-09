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
            config = {
              allowBroken = true;
            };
          };
          graphicsDrivers =
            let
              driversEnv = pkgs.buildEnv {
                name = "graphics-drivers";
                paths = with pkgs; [
                  mesa
                  intel-compute-runtime
                ];
              };
            in
            pkgs.runCommand "graphics-drivers" { } ''
              mkdir -p $out/drivers
              cd $out/drivers
              ln -s "${toString driversEnv}" opengl-driver
            '';
        in
        {
          default = pkgs.buildEnv {
            name = "package env";
            paths =
              (
                with pkgs;
                [
                  git
                  git-lfs
                  htop
                  xsel
                  lazygit
                  tree
                  ncdu
                  moreutils
                  nmap
                  zoxide
                  lf
                  iperf3
                  nixfmt-rfc-style
                  v4l-utils
                  linuxPackages_latest.perf
                  # (python312.withPackages (python-pkgs: with python-pkgs; [
                  #     ipython
                  #     matplotlib
                  # ]))
                  # py-spy
                  # plotjuggler
                ]
                ++ [
                  sioyek
                  qgroundcontrol
                ]
              )
              ++ [
                edvard-dotfiles.packages.${system}.neovim
                edvard-dotfiles.packages.${system}.q-cli
              ]
              ++ [
                graphicsDrivers
              ];
          };
        }
      );
    };
}
