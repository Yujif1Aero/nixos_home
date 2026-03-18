{pkgs,pkgs-paraview, ...}: {
  services.emacs = {
    enable = true;
    client.enable = true; # emacsclientを有効化（これで.desktopファイルが生成されます）
  };

  # デフォルトアプリケーションの設定
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      
      # 2. 通常のemacsではなく、emacsclientを指定する！
      "text/plain" = [ "emacsclient.desktop" ];
    };
  };
  home.packages = with pkgs; [
    #gcc13
    #gdb
    texlive.combined.scheme-full
    #gnumake
    #mpi
    gnuplot
    #    paraview
    pkgs-paraview.paraview
    htop
    zenith
    nodejs
    clang-tools #for emacs
    silver-searcher #for emacs
    (pkgs.python312.withPackages (ps: with ps; [ jupyterlab ]))
  ];
}

