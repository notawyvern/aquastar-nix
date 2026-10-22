{
  appimageTools,
  fetchurl,
  lib,
  stdenv,
}:

let
  pname = "AquaStar2";
  version = "2.1.0";

  sources = {
    "x86_64-linux" = {
      name = "AquaStar-${version}.AppImage";
      hash = "sha256-FVpTNk1xVU2pGRxml421MNLubBYMBEOp3Kw74RtTJ0M=";
    };
    "armv7l-linux" = {
      name = "AquaStar-${version}-armv7l.AppImage";
      hash = "sha256-6IyaiYAG9rJ4JHhtyfrATr+JxuNa2MfNueZenNx87gA=";
    };
    "i686-linux" = {
      name = "AquaStar-${version}-i386.AppImage";
      hash = "sha256-QCxXzeV3zBnI40xKt/CZQjgT/fGwMQn47IGinmDDDfo=";
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
      'Exec=AppRun --no-sandbox %U' \
      "Exec=$out/bin/AquaStar %U"
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
