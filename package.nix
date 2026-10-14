{
  appimageTools,
  fetchurl,
  lib,
}:

let
  pname = "AquaStar";
  version = "v2.0.0";

  src = fetchurl {
    url = "https://github.com/aquaspy/AquaStar/releases/download/${version}/AquaStar-2.0.0.AppImage";
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
    ${appimageContents}/aquastar.png \
      -t $out/share/icons/hicolor/512x512/apps/

    substituteInPlace \
      $out/share/applications/aquastar.desktop \
      --replace-fail \
      'Exec=AppRun --no-sandbox %U' Exec=$out/bin/AquaStar\ %U
  '';

  meta = {
    description = "AquaStar";
    homepage = "https://github.com/aquaspy/AquaStar";
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;

    # The licensing is to affect the building, considering
    # the bundled Flash, not an actual statement about
    # the project. AquaStar is licensed under MIT and all
    # rights belong to aquaspy, its developer.
    license = lib.licenses.unfree;
  };
}
