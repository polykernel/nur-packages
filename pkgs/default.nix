{pkgs ? import <nixpkgs> {}}:

rec {
  wired-notify = pkgs.callPackage ./wired-notify {};
  wldash = pkgs.callPackage ./wldash {};
}
