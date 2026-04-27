#!/bin/bash

flutter build linux --release --target-platform=linux-x64
rm build/linux/x64/release/bundle/data/flutter_assets/kernel_blob.bin
mv build/linux/x64/release/bundle/ RelaxingCollection.AppDir/
chmod +x RelaxingCollection.AppDir/bundle/relaxing_collection
chmod +x RelaxingCollection.AppDir/AppRun
appimagetool RelaxingCollection.AppDir RelaxingCollection-linux-x86_64.AppImage
rm -rf RelaxingCollection.AppDir/bundle/