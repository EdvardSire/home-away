{ pkgs, system }:

with pkgs;
[
  sioyek
  qgroundcontrol
  thunderbird
  librewolf
  # firefox
  vlc
  tigervnc
  eog
  binaryninja-free
] ++ [
  geeqie
  qgis-ltr
  imhex
  wireshark
#] ++ [
#  (import ./plotjuggler.nix { inherit pkgs system; } )
] ++ [
  _1password-gui
] ++ [
  pika-backup
]
