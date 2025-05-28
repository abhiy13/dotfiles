# Dotfiles

Cross-platform dotfiles setup for Unix systems with NvChad.

## Installation

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x setup.sh
./setup.sh
```

## What's Included

- Zsh with Oh My Zsh
- Starship prompt
- Neovim with NvChad configuration
- Alacritty terminal
- Lazygit
- Node.js and NVM
- Bun
- Neofetch system info tool

## NvChad Features

- Modern Neovim configuration framework
- Pre-configured LSP, syntax highlighting, and autocomplete
- Beautiful UI with themes and statusline
- File explorer, fuzzy finder, and git integration
- Automatic plugin management with Lazy.nvim

## Supported Systems

- macOS (Homebrew)
- Ubuntu/Debian (APT)
- Fedora (DNF)
- CentOS/RHEL (YUM)
- Arch Linux (Pacman)

## Dependencies

The setup script will install these automatically, but if needed manually:

### macOS (Homebrew)

```bash
brew install git vim neovim zsh node alacritty lazygit neofetch
```

### Ubuntu/Debian (APT)

```bash
sudo apt update
sudo apt install git vim neovim zsh nodejs npm curl neofetch
# Alacritty via snap: sudo snap install alacritty --classic
```

### Fedora (DNF)

```bash
sudo dnf install git vim neovim zsh nodejs npm curl neofetch
```

### CentOS/RHEL (YUM)

```bash
sudo yum install git vim neovim zsh nodejs npm curl neofetch
```

### Arch Linux (Pacman)

```bash
sudo pacman -S git vim neovim zsh nodejs npm curl alacritty lazygit neofetch
```

## Manual Setup

If the script fails, install these packages manually:

- git, vim, neovim, zsh, nodejs, neofetch

Then run:

```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Starship
curl -sS https://starship.rs/install.sh | sh

# Create symlinks
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.config ~/.config

# Set zsh as default
chsh -s $(which zsh)

# Install NvChad
nvim --headless "+Lazy! sync" +qa

# Install LSP servers and tools
nvim --headless "+MasonInstallAll" +qa
```

## Customization

Edit `.zshrc` for shell customization.
Edit `.config/nvim/lua/custom/` for NvChad customization.
Edit `.config/alacritty/alacritty.toml` for terminal settings.

### This README.md is generated using an LLM
