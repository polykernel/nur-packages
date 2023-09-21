{pkgs ? import <nixpkgs> {}}:

rec {
  lorien = pkgs.callPackage ./lorien {};
  i3bar-river = pkgs.callPackage ./i3bar-river {};
  kickoff = pkgs.callPackage ./kickoff {};
  wired-notify = pkgs.callPackage ./wired-notify {};
  swayimg = pkgs.callPackage ./swayimg {};
  wldash = pkgs.callPackage ./wldash {};
  wlopm = pkgs.callPackage ./wlopm {};
  lswt = pkgs.callPackage ./lswt {};
  kile = pkgs.callPackage ./kile {};
  aw-watcher-window-wayland = pkgs.callPackage ./aw-watcher-window-wayland {};
}
