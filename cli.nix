{ pkgs }:

with pkgs;
[
  # basic cli
  nmap
  iperf3
  ripgrep
  v4l-utils
  perf
  moreutils
  zip
  unzip
  sqlite-interactive
  xxd
  file
  fzf
] ++ [
  # improve shell
  zoxide
] ++ [
  # git
  git
  git-lfs
  lazygit
] ++ [
  # tui
  htop
  tree
  ncdu
  lf
] ++ [
  # language tooling
  nixfmt-rfc-style
]
