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
cp -r darwin dist
zip -j -r $ZIP dist/mmd dist/darwin
cp $ZIP $TMP_DIR
git reset --hard && git clean -xdf
mv $TMP_DIR/$ZIP .
