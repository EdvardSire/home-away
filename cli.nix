{ pkgs }:

with pkgs;
[ # cli
  ## coreutils++
  file
  fzf
  jq
  ripgrep
  moreutils
  zip
  unzip
  xxd
  smem

  ## utils
  iperf3
  perf
  nmap
  v4l-utils
  unison
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
  sqlite-interactive
] ++ [
  # language tooling
  nixfmt-rfc-style
]
