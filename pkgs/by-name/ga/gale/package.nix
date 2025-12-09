{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  jq,
  moreutils,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,

  glib-networking,
  libsoup_3,
  openssl,
  webkitgtk_4_1,
}:
let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gale";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "Kesomannen";
    repo = "gale";
    tag = finalAttrs.version;
    hash = "sha256-SnPYuMYdoY69CWMztuDxw0ohRDU2uECNhBs46hLg+eA=";
  };

  postPatch = ''
    jq '.bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 1;
    hash = "sha256-DYhPe59qfsSjyMIN31RL0mrHfmE6/I1SF+XutettkO8=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-tWQRYD6hMU7cvtelGryLdpfoEnUKYt7yYNwHTFZ4pLw=";

  nativeBuildInputs = [
    jq
    moreutils
    (pnpmConfigHook.override { inherit pnpm; })
    nodejs
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking # needed to load icons
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight Thunderstore client";
    homepage = "https://github.com/Kesomannen/gale";
    license = lib.licenses.gpl3Only;
    mainProgram = "gale";
    maintainers = with lib.maintainers; [
      tomasajt
      notohh
    ];
    platforms = lib.platforms.linux;
  };
})
