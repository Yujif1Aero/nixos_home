{pkgs, ...}: {
  home.packages = with pkgs; [
    #gcc13
    texlive.combined.scheme-full
    #python312
    #gnumake
    rocmPackages.rocm-smi
    gnuplot
    paraview
    python310Full
    (pkgs.python310Full.withPackages (ps: with ps; [ jupyterlab ]))
  ];
}


# { pkgs, ... }:

# let
#   mkOption = pkgs.lib.mkOption;
#   types = pkgs.lib.types;

#   mkShellDerivation = n: ps: pkgs.stdenvNoCC.mkDerivation rec {
#     name = n;
#     buildInputs = ps;
#     shellHook = ''
#       export NIX_SHELL_NAME="${name}"
#     '';
#   };

# in {
#   options.custom = {
#     tasks = mkOption {
#       type = types.attrsOf (types.submodule {
#         options = {
#           description = mkOption {
#             type = types.uniq types.string;
#           };
#           directory = mkOption {
#             type = types.str;
#             default = "~/";
#           };
#           type = mkOption {
#             type = types.enum [ "launcher" "terminal" "local-shell" "local-editor" "environment" "python-console" "jupyter-lab" ];
#             default = "launcher";
#           };
#           command = mkOption {
#             type = types.str;
#           };
#           environment = mkOption {
#             type = types.package;
#           };
#         };
#       });
#     };

#   };

#   # 実際のタスクの設定
#   config.custom.tasks = {
#     cpp_shell = {
#       description = "Generic C++ shell environment";
#       directory = "~/";
#       type = "environment";
#       environment = mkShellDerivation "cpp-env" (with pkgs; [
#         cmake
#         gcc13
#         gdb cgdb
#         universal-ctags
#       ]);
#     };
#   };
# }
