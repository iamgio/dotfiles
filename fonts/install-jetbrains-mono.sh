#!/usr/bin/env bash

# JetBrains Mono Font Installation Script
# This script downloads and installs JetBrains Mono font family

set -e

FONT_DIR="$HOME/Library/Fonts"
TEMP_DIR="/tmp/jetbrains-mono"
DOWNLOAD_URL="https://github.com/JetBrains/JetBrainsMono/releases/latest/download/JetBrainsMono.zip"

echo "🔤 Installing JetBrains Mono font..."

# Create temporary directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download the font
echo "⬇️  Downloading JetBrains Mono..."
curl -L "$DOWNLOAD_URL" -o "JetBrainsMono.zip"

# Extract the font
echo "📦 Extracting font files..."
unzip -q "JetBrainsMono.zip"

# Install fonts
echo "💾 Installing fonts..."
mkdir -p "$FONT_DIR"

# Install TTF fonts
find . -name "*.ttf" -exec cp {} "$FONT_DIR" \;

# Clean up
cd ~
rm -rf "$TEMP_DIR"

echo "✅ JetBrains Mono font installed successfully!"
echo "📍 Font files are located in: $FONT_DIR"
echo "🔄 You may need to restart applications to see the new font."

# Optional: Install via Homebrew if available
if command -v brew >/dev/null 2>&1; then
    echo ""
    echo "🍺 Alternative: You can also install JetBrains Mono via Homebrew:"
    echo "   brew install --cask font-jetbrains-mono"
    echo "   brew install --cask font-jetbrains-mono-nerd-font"
fi