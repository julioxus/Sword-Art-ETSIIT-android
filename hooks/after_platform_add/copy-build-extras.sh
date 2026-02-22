#!/usr/bin/env bash
# Hook: after_platform_add
# Copies build-extras.gradle to the Android platform directory
if [ "$CORDOVA_PLATFORMS" = "android" ]; then
    HOOK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
    TARGET="platforms/android/app/build-extras.gradle"
    echo "Copying build-extras.gradle to $TARGET"
    cp "$HOOK_DIR/build-extras.gradle" "$TARGET"
fi
