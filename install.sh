#!/usr/bin/env bash

# Dotfiles Installation Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

IS_MACOS=false
if [[ "$OSTYPE" == "darwin"* ]]; then
    IS_MACOS=true
fi

# Helper functions
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if running on macOS
if [[ "$IS_MACOS" != true ]]; then
    print_warning "This script is designed for macOS."
fi

# Welcome message
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                      Dotfiles Setup                      ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Ask for confirmation
read -p "This will set up your dotfiles and install various tools. Continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Setup cancelled."
    exit 0
fi

print_step "Starting dotfiles setup..."

# Check if we're in the dotfiles directory
if [[ ! -f "README.md" ]] || [[ ! -d "git" ]]; then
    print_error "Please run this script from the dotfiles directory."
    exit 1
fi

# Install Xcode Command Line Tools if not present.
if ! command -v xcode-select >/dev/null 2>&1 && [[ "$IS_MACOS" == true ]]; then
    print_step "Installing Xcode Command Line Tools..."
    print_warning "This may take a few minutes and will open a dialog box."
    xcode-select --install
    
    # Wait for installation to complete
    print_step "Waiting for Xcode Command Line Tools installation to complete..."
    until command -v xcode-select >/dev/null 2>&1; do
        print_step "Still installing... Please complete the installation dialog and wait."
        sleep 5
    done
    print_success "Xcode Command Line Tools installed"
else
    print_success "Xcode Command Line Tools already installed"
fi

# Install Homebrew if not present
if ! command -v brew >/dev/null 2>&1; then
    print_step "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ "$IS_MACOS" == true ]]; then
        BREW_HOME="/opt/homebrew"
    else
        BREW_HOME="/home/linuxbrew/.linuxbrew"
    fi

    # Add Homebrew to PATH
    echo 'eval "$('"$BREW_HOME"'/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$("$BREW_HOME/bin/brew" shellenv)"
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
fi

# Install Homebrew packages
print_step "Installing Homebrew packages..."
if [[ -f "brew/Brewfile" ]]; then
    brew bundle --file=brew/Brewfile
    print_success "Homebrew packages installed"
else
    print_warning "Brewfile not found, skipping package installation"
fi

# Install Oh My Zsh if not present
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    print_step "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
else
    print_success "Oh My Zsh already installed"
fi

# Install Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
    print_step "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    print_success "Powerlevel10k installed"
else
    print_success "Powerlevel10k already installed"
fi

# Install Zsh plugins
print_step "Installing Zsh plugins..."
ZSH_CUSTOM_PLUGINS="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting"
fi

print_success "Zsh plugins installed"

# Backup existing dotfiles
print_step "Backing up existing dotfiles..."
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

files_to_backup=(
    ".zshrc"
    ".p10k.zsh"
    ".config/git/config"
    ".config/git/gitignore_global"
)

for file in "${files_to_backup[@]}"; do
    if [[ -f "$HOME/$file" ]] || [[ -d "$HOME/$file" ]]; then
        print_warning "Backing up existing $file"
        cp -r "$HOME/$file" "$backup_dir/" 2>/dev/null || true
    fi
done

# Use Stow to create symlinks
print_step "Creating symlinks with Stow..."

packages=("git" "zsh")
for package in "${packages[@]}"; do
    if [[ -d "$package" ]]; then
        print_step "Stowing $package..."
        stow "$package"
        print_success "$package configuration linked"
    fi
done

# Set macOS defaults
print_step "Setting macOS defaults..."
if [[ -f "macos/set-defaults.sh" ]]; then
    print_warning "This will change your macOS system settings. Continue? [y/N]"
    read -p "" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        chmod +x macos/set-defaults.sh
        macos/set-defaults.sh
        print_success "macOS defaults applied"
    else
        print_warning "Skipped macOS defaults"
    fi
else
    print_warning "macOS defaults script not found"
fi

# Set up iTerm2 configuration
if [[ "$IS_MACOS" == true ]]; then
    print_step "Setting up iTerm2 configuration..."

    ITERM_CONFIG_DIR="$(pwd)/iterm2"

    # Create iTerm2 preferences directory if it doesn't exist
    ITERM_PREFS_DIR="$HOME/Library/Preferences"
    mkdir -p "$ITERM_PREFS_DIR"

    # Set iTerm2 to use custom preferences directory
    print_step "Configuring iTerm2 to load preferences from dotfiles..."

    # Tell iTerm2 to use our custom preferences folder
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$ITERM_CONFIG_DIR"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

    # Install shell integration
    print_step "Installing iTerm2 shell integration..."
    curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh

    print_success "iTerm2 configuration setup complete!"
    print_warning "Please restart iTerm2 to apply all changes."
fi

# Final steps
print_step "Final setup steps..."

# Make sure the shell is set to zsh
if [[ "$SHELL" != "$(which zsh)" ]]; then
    print_step "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
    print_success "Default shell set to zsh"
fi

# Completion message
echo
echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                      Setup Complete!                      ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

print_success "Dotfiles setup completed successfully!"
echo
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Configure Powerlevel10k by running: p10k configure"
echo "3. Update your Git configuration in ~/.config/git/config"
echo "4. Customize your setup as needed"
echo
echo "Backup of your previous dotfiles: $backup_dir"
echo
print_warning "Some changes may require a system restart to take effect."