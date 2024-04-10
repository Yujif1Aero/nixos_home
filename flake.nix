{
  description = "Yuji setting";
#inputsはFlakeの依存関係を定義するためのフィールド
  inputs = {
    stable.url = github:NixOS/nixpkgs/nixos-23.11;
    unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    oldstable.url = github:NixOS/nixpkgs/nixos-22.11;
   
    home-manager = {
      url = github:nix-community/home-manager/release-23.11;
      inputs = { nixpkgs.follows = "stable"; };
    };
    # ...
    flake-utils.url = github:numtide/flake-utils;
  };
#outputsはこの関数はFlakeの主要な部分で、フレークの出力を定義。引数にinputsをもつ。:<-の前が引数.この場合homeConfigurationsが出力
  outputs = inputs: {  
    # ...
   homeConfigurations = {
     yujif1aero = inputs.home-manager.lib.homeManagerConfiguration {
         pkgs = import inputs.stable {
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


  ####例題
  # { pkgs ? import <nixpkgs> { }, ... }: {
  # hello-rs = pkgs.rustPlatform.buildRustPackage {
  #   name = "hello-rs";
  #   src = ./.;
  #   cargoLock = { lockFile = ./Cargo.lock; };
  # };
  # }
  #   コードの出力は、hello-rsという名前のRustプロジェクトのビルド
  #   出力は、このビルドされたRustパッケージ hello-rs。ソースコードと依存関係に基づいて構築され、Nixパッケージセット内のpkgsの一部として利用可能になる
  #inherit inputs は 親スコープの値がはいる。子スコープinputs = 親スコープinputsの意味
    
