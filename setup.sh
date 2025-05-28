#!/bin/bash

# Dotfiles setup script
# Works on multiple Unix systems (macOS, Ubuntu/Debian, CentOS/RHEL, Arch Linux)

set -e  # Exit on any error

# Global variables
OS=""
PACKAGE_MANAGER=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_step() {
    echo -e "${BLUE}📦 $1${NC}"
}

# Detect OS and package manager
detect_system() {
    log_info "Detecting system..."
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PACKAGE_MANAGER="brew"
    elif command -v apt-get &> /dev/null; then
        OS="ubuntu"
        PACKAGE_MANAGER="apt"
    elif command -v dnf &> /dev/null; then
        OS="fedora"
        PACKAGE_MANAGER="dnf"
    elif command -v yum &> /dev/null; then
        OS="rhel"
        PACKAGE_MANAGER="yum"
    elif command -v pacman &> /dev/null; then
        OS="arch"
        PACKAGE_MANAGER="pacman"
    else
        OS="unknown"
        PACKAGE_MANAGER="manual"
    fi
    
    log_success "Detected $OS with $PACKAGE_MANAGER package manager"
}

# Check if package is installed
is_installed() {
    local package=$1
    local package_name=${2:-$package}
    
    case $PACKAGE_MANAGER in
        "brew") brew list "$package" &>/dev/null ;;
        "apt") dpkg -l | grep -q "^ii  $package_name " ;;
        "yum"|"dnf") rpm -q "$package_name" &>/dev/null ;;
        "pacman") pacman -Q "$package_name" &>/dev/null ;;
        *) command -v "$package" &>/dev/null ;;
    esac
}

# Install package based on the detected system
install_package() {
    local package=$1
    local apt_name=${2:-$package}
    local yum_name=${3:-$package}
    local pacman_name=${4:-$package}
    
    case $PACKAGE_MANAGER in
        "brew")
            if is_installed "$package"; then
                log_success "$package already installed"
            else
                log_step "Installing $package..."
                brew install "$package"
            fi
            ;;
        "apt")
            if is_installed "$package" "$apt_name"; then
                log_success "$apt_name already installed"
            else
                log_step "Installing $apt_name..."
                sudo apt-get update &>/dev/null
                sudo apt-get install -y "$apt_name"
            fi
            ;;
        "yum"|"dnf")
            if is_installed "$package" "$yum_name"; then
                log_success "$yum_name already installed"
            else
                log_step "Installing $yum_name..."
                if [[ $PACKAGE_MANAGER == "yum" ]]; then
                    sudo yum install -y "$yum_name"
                else
                    sudo dnf install -y "$yum_name"
                fi
            fi
            ;;
        "pacman")
            if is_installed "$package" "$pacman_name"; then
                log_success "$pacman_name already installed"
            else
                log_step "Installing $pacman_name..."
                sudo pacman -S --noconfirm "$pacman_name"
            fi
            ;;
        "manual")
            log_warning "Please install $package manually on your system"
            ;;
    esac
}

# Setup package manager
setup_package_manager() {
    case $PACKAGE_MANAGER in
        "brew")
            if ! command -v brew &> /dev/null; then
                log_step "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            else
                log_success "Homebrew already installed"
            fi
            ;;
        "apt")
            log_info "Updating package lists..."
            sudo apt-get update
            ;;
        "yum"|"dnf")
            log_info "Updating package cache..."
            if [[ $PACKAGE_MANAGER == "yum" ]]; then
                sudo yum makecache
            else
                sudo dnf makecache
            fi
            ;;
        "pacman")
            log_info "Updating package database..."
            sudo pacman -Sy
            ;;
    esac
}

# Install essential packages
install_essentials() {
    log_info "Installing essential packages..."
    
    # Basic tools
    install_package "git" "git" "git" "git"
    install_package "vim" "vim" "vim" "vim"
    install_package "neovim" "neovim" "neovim" "neovim"
    install_package "zsh" "zsh" "zsh" "zsh"
}

# Install Node.js
install_nodejs() {
    if command -v node &> /dev/null; then
        log_success "Node.js already installed"
        return
    fi
    
    case $PACKAGE_MANAGER in
        "brew")
            install_package "node"
            ;;
        "apt")
            log_step "Installing Node.js via NodeSource..."
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt-get install -y nodejs
            ;;
        "yum"|"dnf"|"pacman")
            install_package "node" "nodejs" "nodejs" "nodejs"
            ;;
        "manual")
            log_warning "Please install Node.js manually from https://nodejs.org/"
            ;;
    esac
}

