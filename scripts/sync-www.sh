#!/usr/bin/env bash
set -euo pipefail

GAME_DIR="/Users/jmartinez/repos/Sword-Art-ETSIIT"
WWW_DIR="/Users/jmartinez/repos/Sword-Art-ETSIIT-android/www"

echo "=== Syncing game assets to www/ ==="

# Clear existing www content (keep the directory)
rm -rf "${WWW_DIR:?}"/*

# Copy core HTML entry point
cp "$GAME_DIR/index.html" "$WWW_DIR/"

# Copy game directories
rsync -a --delete "$GAME_DIR/js/" "$WWW_DIR/js/"
rsync -a --delete "$GAME_DIR/data/" "$WWW_DIR/data/"
rsync -a --delete "$GAME_DIR/fonts/" "$WWW_DIR/fonts/"
rsync -a --delete "$GAME_DIR/img/" "$WWW_DIR/img/"
rsync -a --delete "$GAME_DIR/icon/" "$WWW_DIR/icon/"

# Copy audio - M4A ONLY (skip OGG to save ~167MB)
# RPG Maker MV uses M4A on mobile (Android/iOS) automatically
rsync -a --delete --include='*/' --include='*.m4a' --exclude='*' \
    "$GAME_DIR/audio/" "$WWW_DIR/audio/"

# Inject cordova.js script before the first <script> tag in index.html
sed -i '' 's|<script type="text/javascript" src="js/libs/pixi.js"></script>|<script type="text/javascript" src="cordova.js"></script>\
        <script type="text/javascript" src="js/libs/pixi.js"></script>|' "$WWW_DIR/index.html"

echo "=== Sync complete ==="
du -sh "$WWW_DIR"
