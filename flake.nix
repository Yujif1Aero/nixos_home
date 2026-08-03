{
  description = "Yuji setting";
#inputsはFlakeの依存関係を定義するためのフィールド
  inputs = {
    stable.url = github:NixOS/nixpkgs/nixos-24.05;
    unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    oldstable.url = github:NixOS/nixpkgs/nixos-23.11;
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    llm-agents.url = "github:numtide/llm-agents.nix";
    paraview-nixpkgs.url = "github:NixOS/nixpkgs/c407032be28ca2236f45c49cfb2b8b3885294f7f"; #paraview 5.11.2 for the connectiong other machines's paraview
    home-manager = {
      #      url = github:nix-community/home-manager/release-24.05;
      url = "github:nix-community/home-manager/master";
      inputs = { nixpkgs.follows = "unstable"; };
    };
    # ...
    #flake-utils.url = github:numtide/flake-utils;
  };
# #outputsはこの関数はFlakeの主要な部分で、フレークの出力を定義。引数にinputsをもつ。:<-の前が引数.この場合homeConfigurationsが出力
  outputs = inputs: {
    # ...
   homeConfigurations = {
     yujif1aero = inputs.home-manager.lib.homeManagerConfiguration {
         pkgs = import inputs.unstable {
         system = "x86_64-linux";
         config.allowUnfree = true; # プロプライエタリなパッケージを許可
       };
       extraSpecialArgs = {
         inherit inputs;
         pkgs-paraview = import inputs.paraview-nixpkgs {
           system = "x86_64-linux";
           config.allowUnfree = true;
         };
       };
       modules = [
         ./home.nix
       ];
     };
   };
  };

}
