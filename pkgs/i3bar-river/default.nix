{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  pango,
  cairo,
  glib,
  wayland,
}:

let
  rpathLibs = [
    pango
    glib
    cairo
    wayland
  ];
in

rustPlatform.buildRustPackage rec {
  pname = "i3bar-river";
  version = "master";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = pname;
    rev = "2c6a8a3895158aca192712db8eb6d0dfe13a2998";
    sha256 = "sha256-9Niokyjnt4QS6Ykht+EgDtWB1CFaFtNzX+lkdrcxk90=";
  };

  cargoHash = "sha256-hIJLtREO4VQ1wzt1zgnOC6jE+Wuyins3NGXAjl5Cvjg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ pango ];

  postInstall = ''
    # Strip executable and set RPATH
    # Stolen from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/terminal-emulators/alacritty/default.nix#L107
    strip -s $out/bin/i3bar-river
    patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/i3bar-river
  '';

  dontPatchELF = true;

  meta = with lib; {
    description = "A port of i3bar for river.";
    homepage = "https://github.com/MaxVerevkin/i3bar-river";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.polykernel ];
    platforms = platforms.linux;
  };
}
