{ pkgs }:

let
  sioyekWrapped = pkgs.symlinkJoin {
    name = "sioyek";
    paths = [ pkgs.sioyek ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/sioyek \
        --set QT_QPA_PLATFORM wayland \
        --set QT_XCB_GL_INTEGRATION xcb_glx
    '';
  };
in
with pkgs;
[
  sioyekWrapped
  qgroundcontrol
  thunderbird
  librewolf # firefox
  vlc
]
