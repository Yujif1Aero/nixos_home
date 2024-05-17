 { config, pkgs, ... }: # ROCm and clinfo packages
 {

  # ROCm and clinfo packages
  home.packages = with pkgs; [
    rocm-opencl-icd
    clinfo
   # rocm-smi
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
   
  ];

  # Set necessary environment variables for ROCm
  home.sessionVariables = {
    OPENCL_VENDOR_PATH = "/run/opengl-driver/share/vulkan/icd.d";
    ROCM_PATH = "/run/current-system/sw";
  };

 }
