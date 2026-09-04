{ inputs, pkgs, ... }:
{
  home.packages = [
# Codex
    inputs.codex-cli-nix.packages.${pkgs.system}.default
    inputs.llm-agents.packages.${pkgs.system}.codex-acp
# Claude
    inputs.llm-agents.packages.${pkgs.system}.claude-code

  ];
}
