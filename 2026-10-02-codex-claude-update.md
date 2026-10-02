# Codex と Claude Code を Nix/Home Manager で更新する手順

作成日: 2026-10-02

このマシンでは `codex` と `claude` は npm や Homebrew ではなく、`~/nixos_home/overlays/ai-agents.nix` の Nix overlay で固定されています。

現在の更新対象:

- Codex CLI: `0.160.0`
- Claude Code: `2.1.287`

## 1. 最新版を確認する

Codex:

```bash
curl -s https://registry.npmjs.org/@openai/codex/latest | jq -r .version
```

Claude Code:

```bash
curl -s https://registry.npmjs.org/@anthropic-ai/claude-code/latest | jq -r .version
```

`jq` がない場合:

```bash
nix-shell -p jq
```

## 2. Nix 用 hash を取得する

Codex の例:

```bash
nix store prefetch-file --json \
  https://registry.npmjs.org/@openai/codex/-/codex-0.160.0-linux-x64.tgz
```

Claude Code の例:

```bash
nix store prefetch-file --json \
  https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/2.1.287/linux-x64/claude
```

出力の `"hash": "sha256-..."` を使います。npm registry の `integrity` ではなく、Nix が返す `hash` を使うのがポイントです。

## 3. overlay を編集する

編集対象:

```bash
~/nixos_home/overlays/ai-agents.nix
```

Codex:

```nix
codexVersion = "0.160.0";
```

```nix
hash = "sha256-N6QdYcM5kYK4xye3cJDMehVmvYSdDwkHCgu8b+xMWNw=";
```

Claude Code:

```nix
claudeCodeVersion = "2.1.287";
```

```nix
hash = "sha256-OSBImlEJz/V4aho5LCUndAj/Irx5bV7bnBamDloXGPA=";
```

## 4. ビルド確認する

Codex:

```bash
nix build ~/nixos_home#homeConfigurations.yujif1aero.pkgs.codex --no-link --print-out-paths
```

Claude Code:

```bash
nix build ~/nixos_home#homeConfigurations.yujif1aero.pkgs.claude-code --no-link --print-out-paths
```

`--no-link` は `result` シンボリックリンクを作らないための確認用オプションです。`--print-out-paths` は成果物の `/nix/store/...` パスを表示するためのものです。どちらも必須ではありません。

## 5. Home Manager を反映する

```bash
cd ~/nixos_home
nix run nixpkgs#home-manager -- switch --flake ~/nixos_home#yujif1aero
```

反映後:

```bash
codex --version
claude --version
```

## 注意点

`~/nixos_home` は Git flake repo なので、flake で参照しているファイルが削除状態や未追跡状態だと Nix 評価が失敗することがあります。

たとえば `agent.nix` が削除状態になっていると、次のようなエラーで Codex/Claude のビルド確認前に止まります。

```text
error: path '/nix/store/...-source/agent.nix' does not exist
```

その場合は、`agent.nix` の削除状態を先に解消してから `nix build` または `home-manager switch` を実行します。

## 参照 URL

- Codex latest: https://registry.npmjs.org/@openai/codex/latest
- Claude Code latest: https://registry.npmjs.org/@anthropic-ai/claude-code/latest
