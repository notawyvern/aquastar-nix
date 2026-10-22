{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  stdenv,
}:

let
  pname = "AquaStar";
  version = "3.0.0-rc.6";

  sources = {
    "x86_64-linux" = {
      name = "AquaStar_${version}_amd64.AppImage";
      hash = "sha256-NCJPK92Bb9YEtnHBU6EnGC46kj9Qmiryb5Ppwm+JYco=";
    };
  };
  appimage = sources.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/aquaspy/AquaStar/releases/download/v${version}/${appimage.name}";
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
      ${appimageContents}/usr/share/applications/AquaStar.desktop \
      -t $out/share/applications/

    install -Dm444 \
      ${appimageContents}/AquaStar.png \
      $out/share/icons/hicolor/512x512/apps/aquastar-lite.png

    substituteInPlace \
      $out/share/applications/AquaStar.desktop \
      --replace-fail \
      Exec=aquastar-lite \
      Exec=$out/bin/AquaStar
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
