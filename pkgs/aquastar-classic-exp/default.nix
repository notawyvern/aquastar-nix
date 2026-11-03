{
  appimageTools,
  fetchurl,
  lib,
  stdenv,
}:

let
  pname = "aquastar-classic-exp";
  vNumber = "2.1.0";
  version = "electron-experimental-2026.10.28-a45c504";

  sources = {
    "x86_64-linux" = {
      name = "AquaStar-${vNumber}-electron-experimental-a45c504-x86_64.AppImage";
      hash = "sha256-MtSkD0RYLdXbFTpmt1DvKrqPhdeNf3caRP7NSPSmNC0=";
    };
  };
  appimage = sources.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/aquaspy/AquaStar/releases/download/${version}/${appimage.name}";
    inherit (appimage) hash;
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
      ${appimageContents}/usr/share/icons/hicolor/512x512/apps/aquastar.png \
      $out/share/icons/hicolor/512x512/apps/aquastar.png

    substituteInPlace \
      $out/share/applications/aquastar.desktop \
      --replace-fail \
      'Exec=AppRun --no-sandbox %U' \
      Exec=$out/bin/aquastar-classic-exp
  '';

  meta = {
    homepage = "https://github.com/aquaspy/AquaStar";
    downloadPage = "https://github.com/aquaspy/AquaStar/releases";
    changelog = "https://github.com/aquaspy/AquaStar/releases/tag/${version}";

    platforms = builtins.attrNames sources;

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
