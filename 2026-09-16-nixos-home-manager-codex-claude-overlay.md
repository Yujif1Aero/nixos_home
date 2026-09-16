# NixOS Home Manager: Codex / Claude Code overlay memo

Date: 2026-09-16

## Current state

I added a local nixpkgs overlay in `~/nixos_home` so Home Manager can install newer Codex and Claude Code versions without waiting for the upstream flake inputs to update.

Target versions used in this change:

- Codex CLI: `0.154.0`
- Claude Code: `2.1.273`

The overlay packages were built and tested directly from their Nix store paths:

```bash
/nix/store/ih043kn4ipdzd87hqj5ys8kmgiqnys72-codex-0.154.0/bin/codex --version
# codex-cli 0.154.0

/nix/store/1rj9pwh0cff1ix094baijwjn2kmsm58l-claude-code-2.1.273/bin/claude --version
# 2.1.273 (Claude Code)
```

However, `home-manager switch` did not finish activation because Home Manager found an existing unmanaged file:

```text
Existing file '/home/yujif1aero/.config/mimeapps.list' would be clobbered
```

Because activation stopped, the active profile still points to the old versions:

```bash
codex --version
# codex-cli 0.145.0

claude --version
# 2.1.220 (Claude Code)
```

## Files changed

The relevant staged changes in `~/nixos_home` are:

```text
M  agent.nix
M  developmenttool/tool.nix
M  flake.nix
A  overlays/ai-agents.nix
```

There were already unrelated untracked Emacs backup-style files:

```text
?? #home.nix#
?? developmenttool/#tool.nix#
?? gui/#browser.nix#
```

Those were not modified.

## What was added

### `overlays/ai-agents.nix`

This file defines two packages:

- `pkgs.codex`
- `pkgs.claude-code`

Codex is fetched from the npm platform tarball:

```nix
url = "https://registry.npmjs.org/@openai/codex/-/codex-${codexVersion}-linux-x64.tgz";
hash = "sha256-4nyDpJ5gMWhe5/lWwSqtXxZITTqAGB3T/qkw+5azgys=";
```

Claude Code is fetched from Anthropic's binary distribution URL:

```nix
url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${claudeCodeVersion}/linux-x64/claude";
hash = "sha256-bHUuLMfBEMnfFfJtjRNNQ4xa6V29YQ78GjCL9/nF9sE=";
```

Important detail: `dontStrip = true;` is needed for Claude Code. Without it, the built binary returned the wrong version string, `1.4.3`, even though the source binary was `2.1.273`.

### `flake.nix`

The overlay is loaded into the `pkgs = import inputs.unstable { ... }` block:

```nix
overlays = [
  (import ./overlays/ai-agents.nix)
];
```

### `agent.nix`

The AI tools now use the overlay packages:

```nix
home.packages = [
  pkgs.codex
  inputs.llm-agents.packages.${pkgs.system}.codex-acp
  pkgs.claude-code
];
```

`codex-acp` is still coming from `llm-agents.nix`.

### `developmenttool/tool.nix`

The duplicate Codex / Claude entries were removed from this file so the AI agent packages are managed in `agent.nix` only.

## Commands used

Check current installed versions:

```bash
which codex
codex --version
which claude
claude --version
```

Check where current profile symlinks point:

```bash
readlink -f ~/.nix-profile/bin/codex
readlink -f ~/.nix-profile/bin/claude
```

Fetch fixed-output hashes:

```bash
nix store prefetch-file --json \
  https://registry.npmjs.org/@openai/codex/-/codex-0.154.0-linux-x64.tgz

nix store prefetch-file --json \
  https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/2.1.273/linux-x64/claude
```

Build overlay packages:

```bash
nix build ~/nixos_home#homeConfigurations.yujif1aero.pkgs.codex --no-link --print-out-paths
nix build ~/nixos_home#homeConfigurations.yujif1aero.pkgs.claude-code --no-link --print-out-paths
```

Apply Home Manager:

```bash
home-manager switch --flake ~/nixos_home#yujif1aero
```

This failed at activation due to `~/.config/mimeapps.list`.

## How to finish activation

The quick option is to let Home Manager back up the existing file:

```bash
cd ~/nixos_home
home-manager switch -b hm-backup --flake .#yujif1aero
```

This should move the existing conflicting file to a backup name such as:

```text
~/.config/mimeapps.list.hm-backup
```

After that, confirm:

```bash
codex --version
claude --version
```

Expected:

```text
codex-cli 0.154.0
2.1.273 (Claude Code)
```

## How to update later

1. Check the latest versions:

```bash
npm view @openai/codex version
npm view @anthropic-ai/claude-code version
```

or use registry URLs:

```text
https://registry.npmjs.org/@openai/codex/latest
https://registry.npmjs.org/@anthropic-ai/claude-code/latest
```

2. Update the version variables in `~/nixos_home/overlays/ai-agents.nix`:

```nix
codexVersion = "...";
claudeCodeVersion = "...";
```

3. Prefetch new hashes:

```bash
nix store prefetch-file --json \
  https://registry.npmjs.org/@openai/codex/-/codex-<VERSION>-linux-x64.tgz

nix store prefetch-file --json \
  https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/<VERSION>/linux-x64/claude
```

4. Replace the `hash = "...";` values in the overlay.

5. Build-test:

```bash
nix build ~/nixos_home#homeConfigurations.yujif1aero.pkgs.codex --no-link --print-out-paths
nix build ~/nixos_home#homeConfigurations.yujif1aero.pkgs.claude-code --no-link --print-out-paths
```

6. Switch:

```bash
home-manager switch --flake ~/nixos_home#yujif1aero
```

Use `-b hm-backup` if Home Manager reports unmanaged-file conflicts.

## Flake gotcha

Because `~/nixos_home` is a Git repository, new files referenced by a flake must be tracked or at least staged. Otherwise Nix may fail with an error like:

```text
error: path '/nix/store/...-source/overlays/ai-agents.nix' does not exist
```

That is why `overlays/ai-agents.nix` was added to the Git index before testing:

```bash
git -C ~/nixos_home add overlays/ai-agents.nix
```

The final related files were staged together:

```bash
git -C ~/nixos_home add flake.nix agent.nix developmenttool/tool.nix overlays/ai-agents.nix
```

No commit was made.
