{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  libtiff,
  libjpeg_turbo,
  libpng,
  librsvg,
  giflib,
  libwebp,
  libheif,
  libjxl,
  openexr_3,
  fontconfig,
  libxkbcommon,
  wayland,
  wayland-scanner,
  wayland-protocols,
  json_c,
  freetype,
  libexif,
  bash-completion,
  exifSupport ? true,
  withBackends ? [ "jpeg" "jxl" "png" "gif" "svg" "webp" "heif" "tiff" ],
}:

let
  # Adapated from NixOS imv package, commit 4f927ee34182154535e24cb7b8ed75a849609638.
  backends = {
    png = libpng;
    jxl = libjxl;
    gif = giflib;
    svg = librsvg;
    webp = libwebp;
    heif = libheif;
    tiff = libtiff;
    jpeg = libjpeg_turbo;
    exr = openexr_3;
  };

  optionalFeature = f: c: if c then "-D${f}=enabled" else "-D${f}=disabled";

  backendFlags = map (b: optionalFeature b (builtins.elem b withBackends)) (lib.attrNames backends);
in

# check that every given backend is valid
assert builtins.all (b: lib.assertOneOf "each backend" b (builtins.attrNames backends)) withBackends;

stdenv.mkDerivation rec {
  pname = "swayimg";
  version = "1.12";
  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "artemsen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aKDt4lPh4w0AOucN7VrA7mo8SHI9eJqdrpJF+hG93gI=";
  };

  mesonFlags = [
    "-Dman=true"
    "-Dbash=enabled"
    "-Dzsh=enabled"
    "-Ddesktop=true"
    (optionalFeature "exif" exifSupport)
  ] ++ backendFlags;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  strictDeps = true;

  buildInputs = [
    bash-completion
    wayland.dev
    fontconfig
    libxkbcommon
    json_c
    wayland-protocols
  ] ++ lib.optional exifSupport libexif
    ++ map (b: backends.${b}) withBackends;

  meta = with lib; {
    description = "a lightweight image viewer for Sway/Wayland display servers";
    homepage = "https://github.com/artemsen/swayimg";
    license = licenses.mit;
    maintainers = with maintainers; [ polykernel ];
    platforms = platforms.linux;
  };
}
