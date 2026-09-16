{ inputs, pkgs, ... }:
{
  home.packages = [
# Codex
    pkgs.codex
    inputs.llm-agents.packages.${pkgs.system}.codex-acp
# Claude
    pkgs.claude-code

  ];
}
