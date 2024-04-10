{ config, pkgs, ... }:
{
  imports = [
    ./gui/browser.nix
    ./gui/apps.nix
    ./setting/zsh.nix
    ./setting/git.nix
    ./setting/apps.nix
#    ./developmenttool/tool.nix
#    ./developmenttool/apps.nix
  ];

  # ...


  home = rec { # recでAttribute Set内で他の値を参照できるようにする
    username="yujif1aero";
    homeDirectory = "/home/${username}"; # 文字列に値を埋め込む
    stateVersion = "22.11";
  };
  programs.home-manager.enable = true; # home-manager自身でhome-managerを有効化


    programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    };

}
