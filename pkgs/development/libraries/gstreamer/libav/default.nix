{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, python3
, gstreamer
, gst-plugins-base
, gettext
, libav
}:

# Note that since gst-libav-1.6, libav is actually ffmpeg. See
# https://gstreamer.freedesktop.org/releases/1.6/ for more info.

stdenv.mkDerivation rec {
  pname = "gst-libav";
  version = "1.22.0";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-DkhAe0kFInomAhPb2oTLo4EvBTD8enW0OCkQLvgoEPE=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    python3
  ];

  buildInputs = [
    gstreamer
    gst-plugins-base
    libav
  ];

  mesonFlags = [
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  meta = with lib; {
    description = "FFmpeg/libav plugin for GStreamer";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
