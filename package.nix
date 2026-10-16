{
  appimageTools,
  fetchurl,
  lib,
}:

let
  pname = "AquaStar";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/aquaspy/AquaStar/releases/download/v${version}/AquaStar-${version}.AppImage";
    hash = "sha256-mcGxNtMKItQAhyAKQOzoVndDNvr71bQTb+6L9zWNirc=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  passthru = {
    inherit appimageContents;
  };

  extraInstallCommands = ''
    install -Dm444 \
    ${appimageContents}/aquastar.desktop \
      -t $out/share/applications/

    install -Dm444 \
    ${appimageContents}/resources/app/Icon/Icon.png \
      $out/share/icons/hicolor/256x256/apps/aquastar.png

    substituteInPlace \
      $out/share/applications/aquastar.desktop \
      --replace-fail \
      'Exec=AppRun --no-sandbox %U' Exec=$out/bin/AquaStar\ %U
  '';
  meta = {
    homepage = "https://github.com/aquaspy/AquaStar";
    downloadPage = "https://github.com/aquaspy/AquaStar/releases";
    changelog = "https://github.com/aquaspy/AquaStar/releases/tag/v${version}";
    platforms = [ "x86_64-linux" ];

    mainProgram = pname;
    sourceProvenance = lib.sourceTypes.binaryNativeCode;
    maintainers = [ lib.maintainers.notawyvern ];

    license = with lib.licenses; [
      /*
        licenses were discovered searching
        the keyword "license" in the repo. flash
        player, bundled, is certainly proprietary,
        while aqlite's one is unknown.
      */
      unfree
      asl20
      mit
    ];
  };
}
