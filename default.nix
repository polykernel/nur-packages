let 
  flake = import ./dev/flake-compat.nix { src = ./.; };
in
flake.defaultNix
