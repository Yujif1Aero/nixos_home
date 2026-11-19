# USER setting nixos
`nix run nixpkgs#home-manager -- switch --flake .#yujif1aero`

# packages update
`nix flake update`



# codex / claude-code のバージョンと hash の調べ方

`codex` と `claude` は nixpkgs ではなく `overlays/ai-agents.nix` で固定している。
更新には「最新バージョン番号」と「その成果物の Nix hash」の 2 つが要る。
手順の全体は `2026-10-02-codex-claude-update.md` を見ること。ここは調べ方だけを書く。

## 1. 最新バージョンを調べる

このマシンは Claude Code の権限設定で `curl` が deny なので、上記の手順書にある
`curl | jq` は通らない。`nix store prefetch-file` で JSON を取って読む。

```bash
nix store prefetch-file --json --name codex-latest.json \
  https://registry.npmjs.org/@openai/codex/latest
nix store prefetch-file --json --name claude-latest.json \
  https://registry.npmjs.org/@anthropic-ai/claude-code/latest
```

それぞれ出力の `storePath` を読む（`jq` はこのマシンに入っていないので python3 で）。

```bash
python3 -c "import json,sys; print(json.load(open(sys.argv[1]))['version'])" \
  /nix/store/<hash>-codex-latest.json
```

## 2. Nix hash を調べる

バージョンが分かったら、overlay の `src.url` と同じ URL をそのまま prefetch する。
出力の `hash` がそのまま `hash = "...";` に入る値。npm registry の `integrity` ではない。

```bash
# codex
nix store prefetch-file --json \
  https://registry.npmjs.org/@openai/codex/-/codex-<VERSION>-linux-x64.tgz

# claude-code
nix store prefetch-file --json \
  https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/<VERSION>/linux-x64/claude
```

`--executable` は付けないこと。`overlays/ai-agents.nix` の `claude-code` は素の
`prev.fetchurl`（`executable = true` なし）なので、flat 形式の hash でないと
`hash mismatch` でビルドが落ちる。`install -Dm755` で実行権限を付けるのは
installPhase 側の仕事。

## 3. 取った hash が正しい形式か確かめる

書き換える前に、**いま overlay に入っている古いバージョンの URL** を同じコマンドで
prefetch して、ファイルに書いてある hash と一致するか見る。一致すれば取り方は正しい。
ビルドを 1 回失敗させてエラーに出る `got:` を読む方法もあるが、こちらが先。

```bash
# 例: 2026-11-19 の更新前に実施
nix store prefetch-file --json \
  https://registry.npmjs.org/@openai/codex/-/codex-0.162.0-linux-x64.tgz
#   -> sha256-29NC562JbVPbtQXpJvG4IxS3mp0z4gmwt2Fs7WsGyYM=  (overlay の値と一致)
```

## 実績

| 日付 | codex | claude-code |
|---|---|---|
| 2026-10-02 | 0.160.0 | 2.1.287 |
| 2026-11-19 | 0.170.0 `sha256-Z8S8zOjmw6K5rg5YZ1Dg76x+C4zYXmtHNK1HQxfSzDI=` | 2.1.328 `sha256-qYLTgDC5fnUISK3Sy7LfbZpw1VRKIsqbIWo0m6JYZeg=` |

## 確認とロールバック

```bash
nix build .#homeConfigurations.yujif1aero.pkgs.codex       --no-link --print-out-paths
nix build .#homeConfigurations.yujif1aero.pkgs.claude-code --no-link --print-out-paths
# 出た store path の bin/ を直接叩けば、switch 前に版を確認できる
```

`switch` を戻すときは世代を一覧して、ひとつ前を activate する。

```bash
home-manager generations
/nix/store/<...>-home-manager-generation/activate
```
