{config,pkgs, ...}: {
  # Spotify TUI
  # programs.ncspot.enable = true;

  # OBS
  programs.obs-studio.enable = true;

  home.packages = with pkgs; [
    gnome.evince # PDFビューアー
    remmina # VNCクライアント
    slack
    vscode
    rclone
    thunderbird
    flameshot
##    teams-for-linux
  ];
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
