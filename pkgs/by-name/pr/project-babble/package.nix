{
  lib,
  python311,
}:

python311.pkgs.buildPythonApplication {
  pname = "project-babble";
  version = "2.0.5";
  pyproject = true;

  src = /home/scrumplex/Projects/ProjectBabble/.;
  # src = fetchFromGitHub {
  #   owner = "Scrumplex";
  #   repo = "ProjectBabble";
  #   rev = "f72259d3ebe95a0d6565e34f6c790175e9e1e884";
  #   hash = "sha256-bwFmXkn9nFGROZc49QRRK5Hc5WLO+6GaWz3rzHT8xS4=";
  # };

  build-system = [
    python311.pkgs.poetry-core
  ];

  dependencies = with python311.pkgs; [
    colorama
    cv2-enumerate-cameras
    numpy
    onnxruntime
    opencv4
    pyaudio
    pydantic_1
    pyserial
    pysimplegui
    python-osc
    requests
  ];

  pythonRelaxDeps = [
    "numpy"
    "pysimplegui"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'opencv-python = "^4.6.0.66"' 'opencv = "*"'
  '';

  meta = {
    description = "An open-source mouth tracking method for VR";
    homepage = "https://github.com/Project-Babble/ProjectBabble";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "project-babble";
  };
}
