{
  appimageTools,
  fetchurl,
  lib,
  ruffle,
  stdenv,
  autoPatchelfHook,
  fontconfig,
  vulkan-loader,
  libGL,
  zlib,
  openssl,
  alsa-lib,
  udev,
  libxkbcommon,
  wayland,
}:

let
  pname = "ruffle-artix";
  version = "5.6.1";
  aquastar = "1.0.5";

  sources = {
    "x86_64-linux" = {
      name = "aquastar-neo_${aquastar}_amd64.AppImage";
      hash = "sha256-NQau8ADbk+YLVewWq4peM7QlkFoLHMIqirta3PkxIC4=";
    };
  };

  appimage = sources.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/aquaspy/AquaStar/releases/download/neo-v${aquastar}/${appimage.name}";
    inherit (appimage) hash;
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  ruffle-artix = "${appimageContents}/usr/lib/AquaStar NEO/players/ruffle-artix-${version}/ruffle_desktop";
in
stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
    zlib
    openssl
    alsa-lib
    udev
  ];

  runtimeDependencies = [
    libxkbcommon
    wayland
    libGL
    vulkan-loader
  ];

  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p \
      $out/bin \
      $out/share/applications

    # Preserve the complete extracted Artix Ruffle player.
    install -Dm755 \
      ${ruffle-artix} \
      $out/bin/ruffle-artix

    cp -r ${ruffle}/share/icons $out/share/

    install -Dm444 \
      ${ruffle}/share/applications/rs.ruffle.Ruffle.desktop \
      $out/share/applications/rs.ruffle.Ruffle.desktop

    substituteInPlace \
      $out/share/applications/rs.ruffle.Ruffle.desktop \
      --replace-fail \
      'Exec=ruffle %u' \
      "Exec=$out/bin/ruffle-artix"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/aquaspy/AquaStar";
    downloadPage = "https://github.com/aquaspy/AquaStar/releases";
    changelog = "https://github.com/aquaspy/AquaStar/releases/tag/neo-v${aquastar}";

    platforms = builtins.attrNames sources;

    mainProgram = pname;
    sourceProvenance = lib.sourceTypes.binaryNativeCode;
    maintainers = [ lib.maintainers.notawyvern ];

    license = with lib.licenses; [
      asl20
      mit
      bsd0
      bsd2
      bsd3
      cc0
      isc
      unlicense
      zlib
      mpl20
      unfree
    ];
  };
}
