#!/usr/bin/env bash

echo "Windows version number (i.e. 7, 8.1, 10...): "
read WINNUMBER

LATEST_TAG=$(git tag -l | tail -n 1)
ZIP="mmd-$LATEST_TAG-win$WINNUMBER+.zip"
TMP_DIR=$(mktemp -d)

function cleanup {
  echo "Removing temporary directory: $TMP_DIR."
  rm -rf $TMP_DIR

}

trap cleanup EXIT

git reset --hard && git clean -xdf
pyinstaller --clean --onefile mmd
cd dist
cp -r ../win32 .
zip -r $ZIP mmd win32/
cp $ZIP $TMP_DIR
cd ..
git reset --hard && git clean -xdf
mv $TMP_DIR/$ZIP .
