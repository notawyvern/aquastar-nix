{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  stdenv,
}:

let
  pname = "aquastar-neo";
  version = "1.0.0";

  sources = {
    "x86_64-linux" = {
      name = "aquastar-neo_${version}_amd64.AppImage";
      hash = "sha256-YsCaJ/iBFJZzYfcCZsUoGng9i/OLvPGdIMIU2JnKjis=";
    };
  };
  appimage = sources.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/aquaspy/AquaStar/releases/download/neo-v${version}/${appimage.name}";
    inherit (appimage) hash;
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # so we have fonts on the launcher
  profile = ''
    export FONTCONFIG_FILE=/etc/fonts/fonts.conf
  '';

  passthru = {
    inherit appimageContents;
  };

  extraInstallCommands = ''
    install -Dm444 \
      ${appimageContents}/usr/share/applications/AquaStar\ NEO.desktop \
      -t $out/share/applications/

    install -Dm444 \
      ${appimageContents}/AquaStar\ NEO.png \
      $out/share/icons/hicolor/512x512/apps/aquastar-neo.png

    substituteInPlace \
      $out/share/applications/AquaStar\ NEO.desktop \
      --replace-fail \
      Exec=aquastar-neo \
      Exec=$out/bin/aquastar-neo
  '';

  meta = {
    homepage = "https://github.com/aquaspy/AquaStar";
    downloadPage = "https://github.com/aquaspy/AquaStar/releases";
    changelog = "https://github.com/aquaspy/AquaStar/releases/tag/v${version}";

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
