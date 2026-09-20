{ pkgs, ... }:

let
  driversEnv = pkgs.buildEnv {
    name = "graphics-drivers";
    paths = with pkgs; [
      mesa # glxinfo
      intel-compute-runtime # clinfo
      intel-media-driver # vainfo
    ];
  };
in
pkgs.runCommand "graphics-drivers" { } ''
  mkdir -p $out/drivers
  cd $out/drivers
  ln -s "${toString driversEnv}" opengl-driver
''
