{config,pkgs, ...}: {
  # Spotify TUI
  # programs.ncspot.enable = true;

  # OBS
  programs.obs-studio.enable = true;

  home.packages = with pkgs; [
    evince # PDFビューアー
    remmina # VNCクライアント
    slack
##    vscode
    vscode.fhs
    rclone
    thunderbird
    flameshot
    ghostscript   # 追加: PostScriptおよびPDFツール
    inkscape      # 追加: ベクター画像エディタ
    ##    teams-for-linux
    ghostscript
    inkscape
    filezilla #file 転送
  ];
    xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # PDFファイルをEvinceで開く
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };
  };
  systemd.user.services.x11vnc = {
    Unit = {
      Description = "x11vnc server (user session)";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = ''
        ${pkgs.x11vnc}/bin/x11vnc \
          -display :0 \
          -auth /home/yujif1aero/.Xauthority \
          -rfbauth /home/yujif1aero/.vnc/passwd \
          -forever \
          -shared \
          -noxdamage
      '';
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
