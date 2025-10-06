# Dotfiles

Personal dotfiles managed with GNU Stow for macOS.

## Setup

1. Install dependencies:
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install GNU Stow
brew install stow

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

2. Clone this repository:
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

3. Use Stow to create symlinks:
```bash
# Install all configurations
stow */

# Or install specific configurations
stow git
stow zsh
stow brew
```

## Structure

- `git/` - Git configuration
- `zsh/` - Zsh and Oh My Zsh configuration with Powerlevel10k
- `brew/` - Homebrew bundle file
- `macos/` - macOS system defaults
- `fonts/` - Font installation scripts

## Usage

To add new dotfiles, create them in the appropriate package directory and run `stow <package-name>`.

To remove a package: `stow -D <package-name>`

TODO use actual .zshrc from my user. also install the alt+c software for browsing the file system from the terminal.