{ config, pkgs, ... }:

{  programs.zsh = {
    enable = true;
   ## autocd = true; # cdなしでファイルパスだけで移動
    enableCompletion = true; # 自動補完
    enableAutosuggestions = true; # 入力サジェスト
    syntaxHighlighting.enable = true; # シンタックスハイライト
  
   initExtra = ''
    export HISTSIZE=50000
    export SAVEHIST=50000
    export HISTFILE=~/.zsh_history
    # コマンドの実行日時を記録
    export HISTTIMEFORMAT="%F %T "
    # history コマンドのフォーマットを設定
    setopt EXTENDED_HISTORY
  '';
#     };
    shellAliases = {
      cat = "bat";
      grep = "rg";
      ##      ls = "eza --icons always --classify always";
      ls  = "ls --color=auto --group-directories-first";
      la = "eza --icons always --classify always --all ";
      ll = "eza --icons always --long --all --git ";
      tree = "eza --icons always --classify always --tree";
      clip = "xsel --clipboard --input";
    };
   };
   # oh-my-posh = {
     
   # };
  }
