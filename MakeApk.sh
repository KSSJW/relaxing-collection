#!/bin/bash

flutter build apk --release --split-per-abi
mv build/app/outputs/apk/release/app-*.apk .
mv app-arm64-v8a-release.apk RelaxingCollection-android-arm64-v8a.apk
mv app-armeabi-v7a-release.apk RelaxingCollection-android-armeabi-v7a.apk
mv app-x86_64-release.apk RelaxingCollection-android-x86_64.apk