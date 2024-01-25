{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, stdenvNoCC
, fetchurl
, innoextract
, sfextract
, webkitgtk_4_1
}:

buildDotnetModule rec {
  pname = "linux-creator-companion";
  version = "2.2.3.1";

  src = fetchFromGitHub {
    owner = "RinLovesYou";
    repo = "LinuxCreatorCompanion";
    rev = version;
    hash = "sha256-uhem64YjvG5PK6e9635gg5vtrBIxJJE4uNds/MwLBRo=";
  };

  vccLibs = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "VRChat-Creator-Companion-deps";
    version = "2.2.3";

    src = fetchurl {
      url = "https://vrcpm.vrchat.cloud/vcc/Builds/2.2.3/VRChat_CreatorCompanion_Setup_2.2.3.exe";
      hash = "sha256-fdbZkLuT4AueQoEYyEaHIcEGQ+xRlfD3/FtUY7lVNkE=";
      curlOptsList = ["--user-agent" "Nixpkgs/${lib.version}"];
    };

    nativeBuildInputs = [innoextract];
    buildInputs = [sfextract];

    unpackCmd = ''
      innoextract --extract $curSrc
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      sfextract CreatorCompanion.exe --output $out
      cp -r WebApp Tools Templates $out/

      runHook postInstall
    '';

    meta = with lib; {
      license = licenses.unfree;
      maintainers = with maintainers; [ Scrumplex ];
    };
  });

  preBuild = ''
    mkdir -p Libs
    cp $vccLibs/CreatorCompanion.dll $vccLibs/vcc-lib.dll $vccLibs/vpm-core-lib.dll Libs/
  '';

  postInstall = ''
    cp -r $vccLibs/WebApp $vccLibs/Tools $vccLibs/Templates $out/lib/$pname/
  '';

  makeWrapperArgs = [
    "--chdir ${placeholder "out"}/lib/${pname}"
  ];

  nugetDeps = ./deps.nix;
  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;
  executables = ["LinuxCreatorCompanion"];

  runtimeDeps = [webkitgtk_4_1];

  dontStrip = true;

  meta = with lib; {
    description = "Linux wrapper around the VRChat Creator Companion";
    homepage = "https://github.com/RinLovesYou/LinuxCreatorCompanion";
    # While LinuxCreatorCompanion is MIT licensed, it requires unfree components to run
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
    mainProgram = "linux-creator-companion";
    platforms = platforms.linux;
  };
}
