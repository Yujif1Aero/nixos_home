final: prev:

let
  inherit (prev) lib;

  codexVersion = "0.154.0";
  codexPlatform = "x86_64-unknown-linux-musl";

  claudeCodeVersion = "2.1.273";
in
{
  codex = prev.stdenv.mkDerivation {
    pname = "codex";
    version = codexVersion;

    src = prev.fetchurl {
      url = "https://registry.npmjs.org/@openai/codex/-/codex-${codexVersion}-linux-x64.tgz";
      hash = "sha256-4nyDpJ5gMWhe5/lWwSqtXxZITTqAGB3T/qkw+5azgys=";
    };

    sourceRoot = "package";
    nativeBuildInputs = [ prev.makeWrapper ];
    dontPatchELF = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/lib/codex
      cp -R vendor $out/lib/codex/

      chmod +x $out/lib/codex/vendor/${codexPlatform}/bin/codex
      chmod +x $out/lib/codex/vendor/${codexPlatform}/bin/codex-code-mode-host

      makeWrapper $out/lib/codex/vendor/${codexPlatform}/bin/codex $out/bin/codex \
        --set DISABLE_AUTOUPDATER 1 \
        --prefix PATH : ${lib.makeBinPath [ prev.bubblewrap ]}

      ln -s $out/lib/codex/vendor/${codexPlatform}/bin/codex-code-mode-host \
        $out/bin/codex-code-mode-host

      runHook postInstall
    '';

    meta = {
      description = "Codex CLI";
      homepage = "https://github.com/openai/codex";
      license = lib.licenses.asl20;
      platforms = [ "x86_64-linux" ];
      mainProgram = "codex";
    };
  };

  claude-code = prev.stdenv.mkDerivation {
    pname = "claude-code";
    version = claudeCodeVersion;

    src = prev.fetchurl {
      url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${claudeCodeVersion}/linux-x64/claude";
      hash = "sha256-bHUuLMfBEMnfFfJtjRNNQ4xa6V29YQ78GjCL9/nF9sE=";
    };

    dontUnpack = true;
    nativeBuildInputs = [ prev.makeWrapper ];
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 $src $out/bin/.claude-wrapped
      makeWrapper $out/bin/.claude-wrapped $out/bin/claude \
        --argv0 claude \
        --set DISABLE_AUTOUPDATER 1 \
        --set DISABLE_INSTALLATION_CHECKS 1 \
        --run 'export DISABLE_NON_ESSENTIAL_MODEL_CALLS=''${DISABLE_NON_ESSENTIAL_MODEL_CALLS-1}' \
        --prefix PATH : ${lib.makeBinPath [ prev.bubblewrap prev.socat ]}

      runHook postInstall
    '';

    meta = {
      description = "Claude Code";
      homepage = "https://github.com/anthropics/claude-code";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      mainProgram = "claude";
    };
  };
}
