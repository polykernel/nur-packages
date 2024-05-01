{
  description = "An experimental NUR repository";

  inputs = {
    systems.url = "github:nix-systems/default-linux/main";

    dream2nix.url = "github:nix-community/dream2nix/main";

    haumea.url = "github:nix-community/haumea/main";

    flake-parts.url = "github:hercules-ci/flake-parts/main";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      {
        imports = [ ./dev/modules/ci.nix ];

        systems = import inputs.systems;

        flake = {
          homeManagerModules = inputs.haumea.lib.load {
            src = ./modules/home-manager;
            loader = inputs.haumea.lib.loaders.path;
          };
        };

        perSystem = { lib, config, pkgs, self', ... }: {
          packages = inputs.dream2nix.lib.importPackages {
            projectRoot = ./.;
            projectRootFile = "flake.nix";
            packagesDir = ./packages;
            packageSets.nixpkgs = pkgs;
          };

          ci =
            let
              isBuildable = p: !(p.meta.broken or false) && (p.meta.license.free or true);
              isCachable = p: !(p.preferLocalBuild or false);
              shouldRecurseForDerivations = p: lib.isAttrs p && p.recurseForDerivations or false;

              filterDrvs = pred: attrs:
                lib.listToAttrs (
                  lib.concatMap (name:
                    let v = attrs.${name}; in
                    if shouldRecurseForDerivations v then
                      [(lib.nameValuePair name (filterDrvs v))]
                    else
                      lib.optional (pred v) (lib.nameValuePair name v)
                  ) (lib.attrNames attrs)
                );

              cachePkgs = filterDrvs (v: isBuildable v && isCachable v) self'.packages;
            in
            cachePkgs;
        };
      }
    );
}
