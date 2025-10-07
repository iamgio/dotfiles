#!/usr/bin/env bash

# Dock Setup Script
# This script configures the macOS dock with a custom set of applications

# List of applications to add to dock (in order)
dock_apps=(
    "/System/Applications/Mail.app"
    "/Applications/Safari.app"
    "/Applications/Telegram.app"
    "/Applications/Spotify.app"
    "/Applications/WhatsApp.app"
    "/System/Applications/Notes.app"
    "/Applications/Trello.app"
    "/Applications/Microsoft To Do.app"
    "/Applications/ChatGPT.app"
    "/Applications/IntelliJ IDEA.app"
    "/Applications/Figma.app"
    "/Applications/iTerm.app"
    "/Applications/Google Chrome.app"
)

echo "Setting up dock..."

# Function to add app to dock
add_app_to_dock() {
    local app_path="$1"
    if [ -d "$app_path" ]; then
        defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app_path</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
        echo "✓ Added $(basename "$app_path" .app) to dock"
    else
        echo "⚠ Warning: $(basename "$app_path" .app) not found at $app_path"
    fi
}

# Clear all dock items except Finder and Trash
defaults write com.apple.dock persistent-apps -array

# Remove "Downloads" directory from Dock
defaults write com.apple.dock persistent-others -array

# Add each app to dock
echo "Adding applications to dock..."
for app_path in "${dock_apps[@]}"; do
    add_app_to_dock "$app_path"
done

# Restart Dock to apply changes
echo "Restarting Dock..."
killall Dock

echo "Dock setup complete!"