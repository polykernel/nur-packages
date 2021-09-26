{ lib
, cmake
, fetchFromGitHub
, libxml2
, llvmPackages
, zlib
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "zig";
  version = "master";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    sha256 = "sha256-I6N67/oYCoGUGmwhwrxqNR3TmdBqRYEk/6e9q76DRdU=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.llvm.dev
  ];

  buildInputs = [
    libxml2
    llvmPackages.libclang
    llvmPackages.lld
    llvmPackages.llvm
    zlib
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ./zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
    runHook postCheck
  '';

  meta = with lib; {
    description = "A general-purpose programming language and toolchain for maintaining robust, optimal, and reusable software.";
    homepage = "https://github.com/ziglang/zig";
    license = licenses.mit;
    maintainers = [ maintainers.polykernel ];
    platforms = platforms.unix;
    # See https://github.com/NixOS/nixpkgs/issues/86299
    broken = llvmPackages.stdenv.isDarwin;
  };
}
