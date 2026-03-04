{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    # gitAndTools は廃止されたため、トップレベルの pkgs.gitFull を使用します
    package = pkgs.gitFull;
    
    # LFS 設定はそのまま維持
    lfs.enable = true;

    # unstable では userName / userEmail / extraConfig は 
    # すべて 'settings' 配下に記述するルールに変わりました
    settings = {
      user = {
        name = "Yuji Sam Shimojima";
        email = "yuji.shimojima@kit.edu";
      };

      core = {
        editor = "vim";
      };

      merge = {
        tool = "${pkgs.meld}/bin/meld";
      };

      pull = {
        ff = "only";
      };

      init = {
        defaultBranch = "master";
      };

      github = {
        user = "Yujif1Aero";
      };

      gitlab = {
        user = "Yujif1Aero";
      };
    };
  };

  # difftastic は git の中ではなく、独立した programs として定義するのが現在の推奨です
  programs.difftastic = {
    enable = true;
    git.enable = true; # unstable では明示的に true に設定する必要があります
  };
}