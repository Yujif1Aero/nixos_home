{ config, pkgs, ... }:
{
  imports = [
    ./gui/browser.nix
    ./gui/apps.nix
    ./setting/zsh.nix
    ./setting/git.nix
    ./setting/apps.nix
 
    ./developmenttool/tool.nix
  ];

  # ...

##/home/yujif1aero環境下という意味。もしhome.sessionVariables.EDITOR = "vim";とした場合homeディレクトリの設定が変わる。
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
