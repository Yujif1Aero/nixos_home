{ config, pkgs, ... }:{
programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;
    difftastic.enable = true;

    userName  = "Yuji Shimojima";
    userEmail = "shimojima@morgenrot.net";

    extraConfig = {
      core.editor = "emacs";
      merge.tool = "${pkgs.meld}/bin/meld";
      pull.ff = "only";
      init.defaultBranch = "master";
      github.user = "Yujif1Aero";
      gitlab.user = "YujiOLB";
    };
  };
  }