# Install terminal applications
install_terminal_apps() {
    case $PACKAGE_MANAGER in
        "brew")
            install_package "alacritty"
            install_package "lazygit"
            ;;
        "apt")
            # Alacritty
            if ! command -v alacritty &> /dev/null; then
                log_step "Installing Alacritty..."
                if command -v snap &> /dev/null; then
                    sudo snap install alacritty --classic
                else
                    log_warning "Please install Alacritty manually from https://github.com/alacritty/alacritty"
                fi
            else
                log_success "Alacritty already installed"
            fi
            
            # Lazygit
            if ! command -v lazygit &> /dev/null; then
                log_step "Installing Lazygit..."
                LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                tar xf lazygit.tar.gz lazygit
                sudo install lazygit /usr/local/bin
                rm lazygit lazygit.tar.gz
            else
                log_success "Lazygit already installed"
            fi
            ;;
        "pacman")
            install_package "alacritty" "alacritty" "alacritty" "alacritty"
            install_package "lazygit" "lazygit" "lazygit" "lazygit"
            ;;
        *)
            log_warning "Please install Alacritty and Lazygit manually"
            log_info "Alacritty: https://github.com/alacritty/alacritty"
            log_info "Lazygit: https://github.com/jesseduffield/lazygit"
            ;;
    esac
}

# Install shell enhancements
install_shell_enhancements() {
    # Starship prompt
    if ! command -v starship &> /dev/null; then
        log_step "Installing Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    else
        log_success "Starship already installed"
    fi
    
    # Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_step "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_success "Oh My Zsh already installed"
    fi
    
    # zsh-syntax-highlighting plugin
    local plugin_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    if [ ! -d "$plugin_dir" ]; then
        log_step "Installing zsh-syntax-highlighting plugin..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugin_dir"
    else
        log_success "zsh-syntax-highlighting plugin already installed"
    fi
}

# Install development tools
install_dev_tools() {
    # NVM
    if [ ! -d "$HOME/.nvm" ]; then
        log_step "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    else
        log_success "NVM already installed"
    fi
    
    # Bun
    if ! command -v bun &> /dev/null; then
        log_step "Installing Bun..."
        curl -fsSL https://bun.sh/install | bash
    else
        log_success "Bun already installed"
    fi
}

# Create symlinks for dotfiles
setup_dotfiles() {
    log_info "Setting up dotfiles..."
    
    local create_symlink() {
        local source="$PWD/$1"
        local target="$HOME/$1"
        
        if [ -L "$target" ]; then
            log_success "Symlink for $1 already exists"
        elif [ -f "$target" ] || [ -d "$target" ]; then
            log_info "Backing up existing $1 to $1.backup"
            mv "$target" "$target.backup"
            ln -s "$source" "$target"
            log_success "Created symlink for $1"
        else
            ln -s "$source" "$target"
            log_success "Created symlink for $1"
        fi
    }
    
    create_symlink ".zshrc"
    create_symlink ".bashrc"
    create_symlink ".config"
}

# Set zsh as default shell
setup_shell() {
    if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "/usr/bin/zsh" ]; then
        log_step "Setting zsh as default shell..."
        local zsh_path=$(which zsh)
        if grep -q "$zsh_path" /etc/shells; then
            chsh -s "$zsh_path"
            log_success "zsh set as default shell"
        else
            log_warning "zsh not found in /etc/shells"
            log_info "Please add $zsh_path to /etc/shells and run: chsh -s $zsh_path"
        fi
    else
        log_success "zsh is already the default shell"
    fi
}

# Install Neovim plugins
setup_neovim() {
    if [ -f "$HOME/.config/nvim/init.lua" ]; then
        log_step "Installing Neovim plugins..."
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || log_warning "Neovim plugins installation may have issues, please run :Lazy sync manually in nvim"
    fi
}

# Print final summary
print_summary() {
    echo ""
    log_success "Dotfiles setup complete!"
    echo ""
    log_info "Next steps:"
    echo "   1. Restart your terminal or run: source ~/.zshrc"
    echo "   2. Open nvim and run :checkhealth to verify everything is working"
    echo "   3. Customize your configurations as needed"
    echo ""
    log_info "Tools installed/configured:"
    echo "   - Oh My Zsh with zsh-syntax-highlighting"
    echo "   - Starship prompt"
    echo "   - Neovim with configuration"
    echo "   - Alacritty terminal (if available for your system)"
    echo "   - Lazygit (if available for your system)"
    echo "   - NVM and Node.js"
    echo "   - Bun"
    echo ""
    log_info "System detected: $OS with $PACKAGE_MANAGER package manager"
}

# Main execution
main() {
    echo "🚀 Starting dotfiles setup..."
    echo ""
    
    detect_system
    setup_package_manager
    install_essentials
    install_nodejs
    install_terminal_apps
    install_shell_enhancements
    install_dev_tools
    setup_dotfiles
    setup_shell
    setup_neovim
    print_summary
}

# Run main function
main "$@"
