{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
}:

buildDotnetModule {
  pname = "single-file-extractor";
  version = "0-unstable-2023-12-14";

  src = fetchFromGitHub {
    owner = "Droppers";
    repo = "SingleFileExtractor";
    rev = "eadc323085209acee75dd60964f409dde85d76a6";
    hash = "sha256-x61yqMmzU9l/JM23AwmnM2dhtnQLlPQQY8uBLAUeU80=";
  };

  postPatch = ''
    substituteInPlace src/SingleFileExtractor.CLI/SingleFileExtractor.CLI.csproj \
      --replace "net6.0" "net8.0"
    substituteInPlace src/SingleFileExtractor.Core/SingleFileExtractor.Core.csproj \
      --replace "netstandard2.1;netstandard2.0" "net8.0"
    substituteInPlace test/SingleFileExtractor.Core.Tests/SingleFileExtractor.Core.Tests.csproj \
      --replace "net6.0" "net8.0"

    rm src/SingleFileExtractor.Core/IsExternalInit.cs
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s SingleFileExtractor.CLI $out/bin/sfextract
  '';

  nugetDeps = ./deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  dotnetInstallFlags = [ "-p:TargetFramework=net8.0" ];

  executables = ["SingleFileExtractor.CLI"];

  meta = with lib; {
    description = "A tool for extracting contents (assemblies, configuration, etc.) from a single-file application to a directory, suitable for purposes like malware analysis";
    homepage = "https://github.com/Droppers/SingleFileExtractor/";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
    mainProgram = "sfextract";
    platforms = platforms.all;
  };
}
