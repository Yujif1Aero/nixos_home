 { config, pkgs, ... }:{
  home.packages = with pkgs; [
   bat
   bottom
   eza
   httpie
   pingu
   ripgrep
   xclip
   curl
   unzip
  ];
  }
