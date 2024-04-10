{ config, pkgs, ... }:

{  programs.zsh = {
    enable = true;
   ## autocd = true; # cdなしでファイルパスだけで移動
    enableCompletion = true; # 自動補完
    enableAutosuggestions = true; # 入力サジェスト
    syntaxHighlighting.enable = true; # シンタックスハイライト
  
   initExtra = ''
    export HISTSIZE=10000
    export SAVEHIST=1000000
    export HISTFILE=~/.zsh_history
    # The meaning of these options can be found in man page of `zshoptions`.
    setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
    setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
    setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
    setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
    setopt EXTENDED_HISTORY  # record command start time
  '';
#     };
    shellAliases = {
      cat = "bat";
      grep = "rg";
      ##      ls = "eza --icons always --classify always";
     ## ls  = "ls --color=auto --group-directories-first";
      la = "eza --icons always --classify always --all ";
      ll = "eza --icons always --long --all --git ";
      tree = "eza --icons always --classify always --tree";
      clip = "xsel --clipboard --input";
      history = "fc -l 1";
    };
   };
   # oh-my-posh = {
     
   # };
  }
