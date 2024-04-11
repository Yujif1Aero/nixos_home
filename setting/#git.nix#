{ config, pkgs, ... }:{
programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;
    difftastic.enable = true;

    userName  = "Yuji Shimojima";
    userEmail = "yuji.shimojima.s@gmail.com";

    extraConfig = {
      core.editor = "emacs";
      merge.tool = "${pkgs.meld}/bin/meld";
      pull.ff = "only";
      init.defaultBranch = "master";
      gitlab.user = "Yujif1Aero";
      github.user = "YujiOLB";
    };
  };
  }