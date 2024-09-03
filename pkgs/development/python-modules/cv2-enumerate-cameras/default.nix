{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cv2-enumerate-cameras";
  version = "1.1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chinaheyu";
    repo = "cv2_enumerate_cameras";
    rev = "v${version}";
    hash = "sha256-jKulhnAmrHE6QYCHhg4gSDZJdiP7xWI8y5zK+/D/E3c=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "cv2_enumerate_cameras"
  ];

  meta = {
    description = "Retrieve the connected camera's name, VID, PID, and the corresponding OpenCV index";
    homepage = "https://github.com/chinaheyu/cv2_enumerate_cameras";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
}
