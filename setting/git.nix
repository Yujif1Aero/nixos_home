{ config, pkgs, ... }:{
programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;
    difftastic.enable = true;

    userName  = "Yuji Shimojima";
    userEmail = "yuji.shimojima@kit.edu";

    extraConfig = {
      core.editor = "vim";
      merge.tool = "${pkgs.meld}/bin/meld";
      pull.ff = "only";
      init.defaultBranch = "master";
      github.user = "Yujif1Aero";
      gitlab.user = "Yujif1Aero";
    };
  };
  }
