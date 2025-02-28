{
  description = "Example NixOS Integration Tests";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
    perSystem = { config, pkgs, ... }: {
      packages.default = pkgs.testers.runNixOSTest ./test.nix;
      packages.echo = pkgs.testers.runNixOSTest ./echo/test.nix;

      checks = {
        inherit (config.packages) default echo;
        default-interactive = config.packages.default.driverInteractive;
        echo-interactive = config.packages.echo.driverInteractive;
      };
    };
  };
}
