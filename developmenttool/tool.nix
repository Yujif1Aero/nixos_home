{pkgs,pkgs-paraview, ...}: {
  home.packages = with pkgs; [
    #gcc13
    #gdb
    texlive.combined.scheme-full
    #gnumake
    #mpi
    gnuplot
    #    paraview
    pkgs-paraview.paraview
    htop
    zenith
    nodejs
    clang-tools #for emacs
    silver-searcher #for emacs
    (pkgs.python312.withPackages (ps: with ps; [ jupyterlab ]))
  ];
}

