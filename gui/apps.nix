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
##    teams-for-linux
  ];

}
