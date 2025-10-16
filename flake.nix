{
  description = "A NixOS flake that includes all packages from configuration.nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # Use a specific branch or commit
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # or detect automatically using builtins.currentSystem
      modules = [
        ./configuration.nix
      ];
    };
  };

  {
    description = "rofi menu generator flake";

    inputs = {
      nixpkgs.url = "nixpkgs"; # We want to use packages from the binary cache
      flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      packages.oWxGTK31 = pkgs.callPackage ./wxGTK31.nix {
        inherit (pkgs.darwin.stubs) setfile;
        inherit (pkgs.darwin.apple_sdk.frameworks) AGL Carbon Cocoa Kernel QTKit AVFoundation AVKit WebKit;
          withMesa = true;
          withWebKit = true;
          withPrivateFonts = true;
          withCurl = true;
      };
      packages.orca-slicer = pkgs.callPackage ./default.nix {
        inherit (pkgs.gst_all_1) gstreamer gst-plugins-base gst-plugins-bad;
        inherit (packages) oWxGTK31;
      };

      legacyPackages = packages;

      defaultPackage = packages.orca-slicer;

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [ git ];
      };

    });
  }
}
