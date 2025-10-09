{
  description = "A NixOS flake that includes all packages from configuration.nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-stable"; # Use a specific branch or commit
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # or detect automatically using builtins.currentSystem
      modules = [
        ./configuration.nix
      ];
    };
  };
}
