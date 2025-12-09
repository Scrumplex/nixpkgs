{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
}:
let
  pnpm = pnpm_9;
in
buildNpmPackage (finalAttrs: {
  pname = "serve";
  version = "14.2.4";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "serve";
    tag = finalAttrs.version;
    hash = "sha256-QVbau4MrpgEQkwlWx4tU9H93zdM0mSZgIzXpjHRM5mk=";
  };

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 2;
    hash = "sha256-IJMu0XHwEn2TZP/He79FFGl/PeXOCTD51lIgmImpyKo=";
  };

  npmConfigHook = (pnpmConfigHook.override { inherit pnpm; });

  dontNpmBuild = true;

  # takes too long to finish
  dontNpmPrune = true;

  meta = {
    description = "Static file serving and directory listing";
    homepage = "https://github.com/vercel/serve";
    downloadPage = "https://github.com/vercel/serve/releases";
    changelog = "https://github.com/vercel/serve/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "serve";
  };
})
