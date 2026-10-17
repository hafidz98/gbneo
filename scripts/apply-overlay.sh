#!/bin/bash
# GB Neo: apply our overlay onto a fresh Gadgetbridge checkout.
set -e
GB_DIR="$1"
OVERLAY_DIR="$2"
# compileSdk 37 (unreleased) -> 36 for public CI runners
sed -i 's/release(37)/release(36)/' "$GB_DIR/app/build.gradle"
# copy se1/ overlay package
SE1_DST="$GB_DIR/app/src/main/java/nodomain/freeyourgadget/gadgetbridge/activities/se1"
mkdir -p "$SE1_DST"
cp -r "$OVERLAY_DIR/se1/." "$SE1_DST/"
echo "overlay applied"
