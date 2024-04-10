{
  description = "Yuji setting";
  inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # ...
   home-manager = {
     url = "github:nix-community/home-manager";
     inputs.nixpkgs.follows = "nixpkgs";
   };
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = inputs: {
    # ...
   homeConfigurations = {
     yujif1aero = inputs.home-manager.lib.homeManagerConfiguration {
         pkgs = import inputs.nixpkgs {
         system = "x86_64-linux";
         config.allowUnfree = true; # プロプライエタリなパッケージを許可
       };
       extraSpecialArgs = {
         inherit inputs;
       };
       modules = [
         ./home.nix
       ];
     };
   };
};
}
