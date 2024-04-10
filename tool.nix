{  pkgs, flake-utils, ... }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true; # ROCmなどの非フリーパッケージを利用する場合に必要
          };
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.gcc13
            pkgs.curl
            pkgs.python313
           # pkgs.texlive.combined.scheme-full # TexLiveのフルインストール
            # ここにROCmのパッケージを追加
           # pkgs.rocmPackages.rpp
           # pkgs.rocmPackages.clr
           # pkgs.rocmPackages.hipcc
           # pkgs.rocmPackages.rocm-smi
            # 必要に応じて他のROCm関連パッケージを追加
            pkgs.gnuplot
            pkgs.gnumake
            pkgs.unzip
          ];
        };
      }
    );
