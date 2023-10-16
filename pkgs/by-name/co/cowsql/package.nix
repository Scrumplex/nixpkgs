{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libuv
, raft-cowsql
, sqlite
, incus
, gitUpdater
}:

stdenv.mkDerivation {
  pname = "cowsql";
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "cowsql";
    repo = "cowsql";
    # this project seems to delete tags, use commit ref instead
    rev = "a1d49d0d3e40b32ba655fffe14b7669c2aa1bcec"; # refs/tags/v1.15.3
    hash = "sha256-+za3pIcV4BhoImKvJlKatCK372wL4OyPbApQvGxGGGk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libuv
    raft-cowsql.dev
    sqlite
  ];

  enableParallelBuilding = true;

  doCheck = true;

  outputs = [ "dev" "out" ];

  passthru = {
    tests = {
      inherit incus;
    };

    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    description = "Embeddable, replicated and fault tolerant SQL engine";
    homepage = "https://github.com/cowsql/cowsql";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ adamcstephens ];
    platforms = platforms.unix;
  };
}
