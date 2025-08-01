{pkgs, ...}: {
  home.packages = with pkgs; [
    gcc13
    gdb
    texlive.combined.scheme-full
#    python312
    gnumake
    mpi
    gnuplot
    paraview
    htop
    zenith
    nodejs
    clang-tools #for emacs
    silver-searcher #for emacs
   # python310Full
   (pkgs.python310Full.withPackages (ps: with ps; [ jupyterlab ]))
   
  ];
}

