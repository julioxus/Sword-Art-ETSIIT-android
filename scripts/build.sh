#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/Users/jmartinez/repos/Sword-Art-ETSIIT-android"

# ---- Environment setup ----
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"

echo "=== Sword Art ETSIIT Android Build ==="
echo "JAVA_HOME: $JAVA_HOME"
echo "java: $(java -version 2>&1 | head -1)"
echo "Node: $(node --version)"
echo ""

cd "$PROJECT_DIR"

# ---- Step 1: Sync game assets ----
echo "--- Syncing game assets ---"
bash scripts/sync-www.sh
echo ""

# ---- Step 2: Build ----
BUILD_TYPE="${1:-release}"

if [ "$BUILD_TYPE" = "release" ]; then
    echo "--- Building Release AAB ---"
    cordova build android --release -- --packageType=bundle

    AAB_PATH="$PROJECT_DIR/platforms/android/app/build/outputs/bundle/release/app-release.aab"
    if [ -f "$AAB_PATH" ]; then
        echo ""
        echo "=== BUILD SUCCESSFUL ==="
        echo "AAB: $AAB_PATH"
        echo "Size: $(du -h "$AAB_PATH" | cut -f1)"
        echo ""
        echo "Para firmar el AAB para Play Store:"
        echo "  jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \\"
        echo "    -keystore tu-keystore.jks $AAB_PATH tu-alias"
    else
        echo "ERROR: AAB not found at $AAB_PATH"
        exit 1
    fi

elif [ "$BUILD_TYPE" = "debug" ]; then
    echo "--- Building Debug APK ---"
    cordova build android --debug

    APK_PATH="$PROJECT_DIR/platforms/android/app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$APK_PATH" ]; then
        echo ""
        echo "=== BUILD SUCCESSFUL ==="
        echo "APK: $APK_PATH"
        echo "Size: $(du -h "$APK_PATH" | cut -f1)"
        echo ""
        echo "Para instalar en dispositivo conectado:"
        echo "  adb install $APK_PATH"
    else
        echo "ERROR: APK not found at $APK_PATH"
        exit 1
    fi

else
    echo "Uso: $0 [debug|release]"
    exit 1
fi
