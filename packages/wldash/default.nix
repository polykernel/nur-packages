{
  dream2nix,
  config,
  lib,
  ...
}:

let
  inherit (lib)
    licenses
    maintainers
    platforms
    ;
in
{
  imports = [
    dream2nix.modules.dream2nix.buildRustPackage
    dream2nix.modules.dream2nix.rust-cargo-lock
  ];

  name = "wldash";
  version = "0.3.0";

  deps = { nixpkgs, ... }: {
    inherit (nixpkgs)
      fetchFromSourcehut
      pkg-config
      fontconfig
      dbus
      alsa-lib
      pulseaudio
      libxkbcommon
      ;
  };

  mkDerivation = {
    version = lib.mkForce "master";

    src = config.deps.fetchFromSourcehut {
      owner = "~kennylevinsen";
      repo = "wldash";
      rev = "70e53c1246e0d35b78c5db5146d0da6af716c293";
      sha256 = "sha256-TZDYO8YoUA1FOlmTiT6oYPx8+29NtQCeVCCJ8UOPJwE=";
    };

    nativeBuildInputs = with config.deps; [ pkg-config ];
  
    buildInputs = with config.deps; [
      fontconfig
      dbus
      alsa-lib
      pulseaudio
      libxkbcommon
    ];
  };

  public = {
    meta = {
      description = "A dashboard/launcher/control-panel thing for Wayland.";
      homepage = "https://git.sr.ht/~kennylevinsen/wldash";
      license = licenses.gpl3Plus;
      maintainers = [ maintainers.polykernel ];
      platforms = platforms.linux;
    };
  };
}