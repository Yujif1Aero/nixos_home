{ pkgs, pkgs-paraview, ... }:

{
  # Emacs本体とEmacs Lispパッケージ
  programs.emacs = {
    enable = true;

    # Ubuntuで入れていたEmacs 30.xに合わせる
    package = pkgs.emacs30;

    # Emacs内部の入力メソッドとしてMozcを使う場合
    extraPackages = epkgs: [
     pkgs.mozc
    ];
  };

  # Emacs daemon / emacsclient
  services.emacs = {
    enable = true;
    client.enable = true;
  };

  # Fcitx5 + Mozc
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
      ];

      # x11vncを使っているので、おそらくX11環境
      waylandFrontend = false;
    };
  };

  # デフォルトアプリケーション
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "application/pdf" = [
        "org.gnome.Evince.desktop"
      ];

      "text/plain" = [
        "emacsclient.desktop"
      ];
    };
  };

  home.packages = with pkgs; [
    texlive.combined.scheme-full
    gnuplot
    pkgs-paraview.paraview
    htop
    zenith
    nodejs
    clang-tools
    silver-searcher

    (python312.withPackages (ps: with ps; [
      jupyterlab
    ]))

    # Ubuntuスクリプトで準備用に入れていたもの。
    # 実際にコマンドとして使う場合だけ必要。
    curl
    gnupg
  ];
}
