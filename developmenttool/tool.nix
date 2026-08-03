{ inputs, pkgs, pkgs-paraview, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  # Emacs本体
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30;

    # Emacs内部でMozcを使用する場合
    extraPackages = _epkgs: [
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

      # X11を使う場合
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

  # すべてのパッケージをここにまとめる
  home.packages = with pkgs; [
    # Codex
    inputs.codex-cli-nix.packages.${system}.default
    inputs.llm-agents.packages.${system}.codex-acp

    # 開発ツール
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

    curl
    gnupg
  ];
}
