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
   tmux
   emacs
  ];
  services.emacs = {
    enable = true;
    client.enable = true;
  };
  # デフォルトアプリケーションの設定
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # テキストファイルをEmacsで開く
      "text/plain" = [ "emacs.desktop" ];
    };
  };
  }
