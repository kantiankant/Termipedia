{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      # allow use on any system
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem =
        { self', pkgs, ... }:
        let
          name = "termipedia";
        in
        {
          packages."${name}" = pkgs.writeShellApplication {
            # package name
            inherit name;

            # dependencies
            runtimeInputs = with pkgs; [ curl jq fzf less ];

            # script
            text = builtins.readFile ./termipedia.sh;
          };

          packages.default = self'.packages."${name}";
        };
    };
}
