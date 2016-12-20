#!/usr/bin/env bash

LATEST_TAG=$(git tag -l | tail -n 1)
MACOS_VERSION=$(sw_vers -productVersion)
ZIP="mmd-$LATEST_TAG-macOS$MACOS_VERSION+.zip"
TMP_DIR=$(mktemp -d)

function cleanup {
  echo "Removing temporary directory: $TMP_DIR."
  rm -rf $TMP_DIR

}

trap cleanup EXIT

git reset --hard && git clean -xdf
pyinstaller --clean --onefile mmd
cd dist
cp -r ../darwin .
zip -r $ZIP mmd darwin/
cp $ZIP $TMP_DIR
cd ..
git reset --hard && git clean -xdf
mv $TMP_DIR/$ZIP .
