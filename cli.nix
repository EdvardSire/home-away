{ pkgs }:

with pkgs;
[ ## cli / coreutils++
  file
  fzf
  jq
  ripgrep
  moreutils
  zip
  unzip
  xxd
  smem
  socat
] ++ [ ## utils
  iperf3
  perf
  nmap
  v4l-utils
  unison
  android-tools
] ++ [ ## improve shell
  zoxide
] ++ [ ## git
  git
  git-lfs
  lazygit
] ++ [ ## tui
  htop
  tree
  ncdu
  lf
  sqlite-interactive
] ++ [ ## language tooling
  nixfmt-rfc-style
]
