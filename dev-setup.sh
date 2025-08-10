#!/bin/bash

# ---------------------------------------------
# IAMYB Modular Dev Setup Script
# Author: Yavuz Bogazci / iamyb.com
# ---------------------------------------------

# =============================================================================
# API KEYS - MANUAL CONFIGURATION
# =============================================================================

# Trage hier deine API Keys ein:
OPENAI_API_KEY_PRESET=""    # Dein OpenAI API Key (sk-...) - ERFORDERLICH für Codex
ANTHROPIC_API_KEY_PRESET="" # Dein Anthropic API Key (optional - Claude Code kann auch Browser-Login)

# =============================================================================

# COLORS
FG_RED=$(tput setaf 1)
FG_GREEN=$(tput setaf 2)
FG_BLUE=$(tput setaf 4)
FG_CYAN=$(tput setaf 6)
FG_YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# HOME BASE
PROJECTS_DIR="$HOME/Dev/projects"
mkdir -p "$PROJECTS_DIR"

# FUNCTIONS

install_vscode() {
  echo "${FG_BLUE}🔍 Prüfe Snap-Verfügbarkeit...${RESET}"
  if command -v snap &> /dev/null; then
    echo "${FG_BLUE}📦 Snap ist verfügbar – Installation über Snap...${RESET}"
    sudo snap install code --classic && echo "${FG_GREEN}✅ VS Code installiert via Snap.${RESET}" && return
  fi

  echo "${FG_YELLOW}❌ Snap nicht verfügbar. Biete .deb-Installation an.${RESET}"
  echo ""
  echo "Welche Architektur nutzt du?"
  echo "1) x86_64 (Intel/AMD)"
  echo "2) arm64 (Apple M1/M2/M4, Raspberry Pi, etc.)"
  echo "3) Abbrechen"
  echo ""

  read -p "Bitte auswählen (1–3): " arch_choice
  case "$arch_choice" in
    1)
      echo "${FG_BLUE}⬇️ Lade VS Code für x86_64 herunter...${RESET}"
      wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
      ;;
    2)
      echo "${FG_BLUE}⬇️ Lade VS Code für arm64 herunter...${RESET}"
      wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64"
      ;;
    3)
      echo "${FG_YELLOW}❌ Abgebrochen.${RESET}"
      return
      ;;
    *)
      echo "${FG_RED}❌ Ungültige Eingabe.${RESET}"
      return
      ;;
  esac

  echo "${FG_BLUE}📦 Installiere VS Code .deb...${RESET}"
  sudo apt install -y ./vscode.deb && echo "${FG_GREEN}✅ VS Code erfolgreich installiert.${RESET}"
  rm vscode.deb
}

install_git_and_cli() {
  echo "${FG_BLUE}🔧 Installing Git & GitHub CLI...${RESET}"
  sudo apt update
  
  # Install Git first
  sudo apt install -y git
  
  # GitHub CLI with proper repository setup
  if ! command -v gh &> /dev/null; then
    echo "${FG_BLUE}📦 Adding GitHub CLI repository...${RESET}"
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
    sudo apt update
    sudo apt install -y gh
  fi
  
  echo "${FG_GREEN}✅ Git & GitHub CLI installiert.${RESET}"
}

install_node() {
  echo "${FG_BLUE}🔧 Installing Node.js & npm...${RESET}"
  sudo apt update
  sudo apt install -y nodejs npm
  echo "${FG_GREEN}✅ Node.js & npm installiert.${RESET}"
}

install_python() {
  echo "${FG_BLUE}🐍 Checking Python installation...${RESET}"
  if command -v python3 &> /dev/null; then
    echo "${FG_GREEN}✅ Python3 is already installed.${RESET}"
  else
    echo "${FG_BLUE}📦 Installing Python3...${RESET}"
    sudo apt update
    sudo apt install -y python3
    echo "${FG_GREEN}✅ Python3 installiert.${RESET}"
  fi
}

install_pip() {
  echo "${FG_BLUE}📦 Installing pip for Python3...${RESET}"
  sudo apt update
  sudo apt install -y python3-pip
  echo "${FG_GREEN}✅ pip installiert.${RESET}"
}

install_docker() {
  echo "${FG_BLUE}🐳 Installing Docker...${RESET}"
  sudo apt update
  sudo apt install -y docker.io docker-compose
  sudo systemctl enable docker
  sudo usermod -aG docker "$USER"
  echo "${FG_GREEN}✅ Docker installed. Please restart your session to apply Docker group permissions.${RESET}"
}

install_dbeaver() {
  echo "${FG_BLUE}🗄️ Installing DBeaver Community...${RESET}"
  if command -v snap &> /dev/null; then
    echo "${FG_BLUE}📦 Installing DBeaver via Snap...${RESET}"
    sudo snap install dbeaver-ce
    echo "${FG_GREEN}✅ DBeaver installiert via Snap.${RESET}"
  else
    echo "${FG_BLUE}📦 Adding DBeaver repository with modern GPG handling...${RESET}"
    wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/dbeaver-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/dbeaver-keyring.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
    sudo apt update
    sudo apt install -y dbeaver-ce
    echo "${FG_GREEN}✅ DBeaver installiert.${RESET}"
  fi
}

install_chrome() {
  echo "${FG_BLUE}🌐 Installing Google Chrome...${RESET}"
  
  # Detect system architecture
  ARCH=$(dpkg --print-architecture)
  echo "${FG_CYAN}📋 Detected architecture: $ARCH${RESET}"
  
  # Check if we're on an unsupported architecture
  if [[ "$ARCH" != "amd64" && "$ARCH" != "i386" ]]; then
    echo "${FG_YELLOW}⚠️ Chrome ist nicht verfügbar für $ARCH. Versuche Chromium als Alternative...${RESET}"
    sudo apt update
    sudo apt install -y chromium-browser
    echo "${FG_GREEN}✅ Chromium Browser installiert (Chrome Alternative).${RESET}"
    return
  fi
  
  # First try: Install essential dependencies
  echo "${FG_BLUE}📦 Installing Chrome dependencies...${RESET}"
  sudo apt update
  sudo apt install -y wget gnupg lsb-release
  
  # Try installing common missing dependencies
  sudo apt install -y libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 \
    libcairo2 libcups2 libdbus-1-3 libexpat1 libgbm1 libglib2.0-0 \
    libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libudev1 libvulkan1 \
    libx11-6 libxcb1 libxcomposite1 libxdamage1 libxext6 libxfixes3 \
    libxkbcommon0 libxrandr2 2>/dev/null || true
  
  # Second try: Modern GPG key handling
  wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg
  
  # Add repository with proper keyring
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
  
  sudo apt update
  if sudo apt install -y google-chrome-stable; then
    echo "${FG_GREEN}✅ Google Chrome installiert.${RESET}"
    return
  fi
  
  # Third try: Force install with .deb and fix dependencies
  echo "${FG_YELLOW}⚠️ Repository-Installation fehlgeschlagen. Versuche .deb-Download mit Dependency-Fix...${RESET}"
  
  if [[ "$ARCH" == "amd64" ]]; then
    wget -O google-chrome-stable.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  else
    wget -O google-chrome-stable.deb https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
  fi
  
  # Try to fix dependencies automatically
  if sudo apt install -y ./google-chrome-stable.deb; then
    echo "${FG_GREEN}✅ Google Chrome installiert via .deb.${RESET}"
  else
    echo "${FG_YELLOW}⚠️ Chrome Installation mit Problemen. Versuche Dependency-Fix...${RESET}"
    sudo apt --fix-broken install -y
    if sudo dpkg -i google-chrome-stable.deb 2>/dev/null; then
      echo "${FG_GREEN}✅ Google Chrome installiert nach Dependency-Fix.${RESET}"
    else
      echo "${FG_RED}❌ Chrome Installation fehlgeschlagen. Installiere Chromium als Alternative...${RESET}"
      sudo apt install -y chromium-browser
      echo "${FG_GREEN}✅ Chromium Browser installiert (Chrome Alternative).${RESET}"
    fi
  fi
  
  rm -f google-chrome-stable.deb
}

install_postman() {
  echo "${FG_BLUE}📮 Installing Postman...${RESET}"
  if command -v snap &> /dev/null; then
    sudo snap install postman
    echo "${FG_GREEN}✅ Postman installiert via Snap.${RESET}"
  else
    wget -O postman.tar.gz https://dl.pstmn.io/download/latest/linux64
    sudo tar -xzf postman.tar.gz -C /opt/
    sudo ln -sf /opt/Postman/Postman /usr/local/bin/postman
    rm postman.tar.gz
    echo "${FG_GREEN}✅ Postman installiert.${RESET}"
  fi
}

install_nvm() {
  echo "${FG_BLUE}📦 Installing NVM (Node Version Manager)...${RESET}"
  
  # Check if already installed
  if [ -f "$HOME/.nvm/nvm.sh" ]; then
    echo "${FG_GREEN}✅ NVM ist bereits installiert.${RESET}"
    return
  fi
  
  # Install NVM with latest version
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  
  # Source nvm immediately for current session
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  
  echo "${FG_GREEN}✅ NVM installiert.${RESET}"
  echo "${FG_CYAN}💡 Verwendung: nvm install node (latest), nvm install 18 (specific version)${RESET}"
  echo "${FG_CYAN}💡 Für neue Terminals: Terminal neu starten oder 'source ~/.bashrc' ausführen${RESET}"
}

install_pyenv() {
  echo "${FG_BLUE}🐍 Installing pyenv (Python Version Manager)...${RESET}"
  
  # Check if already installed
  if [ -d "$HOME/.pyenv" ]; then
    echo "${FG_GREEN}✅ pyenv ist bereits installiert.${RESET}"
    return
  fi
  
  # Install dependencies first
  sudo apt update
  sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
  
  # Install pyenv
  curl https://pyenv.run | bash
  
  # Add to shell profile if not already there
  if ! grep -q 'pyenv' ~/.bashrc; then
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
  fi
  
  echo "${FG_GREEN}✅ pyenv installiert.${RESET}"
  echo "${FG_CYAN}💡 Verwendung: pyenv install 3.11.0, pyenv global 3.11.0${RESET}"
  echo "${FG_CYAN}💡 Für neue Terminals: Terminal neu starten oder 'source ~/.bashrc' ausführen${RESET}"
}

install_zsh_ohmyzsh() {
  echo "${FG_BLUE}🐚 Installing Zsh + Oh My Zsh...${RESET}"
  sudo apt update
  sudo apt install -y zsh
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "${FG_GREEN}✅ Zsh + Oh My Zsh installiert.${RESET}"
  echo "${FG_CYAN}💡 Führe 'chsh -s $(which zsh)' aus, um Zsh als Standard-Shell zu setzen.${RESET}"
}

install_system_tools() {
  echo "${FG_BLUE}🔧 Installing System Tools (OpenSSH, Terminator, Tree, 7zip)...${RESET}"
  sudo apt update
  sudo apt install -y openssh-client openssh-server terminator tree p7zip-full p7zip-rar
  echo "${FG_GREEN}✅ System Tools installiert.${RESET}"
}

install_filezilla() {
  echo "${FG_BLUE}📁 Installing FileZilla...${RESET}"
  sudo apt update
  sudo apt install -y filezilla
  echo "${FG_GREEN}✅ FileZilla installiert.${RESET}"
}

install_terraform() {
  echo "${FG_BLUE}🏗️ Installing Terraform...${RESET}"
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update
  sudo apt install -y terraform
  echo "${FG_GREEN}✅ Terraform installiert.${RESET}"
}

install_azure_cli() {
  echo "${FG_BLUE}☁️ Installing Azure CLI...${RESET}"
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  echo "${FG_GREEN}✅ Azure CLI installiert.${RESET}"
}

show_dev_tools_menu() {
  while true; do
    clear
    echo "${FG_CYAN}🔧 Dev Tools Installer (Modular)${RESET}"
    echo ""
    echo "1) Install VS Code"
    echo "2) Install Git & GitHub CLI"
    echo "3) Install Node.js & npm"
    echo "4) Install/Check Python3"
    echo "5) Install pip (Python package manager)"
    echo "6) Install Docker & Docker Compose"
    echo "7) Install DBeaver (Database GUI)"
    echo "8) Install Google Chrome"
    echo "9) Install Postman (API Testing)"
    echo "10) Install NVM (Node Version Manager)"
    echo "11) Install pyenv (Python Version Manager)"
    echo "12) Install Zsh + Oh My Zsh"
    echo "13) Install System Tools (SSH, Terminator, Tree, 7zip)"
    echo "14) Install FileZilla (FTP Client)"
    echo "15) Zurück zum Hauptmenü"
    echo ""

    read -p "Wähle ein Tool (1–15): " dev_choice
    case "$dev_choice" in
      1) install_vscode ;;
      2) install_git_and_cli ;;
      3) install_node ;;
      4) install_python ;;
      5) install_pip ;;
      6) install_docker ;;
      7) install_dbeaver ;;
      8) install_chrome ;;
      9) install_postman ;;
      10) install_nvm ;;
      11) install_pyenv ;;
      12) install_zsh_ohmyzsh ;;
      13) install_system_tools ;;
      14) install_filezilla ;;
      15) break ;;
      *) echo "${FG_RED}❌ Ungültige Auswahl. Bitte 1–15 wählen.${RESET}"; sleep 2 ;;
    esac
    read -p "⏎ Weiter mit Enter..."
  done
}

setup_github_project() {
  echo "${FG_BLUE}📁 GitHub Project Bootstrap${RESET}"
  if ! command -v gh &> /dev/null; then
    echo "${FG_RED}❌ GitHub CLI not found. Bitte zuerst über Dev Tools installieren.${RESET}"
    return
  fi

  # Check GitHub CLI authentication status
  echo "${FG_CYAN}🔗 Prüfe GitHub Authentication...${RESET}"
  if ! gh auth status &>/dev/null; then
    echo "${FG_YELLOW}⚠️ GitHub CLI ist nicht authentifiziert.${RESET}"
    echo ""
    echo "Wähle Authentifizierungsmethode:"
    echo "1) Browser (empfohlen)"
    echo "2) Personal Access Token"
    echo "3) SSH Key"
    echo "4) Abbrechen"
    echo ""
    
    read -p "Authentifizierungsmethode (1-4): " auth_choice
    case "$auth_choice" in
      1)
        echo "${FG_BLUE}🌐 Starte Browser-Authentifizierung...${RESET}"
        echo "${FG_CYAN}💡 Falls der Browser nicht automatisch öffnet, kopiere den Link und öffne ihn manuell.${RESET}"
        
        # Try different authentication approaches
        if command -v xdg-open &> /dev/null; then
          # Linux with xdg-open
          gh auth login --web --hostname github.com
        elif command -v open &> /dev/null; then
          # macOS
          gh auth login --web --hostname github.com
        else
          # Fallback: show URL manually
          echo "${FG_YELLOW}🔗 Browser konnte nicht automatisch geöffnet werden.${RESET}"
          echo "${FG_CYAN}Öffne diesen Link manuell in deinem Browser:${RESET}"
          echo "https://github.com/login/device"
          echo ""
          gh auth login --hostname github.com
        fi
        ;;
      2)
        echo "${FG_BLUE}🔑 Personal Access Token Authentifizierung...${RESET}"
        echo ""
        echo "${FG_CYAN}📋 Token erstellen:${RESET}"
        echo "1. Öffne: ${FG_YELLOW}https://github.com/settings/tokens/new${RESET}"
        echo "2. Token Name: z.B. 'Dev Setup Script'"
        echo "3. Expiration: 90 days (empfohlen)"
        echo "4. Select Scopes:"
        echo "   ✅ repo (Full control of private repositories)"
        echo "   ✅ workflow (Update GitHub Action workflows)" 
        echo "   ✅ write:packages (Upload packages to GitHub Package Registry)"
        echo "5. Generate token und kopieren"
        echo ""
        echo "${FG_YELLOW}💡 Tipp: Öffne den Link in einem neuen Browser-Tab${RESET}"
        
        # Try to open the token creation page
        if command -v xdg-open &> /dev/null; then
          echo "${FG_BLUE}🌐 Öffne Token-Erstellungsseite...${RESET}"
          xdg-open "https://github.com/settings/tokens/new?scopes=repo,workflow,write:packages&description=Dev+Setup+Script" &
        elif command -v open &> /dev/null; then
          echo "${FG_BLUE}🌐 Öffne Token-Erstellungsseite...${RESET}"
          open "https://github.com/settings/tokens/new?scopes=repo,workflow,write:packages&description=Dev+Setup+Script" &
        else
          echo "${FG_YELLOW}📋 Kopiere diese URL in deinen Browser:${RESET}"
          echo "https://github.com/settings/tokens/new?scopes=repo,workflow,write:packages&description=Dev+Setup+Script"
        fi
        
        echo ""
        read -p "⏎ Drücke Enter wenn du den Token erstellt hast..."
        echo ""
        echo "${FG_CYAN}🔑 Füge deinen Personal Access Token ein:${RESET}"
        gh auth login --with-token --hostname github.com
        ;;
      3)
        echo "${FG_BLUE}🔐 SSH Key Authentifizierung...${RESET}"
        gh auth login --git-protocol ssh --hostname github.com
        ;;
      4)
        echo "${FG_YELLOW}❌ Authentifizierung abgebrochen.${RESET}"
        return
        ;;
      *)
        echo "${FG_RED}❌ Ungültige Eingabe.${RESET}"
        return
        ;;
    esac
    
    # Verify authentication worked
    echo ""
    echo "${FG_BLUE}🔍 Verifiziere Authentifizierung...${RESET}"
    if gh auth status &>/dev/null; then
      echo "${FG_GREEN}✅ GitHub Authentifizierung erfolgreich!${RESET}"
    else
      echo "${FG_RED}❌ Authentifizierung fehlgeschlagen. Bitte erneut versuchen.${RESET}"
      return
    fi
  else
    echo "${FG_GREEN}✅ GitHub CLI bereits authentifiziert.${RESET}"
  fi

  echo ""
  read -p "🔤 Projektname: " PROJECT_NAME
  if [ -z "$PROJECT_NAME" ]; then
    echo "${FG_RED}❌ Projektname darf nicht leer sein.${RESET}"
    return
  fi

  # Check if project already exists locally
  PROJECT_PATH="$PROJECTS_DIR/$PROJECT_NAME"
  if [ -d "$PROJECT_PATH" ]; then
    echo "${FG_YELLOW}⚠️ Projekt '$PROJECT_NAME' existiert bereits lokal.${RESET}"
    read -p "Möchtest du es überschreiben? (y/N): " overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
      echo "${FG_YELLOW}❌ Abgebrochen.${RESET}"
      return
    fi
    rm -rf "$PROJECT_PATH"
  fi

  # Check if repo exists on GitHub
  if gh repo view "$PROJECT_NAME" &>/dev/null; then
    echo "${FG_YELLOW}⚠️ Repository '$PROJECT_NAME' existiert bereits auf GitHub.${RESET}"
    read -p "Möchtest du es klonen statt neu zu erstellen? (y/N): " clone_choice
    if [[ "$clone_choice" =~ ^[Yy]$ ]]; then
      echo "${FG_BLUE}📥 Klone Repository...${RESET}"
      gh repo clone "$PROJECT_NAME" "$PROJECT_PATH"
      echo "${FG_GREEN}✅ Repository '$PROJECT_NAME' geklont.${RESET}"
      return
    fi
  fi

  # Create project directory and files
  mkdir -p "$PROJECT_PATH"
  cd "$PROJECT_PATH" || return

  echo "${FG_BLUE}📄 Erstelle Projektdateien...${RESET}"
  
  # Create README.md
  cat > README.md << EOF
# $PROJECT_NAME

## Beschreibung
Kurze Beschreibung des Projekts.

## Installation
\`\`\`bash
# Installation instructions
\`\`\`

## Verwendung
\`\`\`bash
# Usage examples
\`\`\`

## Beitragen
Pull Requests sind willkommen!

## Lizenz
[MIT](https://choosealicense.com/licenses/mit/)
EOF

  # Create comprehensive .gitignore
  cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.pnp
.pnp.js

# Python
__pycache__/
*.py[cod]
*$py.class
.venv/
venv/
ENV/
env/

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build outputs
dist/
build/
*.tgz
*.tar.gz

# Database
*.db
*.sqlite

# Temporary files
tmp/
temp/
EOF

  # Initialize git repository
  echo "${FG_BLUE}🔧 Initialisiere Git Repository...${RESET}"
  git init -b main
  
  # Configure git user if not already set
  if ! git config user.name &>/dev/null; then
    read -p "Git Benutzername eingeben: " git_name
    git config user.name "$git_name"
  fi
  
  if ! git config user.email &>/dev/null; then
    read -p "Git E-Mail eingeben: " git_email
    git config user.email "$git_email"
  fi
  
  git add .
  if git commit -m "Initial commit: Project setup with README and .gitignore"; then
    echo "${FG_GREEN}✅ Lokales Git Repository erstellt.${RESET}"
  else
    echo "${FG_RED}❌ Git Commit fehlgeschlagen. Prüfe Git-Konfiguration.${RESET}"
    echo "${FG_CYAN}💡 Tipp: Führe 'git config --global user.name \"Dein Name\"' aus${RESET}"
    echo "${FG_CYAN}💡 Tipp: Führe 'git config --global user.email \"deine@email.com\"' aus${RESET}"
    return
  fi

  # Create GitHub repository
  echo "${FG_BLUE}🚀 Erstelle GitHub Repository...${RESET}"
  echo ""
  echo "Repository-Einstellungen:"
  echo "1) Private Repository (empfohlen)"
  echo "2) Public Repository"
  echo ""
  read -p "Repository-Typ (1-2, Standard: 1): " repo_type
  
  case "${repo_type:-1}" in
    1)
      repo_flag="--private"
      echo "${FG_CYAN}📁 Erstelle privates Repository...${RESET}"
      ;;
    2)
      repo_flag="--public"
      echo "${FG_CYAN}📁 Erstelle öffentliches Repository...${RESET}"
      ;;
    *)
      repo_flag="--private"
      echo "${FG_CYAN}📁 Erstelle privates Repository (Standard)...${RESET}"
      ;;
  esac

  # Create repository without --push first, then push manually
  if gh repo create "$PROJECT_NAME" "$repo_flag" --source=. --remote=origin; then
    echo "${FG_BLUE}📤 Pushe lokale Änderungen zu GitHub...${RESET}"
    if git push -u origin main; then
      echo ""
      echo "${FG_GREEN}🎉 Projekt '$PROJECT_NAME' erfolgreich erstellt!${RESET}"
      echo ""
      echo "${FG_CYAN}📊 Projekt-Informationen:${RESET}"
      echo "  📁 Lokal: $PROJECT_PATH"
      echo "  🌐 GitHub: https://github.com/$(gh api user --jq .login)/$PROJECT_NAME"
      echo "  🔗 Clone URL: $(gh repo view "$PROJECT_NAME" --json sshUrl --jq .sshUrl)"
      echo ""
      echo "${FG_CYAN}💡 Nächste Schritte:${RESET}"
      echo "  - ${FG_YELLOW}cd $PROJECT_PATH${RESET} - Ins Projekt wechseln"
      echo "  - ${FG_YELLOW}code .${RESET} - In VS Code öffnen"
      echo "  - README.md bearbeiten und Projekt beschreiben"
    else
      echo "${FG_YELLOW}⚠️ Repository erstellt, aber Push fehlgeschlagen.${RESET}"
      echo "${FG_CYAN}💡 Manuell pushen mit: git push -u origin main${RESET}"
    fi
  else
    echo "${FG_RED}❌ Fehler beim Erstellen des GitHub Repositories.${RESET}"
    echo "${FG_YELLOW}💡 Das lokale Projekt wurde trotzdem erstellt in: $PROJECT_PATH${RESET}"
    echo "${FG_CYAN}💡 Manuell erstellen: gh repo create $PROJECT_NAME --private --source=.${RESET}"
  fi
}

manage_env() {
  while true; do
    clear
    echo "${FG_BLUE}💾 Environment & Database Management${RESET}"
    echo ""
    echo "1) Install MySQL Server"
    echo "2) Install MySQL Client only"
    echo "3) Install SQLite"
    echo "4) Install Redis Server"
    echo "5) Start MySQL Service"
    echo "6) Stop MySQL Service"
    echo "7) Start Redis Service"
    echo "8) Stop Redis Service"
    echo "9) Check Services Status"
    echo "10) Install Terraform"
    echo "11) Install Azure CLI"
    echo "12) Zurück zum Hauptmenü"
    echo ""

    read -p "Wähle eine Option (1–12): " env_choice
    case "$env_choice" in
      1) install_mysql_server ;;
      2) install_mysql_client ;;
      3) install_sqlite ;;
      4) install_redis ;;
      5) start_mysql ;;
      6) stop_mysql ;;
      7) start_redis ;;
      8) stop_redis ;;
      9) check_services_status ;;
      10) install_terraform ;;
      11) install_azure_cli ;;
      12) break ;;
      *) echo "${FG_RED}❌ Ungültige Auswahl. Bitte 1–12 wählen.${RESET}"; sleep 2 ;;
    esac
    read -p "⏎ Weiter mit Enter..."
  done
}

install_mysql_server() {
  echo "${FG_BLUE}🗄️ Installing MySQL Server...${RESET}"
  sudo apt update
  sudo apt install -y mysql-server
  sudo systemctl enable mysql
  echo "${FG_GREEN}✅ MySQL Server installiert und aktiviert.${RESET}"
  echo "${FG_CYAN}💡 Tipp: Führe 'sudo mysql_secure_installation' aus, um MySQL zu sichern.${RESET}"
}

install_mysql_client() {
  echo "${FG_BLUE}🔧 Installing MySQL Client only...${RESET}"
  sudo apt update
  sudo apt install -y mysql-client
  echo "${FG_GREEN}✅ MySQL Client installiert.${RESET}"
}

start_mysql() {
  echo "${FG_BLUE}▶️ Starting MySQL Service...${RESET}"
  if sudo systemctl start mysql; then
    echo "${FG_GREEN}✅ MySQL Service gestartet.${RESET}"
  else
    echo "${FG_RED}❌ Fehler beim Starten von MySQL.${RESET}"
  fi
}

stop_mysql() {
  echo "${FG_BLUE}⏹️ Stopping MySQL Service...${RESET}"
  if sudo systemctl stop mysql; then
    echo "${FG_GREEN}✅ MySQL Service gestoppt.${RESET}"
  else
    echo "${FG_RED}❌ Fehler beim Stoppen von MySQL.${RESET}"
  fi
}

install_sqlite() {
  echo "${FG_BLUE}🗃️ Installing SQLite...${RESET}"
  sudo apt update
  sudo apt install -y sqlite3 libsqlite3-dev
  echo "${FG_GREEN}✅ SQLite installiert.${RESET}"
}

install_redis() {
  echo "${FG_BLUE}🔴 Installing Redis Server...${RESET}"
  sudo apt update
  sudo apt install -y redis-server
  sudo systemctl enable redis-server
  echo "${FG_GREEN}✅ Redis Server installiert und aktiviert.${RESET}"
}

start_redis() {
  echo "${FG_BLUE}▶️ Starting Redis Service...${RESET}"
  if sudo systemctl start redis-server; then
    echo "${FG_GREEN}✅ Redis Service gestartet.${RESET}"
  else
    echo "${FG_RED}❌ Fehler beim Starten von Redis.${RESET}"
  fi
}

stop_redis() {
  echo "${FG_BLUE}⏹️ Stopping Redis Service...${RESET}"
  if sudo systemctl stop redis-server; then
    echo "${FG_GREEN}✅ Redis Service gestoppt.${RESET}"
  else
    echo "${FG_RED}❌ Fehler beim Stoppen von Redis.${RESET}"
  fi
}

check_services_status() {
  echo "${FG_CYAN}🔍 Services Status Check:${RESET}"
  echo "=========================="
  
  services=("mysql:MySQL" "redis-server:Redis" "docker:Docker" "ssh:SSH")
  
  for service_info in "${services[@]}"; do
    service="${service_info%%:*}"
    name="${service_info##*:}"
    if systemctl is-active --quiet "$service"; then
      echo "${FG_GREEN}✅ $name is running${RESET}"
    else
      echo "${FG_RED}❌ $name is not running${RESET}"
    fi
  done
  echo "=========================="
}

# =============================================================================
# AI DEVELOPMENT TOOLS SETUP - CORRECTED VERSION
# =============================================================================

show_ai_tools_menu() {
  while true; do
    clear
    echo "${FG_CYAN}🤖 AI Development Tools Setup${RESET}"
    echo ""
    echo "1) Claude Code Installation (Anthropic)"
    echo "2) OpenAI Codex Installation"
    echo "3) Initialize Project with Claude Code"
    echo "4) Initialize Project with OpenAI Codex"
    echo "5) Zurück zum Hauptmenü"
    echo ""

    read -p "Wähle eine Option (1–5): " ai_choice
    case "$ai_choice" in
      1) install_claude_code_cli ;;
      2) install_openai_codex_cli ;;
      3) initialize_claude_project ;;
      4) initialize_codex_project ;;
      5) break ;;
      *) echo "${FG_RED}❌ Ungültige Auswahl. Bitte 1–5 wählen.${RESET}"; sleep 2 ;;
    esac
    read -p "⏎ Weiter mit Enter..."
  done
}

# Verbesserte npm Installation Functions mit automatischer Permission-Fix

fix_npm_permissions() {
  echo "${FG_BLUE}🔧 Repariere npm Berechtigungen...${RESET}"
  
  # Check if already configured
  if [[ "$(npm config get prefix)" == "$HOME/.npm-global" ]]; then
    echo "${FG_GREEN}✅ npm Berechtigungen bereits konfiguriert.${RESET}"
    return 0
  fi
  
  # Create global directory
  mkdir -p ~/.npm-global
  
  # Configure npm
  npm config set prefix '~/.npm-global'
  
  # Add to PATH if not already there
  if ! grep -q '~/.npm-global/bin' ~/.bashrc; then
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
    echo "${FG_YELLOW}⚠️ PATH aktualisiert. Terminal neu starten oder 'source ~/.bashrc' ausführen.${RESET}"
  fi
  
  # Export for current session
  export PATH=~/.npm-global/bin:$PATH
  
  echo "${FG_GREEN}✅ npm Berechtigungen repariert.${RESET}"
  return 0
}

install_claude_code_cli() {
  echo "${FG_CYAN}🤖 Claude Code CLI Installation (Anthropic)${RESET}"
  echo "${FG_BLUE}Installiere Anthropic's Claude Code CLI...${RESET}"
  
  # Check if Node.js is installed
  if ! command -v node &> /dev/null; then
    echo "${FG_RED}❌ Node.js ist erforderlich für Claude Code CLI.${RESET}"
    echo "${FG_CYAN}💡 Installiere Node.js zuerst über 'Dev Tools > Install Node.js & npm'${RESET}"
    return
  fi

  # Check if Claude Code is already installed
  if command -v claude &> /dev/null; then
    echo "${FG_GREEN}✅ Claude Code ist bereits installiert.${RESET}"
    
    # Check for updates
    echo "${FG_BLUE}🔄 Prüfe auf Updates...${RESET}"
    if npm update -g @anthropic-ai/claude-code 2>/dev/null; then
      echo "${FG_GREEN}✅ Claude Code CLI aktualisiert.${RESET}"
    else
      echo "${FG_YELLOW}⚠️ Update-Prüfung fehlgeschlagen oder bereits aktuell.${RESET}"
    fi
  else
    # Try to install, fix permissions if needed
    echo "${FG_BLUE}📦 Installiere Claude Code CLI...${RESET}"
    
    if npm install -g @anthropic-ai/claude-code 2>/dev/null; then
      echo "${FG_GREEN}✅ Claude Code CLI erfolgreich installiert.${RESET}"
    else
      echo "${FG_YELLOW}⚠️ Permission-Fehler erkannt. Repariere npm Berechtigungen...${RESET}"
      
      if fix_npm_permissions; then
        # Retry installation
        echo "${FG_BLUE}🔄 Versuche Installation erneut...${RESET}"
        if npm install -g @anthropic-ai/claude-code; then
          echo "${FG_GREEN}✅ Claude Code CLI erfolgreich installiert nach Permission-Fix.${RESET}"
        else
          echo "${FG_RED}❌ Installation fehlgeschlagen auch nach Permission-Fix.${RESET}"
          show_npm_alternatives
          return
        fi
      else
        echo "${FG_RED}❌ Permission-Fix fehlgeschlagen.${RESET}"
        show_npm_alternatives
        return
      fi
    fi
  fi
  
  show_claude_installation_success
}

install_openai_codex_cli() {
  echo "${FG_CYAN}🤖 OpenAI Codex CLI Installation${RESET}"
  echo "${FG_BLUE}Installiere OpenAI's Command-Line AI Assistant...${RESET}"
  
  # Check if Node.js is installed
  if ! command -v node &> /dev/null; then
    echo "${FG_RED}❌ Node.js ist erforderlich für Codex CLI.${RESET}"
    echo "${FG_CYAN}💡 Installiere Node.js zuerst über 'Dev Tools > Install Node.js & npm'${RESET}"
    return
  fi

  # Check Node.js version (needs 22+)
  NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
  if [ "$NODE_VERSION" -lt 22 ]; then
    echo "${FG_YELLOW}⚠️ Codex CLI benötigt Node.js 22+. Aktuelle Version: $(node --version)${RESET}"
    echo "${FG_CYAN}💡 Lösungen:${RESET}"
    echo "  • Mit NVM: nvm install 22 && nvm use 22"
    echo "  • Über Dev Tools > Install NVM"
    read -p "Trotzdem fortfahren? (y/N): " continue_anyway
    if [[ ! "$continue_anyway" =~ ^[Yy]$ ]]; then
      return
    fi
  fi

  # Check if Codex is already installed
  if command -v codex &> /dev/null; then
    echo "${FG_GREEN}✅ OpenAI Codex CLI ist bereits installiert.${RESET}"
    
    # Check for updates
    echo "${FG_BLUE}🔄 Prüfe auf Updates...${RESET}"
    if npm update -g @openai/codex 2>/dev/null; then
      echo "${FG_GREEN}✅ Codex CLI aktualisiert.${RESET}"
    else
      echo "${FG_YELLOW}⚠️ Update-Prüfung fehlgeschlagen oder bereits aktuell.${RESET}"
    fi
  else
    # Try to install, fix permissions if needed
    echo "${FG_BLUE}📦 Installiere OpenAI Codex CLI...${RESET}"
    
    if npm install -g @openai/codex 2>/dev/null; then
      echo "${FG_GREEN}✅ OpenAI Codex CLI erfolgreich installiert.${RESET}"
    else
      echo "${FG_YELLOW}⚠️ Permission-Fehler erkannt. Repariere npm Berechtigungen...${RESET}"
      
      if fix_npm_permissions; then
        # Retry installation
        echo "${FG_BLUE}🔄 Versuche Installation erneut...${RESET}"
        if npm install -g @openai/codex; then
          echo "${FG_GREEN}✅ OpenAI Codex CLI erfolgreich installiert nach Permission-Fix.${RESET}"
        else
          echo "${FG_RED}❌ Installation fehlgeschlagen auch nach Permission-Fix.${RESET}"
          show_npm_alternatives
          return
        fi
      else
        echo "${FG_RED}❌ Permission-Fix fehlgeschlagen.${RESET}"
        show_npm_alternatives
        return
      fi
    fi
  fi
  
  show_codex_installation_success
}

show_npm_alternatives() {
  echo ""
  echo "${FG_CYAN}🔧 Alternative Lösungen:${RESET}"
  echo ""
  echo "${FG_YELLOW}1) NVM verwenden (Empfohlen):${RESET}"
  echo "   • Dev Tools > Install NVM"
  echo "   • Terminal neu starten"
  echo "   • nvm install node && nvm use node"
  echo "   • Dann AI Tools erneut versuchen"
  echo ""
  echo "${FG_YELLOW}2) Manuelle npm Konfiguration:${RESET}"
  echo "   • mkdir ~/.npm-global"
  echo "   • npm config set prefix '~/.npm-global'"
  echo "   • echo 'export PATH=~/.npm-global/bin:\$PATH' >> ~/.bashrc"
  echo "   • source ~/.bashrc"
  echo ""
  echo "${FG_YELLOW}3) sudo (nicht empfohlen, aber funktioniert):${RESET}"
  echo "   • sudo npm install -g @anthropic-ai/claude-code"
  echo "   • sudo npm install -g @openai/codex"
  echo ""
  read -p "Möchtest du eine dieser Lösungen jetzt versuchen? (y/N): " try_fix
  if [[ "$try_fix" =~ ^[Yy]$ ]]; then
    echo "${FG_CYAN}Wähle eine Lösung:${RESET}"
    echo "1) NVM installieren (über Dev Tools Menü)"
    echo "2) Manuelle npm Konfiguration"
    echo "3) Mit sudo installieren (unsicher)"
    echo ""
    read -p "Option (1-3): " fix_choice
    case "$fix_choice" in
      1)
        echo "${FG_BLUE}🔄 Wechsle zu Dev Tools Menü für NVM Installation...${RESET}"
        echo "${FG_CYAN}💡 Nach NVM Installation: Terminal neu starten und AI Tools erneut versuchen.${RESET}"
        ;;
      2)
        fix_npm_permissions
        ;;
      3)
        echo "${FG_RED}⚠️ sudo Installation nicht empfohlen, aber hier die Befehle:${RESET}"
        echo "sudo npm install -g @anthropic-ai/claude-code"
        echo "sudo npm install -g @openai/codex"
        ;;
    esac
  fi
}

show_claude_installation_success() {
  if command -v claude &> /dev/null; then
    echo ""
    echo "${FG_CYAN}📊 Installation erfolgreich:${RESET}"
    CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "Version nicht verfügbar")
    echo "  • Version: $CLAUDE_VERSION"
    echo "  • Pfad: $(which claude)"
    echo ""
    echo "${FG_CYAN}🔑 Authentication Setup:${RESET}"
    echo "  • ${FG_GREEN}Empfohlen${RESET}: claude, dann /login (Browser-Authentifizierung)"
    echo "  • ${FG_YELLOW}Optional${RESET}: export ANTHROPIC_API_KEY=\"sk-ant-...\""
    echo ""
    echo "${FG_CYAN}💡 Erste Schritte:${RESET}"
    echo "  • claude (Interaktiver Modus starten)"
    echo "  • /login (Im interaktiven Modus einloggen)"
    echo "  • /help (Alle verfügbaren Befehle anzeigen)"
    echo "  • /init (Projekt mit CLAUDE.md initialisieren)"
  fi
}

show_codex_installation_success() {
  if command -v codex &> /dev/null; then
    echo ""
    echo "${FG_CYAN}📊 Installation erfolgreich:${RESET}"
    CODEX_VERSION=$(codex --version 2>/dev/null || echo "Version nicht verfügbar")
    echo "  • Version: $CODEX_VERSION"
    echo "  • Pfad: $(which codex)"
    echo ""
    echo "${FG_CYAN}🔑 API Key Setup ${FG_RED}ERFORDERLICH${RESET}:${RESET}"
    echo "  • Manuell: export OPENAI_API_KEY=\"sk-...\""
    echo "  • Dauerhaft: Echo-Befehl in ~/.bashrc"
    echo "  • Pro Projekt: .env Datei mit OPENAI_API_KEY=sk-..."
    echo ""
    echo "${FG_CYAN}💡 Erste Schritte:${RESET}"
    echo "  • codex --help (Hilfe anzeigen)"
    echo "  • codex (Interaktiver Modus)"
    echo "  • codex \"explain this code\" (Direkter Befehl)"
  fi
}

initialize_claude_project() {
  echo "${FG_CYAN}📁 Initialize Project with Claude Code${RESET}"
  
  # Check if Claude Code is installed
  if ! command -v claude &> /dev/null; then
    echo "${FG_RED}❌ Claude Code CLI ist nicht installiert.${RESET}"
    echo "${FG_CYAN}💡 Installiere es zuerst über Option 1.${RESET}"
    return
  fi
  
  # Get project name
  echo ""
  read -p "🔤 Projektname: " PROJECT_NAME
  if [ -z "$PROJECT_NAME" ]; then
    echo "${FG_RED}❌ Projektname darf nicht leer sein.${RESET}"
    return
  fi

  PROJECT_PATH="$PROJECTS_DIR/$PROJECT_NAME"
  
  # Check if project already exists
  if [ -d "$PROJECT_PATH" ]; then
    echo "${FG_YELLOW}📁 Projekt '$PROJECT_NAME' existiert bereits.${RESET}"
    echo "${FG_CYAN}💡 Füge Claude Code Konfiguration zum bestehenden Projekt hinzu...${RESET}"
    cd "$PROJECT_PATH" || return
    PROJECT_EXISTS=true
  else
    echo "${FG_BLUE}📁 Erstelle neues Projekt: $PROJECT_NAME${RESET}"
    mkdir -p "$PROJECT_PATH"
    cd "$PROJECT_PATH" || return
    PROJECT_EXISTS=false
  fi

  # Only create basic project structure if it's a new project
  if [ "$PROJECT_EXISTS" = false ]; then
    # Initialize Git if not already initialized
    if [ ! -d ".git" ]; then
      echo "${FG_BLUE}🔧 Initialisiere Git Repository...${RESET}"
      git init -b main
    fi

    echo "${FG_BLUE}📄 Erstelle Projektdateien...${RESET}"
    
    # README.md (only if it doesn't exist)
    if [ ! -f "README.md" ]; then
      cat > README.md << EOF
# $PROJECT_NAME

AI-powered development project initialized with Claude Code.

## Setup

1. Install dependencies (if needed)
2. Start Claude Code: \`claude\`
3. Use \`/login\` for authentication
4. Use \`/init\` to setup Claude project files

## Usage

\`\`\`bash
# Interactive mode
claude

# Login (browser-based)
/login

# Initialize Claude project
/init

# Direct commands
claude "implement a feature"
claude "fix bugs in this code"
claude "add tests for components"
\`\`\`

## Development

This project is designed to work with Claude Code for AI-assisted development.
Use the CLAUDE.md file to provide specific instructions to the AI.
EOF
    fi

    # Package.json (only if it doesn't exist)
    if [ ! -f "package.json" ]; then
      echo "${FG_BLUE}📦 Erstelle package.json...${RESET}"
      cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "AI-powered development project with Claude Code",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "node --watch index.js",
    "test": "echo \\"Error: no test specified\\" && exit 1"
  },
  "keywords": ["ai", "claude-code", "development"],
  "author": "",
  "license": "MIT"
}
EOF
    fi

    # Basic index.js (only if it doesn't exist)
    if [ ! -f "index.js" ]; then
      cat > index.js << 'EOF'
// AI-powered project with Claude Code
console.log('Hello from your Claude Code project!');
console.log('Use "claude" command to start developing with AI assistance.');

// Example: Start Claude Code and use these commands:
// claude
// /login (for authentication)
// /init (to setup project-specific Claude files)
// "implement a web server with Express"
// "add database connection"
// "implement user authentication"
EOF
    fi
  fi

  # Always add/update Claude Code specific files
  echo "${FG_BLUE}🤖 $([ "$PROJECT_EXISTS" = true ] && echo "Aktualisiere" || echo "Erstelle") Claude Code Konfiguration...${RESET}"
  
  # Create .claude directory for project settings
  mkdir -p .claude

  # Project-specific Claude settings
  cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "defaultMode": "allowEdits",
    "allow": [
      "Bash(npm run *)",
      "Bash(git *)",
      "Read(*)",
      "Write(*)",
      "Edit(*)"
    ]
  },
  "includeCoAuthoredBy": true,
  "env": {
    "NODE_ENV": "development"
  }
}
EOF

  # CLAUDE.md for project-specific instructions
  cat > CLAUDE.md << EOF
# $PROJECT_NAME - Claude Code Instructions

## Project Overview
Brief description of what this project does and its main goals.

## Development Guidelines
- Follow modern JavaScript/TypeScript best practices
- Write comprehensive tests for new features
- Use semantic commit messages
- Keep code readable and well-documented

## Project Structure
Describe your project structure here:
- \`src/\` - Source code
- \`tests/\` - Test files
- \`docs/\` - Documentation
- \`config/\` - Configuration files

## Code Style
- Follow existing code style in the project
- Use meaningful variable and function names
- Add comments for complex logic
- Prefer functional programming patterns where appropriate

## Testing Strategy
- Write unit tests for all functions
- Add integration tests for API endpoints
- Use meaningful test descriptions
- Aim for good test coverage

## Git Workflow
- Create feature branches for new work
- Write clear commit messages
- Review changes before committing
- Keep commits atomic and focused

## AI Assistant Instructions
When working on this project:
1. Always read the existing code structure first
2. Follow the established patterns and conventions
3. Ask for clarification if project requirements are unclear
4. Suggest improvements where appropriate
5. Keep security and performance in mind

## Specific Guidelines
Add any project-specific instructions here:
- API patterns to follow
- Database schema considerations
- Third-party integrations
- Performance requirements
- Security considerations
EOF

  # Update .gitignore (add Claude Code specific entries if not present)
  if [ -f ".gitignore" ]; then
    # Add Claude Code entries if not already present
    if ! grep -q "claude/settings.local.json" .gitignore; then
      echo "" >> .gitignore
      echo "# Claude Code" >> .gitignore
      echo ".claude/settings.local.json" >> .gitignore
    fi
  else
    # Create comprehensive .gitignore
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.pnp
.pnp.js

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Claude Code
.claude/settings.local.json

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/
*.tgz
*.tar.gz

# IDEs
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
.DS_Store?
._*
Thumbs.db

# Database
*.db
*.sqlite

# Temporary files
tmp/
temp/
EOF
  fi

  # Optional: API Key setup (nur falls im Script konfiguriert)
  if [ -n "$ANTHROPIC_API_KEY_PRESET" ] && [ ! -f ".env" ]; then
    echo "${FG_BLUE}🔑 Erstelle .env Datei...${RESET}"
    cat > .env << EOF
# Anthropic Configuration (Optional - Claude Code kann auch Browser-Login)
ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY_PRESET}

# Add your other environment variables here
EOF
  fi

  # Commit changes if git repository exists
  if [ -d ".git" ] && command -v git &> /dev/null; then
    echo "${FG_BLUE}📝 Committe Claude Code Setup...${RESET}"
    git add .
    if [ "$PROJECT_EXISTS" = true ]; then
      git commit -m "Add Claude Code configuration

- Added .claude/settings.json for project configuration
- Created CLAUDE.md with project-specific AI instructions
- Updated .gitignore for Claude Code files" 2>/dev/null || echo "${FG_YELLOW}⚠️ Git commit fehlgeschlagen (möglicherweise keine Änderungen).${RESET}"
    else
      git commit -m "Initial commit: Claude Code project setup

- Added README.md with project documentation
- Created .claude/settings.json for project configuration
- Added comprehensive .gitignore
- Created CLAUDE.md with project-specific AI instructions
- Set up basic Node.js project structure" 2>/dev/null || echo "${FG_YELLOW}⚠️ Git commit fehlgeschlagen.${RESET}"
    fi
  fi

  # Success message
  echo ""
  if [ "$PROJECT_EXISTS" = true ]; then
    echo "${FG_GREEN}🎉 Claude Code erfolgreich zu bestehendem Projekt '$PROJECT_NAME' hinzugefügt!${RESET}"
  else
    echo "${FG_GREEN}🎉 Neues Projekt '$PROJECT_NAME' mit Claude Code erstellt!${RESET}"
  fi
  echo ""
  echo "${FG_CYAN}📊 Projekt-Information:${RESET}"
  echo "  📁 Pfad: $PROJECT_PATH"
  echo "  🤖 AI Tool: Claude Code (Anthropic)"
  echo "  📝 Konfiguration: .claude/settings.json"
  echo "  📖 Memory: CLAUDE.md"
  echo "  🔑 Auth: $([ -n "$ANTHROPIC_API_KEY_PRESET" ] && echo "API Key + Browser Login" || echo "Browser Login (/login)")"
  echo ""
  echo "${FG_CYAN}💡 Nächste Schritte:${RESET}"
  echo "  1. ${FG_YELLOW}cd $PROJECT_PATH${RESET}"
  echo "  2. ${FG_YELLOW}claude${RESET} - Starte Claude Code"
  echo "  3. ${FG_YELLOW}/login${RESET} - Authentifizierung (Browser)"
  echo "  4. ${FG_YELLOW}/init${RESET} - Claude Projekt-Setup (optional)"
  echo "  5. Bearbeite CLAUDE.md für projektspezifische Anweisungen"
  if [ "$PROJECT_EXISTS" = false ]; then
    echo "  6. ${FG_YELLOW}npm install${RESET} - Falls du npm-Pakete brauchst"
  fi
}

initialize_codex_project() {
  echo "${FG_CYAN}📁 Initialize Project with OpenAI Codex${RESET}"
  
  # Check if Codex is installed
  if ! command -v codex &> /dev/null; then
    echo "${FG_RED}❌ OpenAI Codex CLI ist nicht installiert.${RESET}"
    echo "${FG_CYAN}💡 Installiere es zuerst über Option 2.${RESET}"
    return
  fi
  
  # Get project name
  echo ""
  read -p "🔤 Projektname: " PROJECT_NAME
  if [ -z "$PROJECT_NAME" ]; then
    echo "${FG_RED}❌ Projektname darf nicht leer sein.${RESET}"
    return
  fi

  PROJECT_PATH="$PROJECTS_DIR/$PROJECT_NAME"
  
  # Check if project already exists
  if [ -d "$PROJECT_PATH" ]; then
    echo "${FG_YELLOW}📁 Projekt '$PROJECT_NAME' existiert bereits.${RESET}"
    echo "${FG_CYAN}💡 Füge OpenAI Codex Konfiguration zum bestehenden Projekt hinzu...${RESET}"
    cd "$PROJECT_PATH" || return
    PROJECT_EXISTS=true
  else
    echo "${FG_BLUE}📁 Erstelle neues Projekt: $PROJECT_NAME${RESET}"
    mkdir -p "$PROJECT_PATH"
    cd "$PROJECT_PATH" || return
    PROJECT_EXISTS=false
  fi

  # Only create basic project structure if it's a new project
  if [ "$PROJECT_EXISTS" = false ]; then
    # Initialize Git if not already initialized
    if [ ! -d ".git" ]; then
      echo "${FG_BLUE}🔧 Initialisiere Git Repository...${RESET}"
      git init -b main
    fi

    echo "${FG_BLUE}📄 Erstelle Projektdateien...${RESET}"
    
    # README.md (only if it doesn't exist)
    if [ ! -f "README.md" ]; then
      cat > README.md << EOF
# $PROJECT_NAME

AI-powered development project initialized with OpenAI Codex CLI.

## Setup

1. Install dependencies: \`npm install\` (if Node.js project)
2. Set up environment variables in \`.env\`
3. Start development with Codex: \`codex\`

## Usage

\`\`\`bash
# Interactive mode
codex

# Direct commands
codex "implement a feature"
codex "fix bugs in this code"
codex "add tests for components"

# Different approval modes
codex --approval-mode auto-edit "refactor this code"
codex --approval-mode full-auto "create a todo app"
\`\`\`

## Development

This project is designed to work with OpenAI Codex for AI-assisted development.
Use the AGENTS.md file to provide specific instructions to the AI.
EOF
    fi

    # Package.json (only if it doesn't exist)
    if [ ! -f "package.json" ]; then
      echo "${FG_BLUE}📦 Erstelle package.json...${RESET}"
      cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "AI-powered development project with OpenAI Codex",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "node --watch index.js",
    "test": "echo \\"Error: no test specified\\" && exit 1"
  },
  "keywords": ["ai", "codex", "openai", "development"],
  "author": "",
  "license": "MIT"
}
EOF
    fi

    # Basic index.js (only if it doesn't exist)
    if [ ! -f "index.js" ]; then
      cat > index.js << 'EOF'
// AI-powered project with OpenAI Codex
console.log('Hello from your OpenAI Codex project!');
console.log('Use "codex" command to start developing with AI assistance.');

// Example: Ask Codex to help you build features
// codex "create a web server with Express"
// codex "add database connection with MongoDB"
// codex "implement user authentication with JWT"
// codex "add input validation middleware"
EOF
    fi
  fi

  # Always add/update Codex specific files
  echo "${FG_BLUE}🤖 $([ "$PROJECT_EXISTS" = true ] && echo "Aktualisiere" || echo "Erstelle") OpenAI Codex Konfiguration...${RESET}"

  # AGENTS.md for Codex instructions
  cat > AGENTS.md << EOF
# Project-Specific Codex Instructions

## Project: $PROJECT_NAME

### Development Guidelines
- Follow modern JavaScript/TypeScript best practices
- Write comprehensive tests for new features
- Use semantic commit messages
- Keep code readable and well-documented

### Project Structure
- Describe your project structure here
- Add any specific patterns or conventions
- Include framework-specific guidelines

### Code Style
- Follow existing code style in the project
- Use meaningful variable and function names
- Add comments for complex logic
- Prefer functional programming patterns

### Testing
- Write unit tests for all functions
- Add integration tests for API endpoints
- Use meaningful test descriptions
- Aim for good test coverage

### Git Workflow
- Create feature branches for new work
- Write clear commit messages
- Review changes before committing
- Keep commits atomic and focused

### Security Guidelines
- Never log sensitive information
- Validate all user inputs
- Use environment variables for secrets
- Follow OWASP best practices

### Performance Considerations
- Optimize for readability first, then performance
- Use appropriate data structures
- Cache expensive operations where beneficial
- Monitor and measure performance impacts

### Specific Instructions
Add any project-specific instructions for Codex here:
- API patterns to follow
- Database schema considerations
- Third-party integrations
- Deployment requirements
EOF

  # Update .gitignore (add Codex specific entries if not present)
  if [ -f ".gitignore" ]; then
    # Add Codex entries if not already present
    if ! grep -q ".codex/" .gitignore; then
      echo "" >> .gitignore
      echo "# Codex" >> .gitignore
      echo ".codex/" >> .gitignore
    fi
  else
    # Create comprehensive .gitignore
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.pnpm-lock.yaml
.pnp
.pnp.js

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# Build outputs
dist/
build/
*.tgz
*.tar.gz

# IDEs
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
.DS_Store?
._*
Thumbs.db

# Database
*.db
*.sqlite

# Temporary files
tmp/
temp/

# Codex
.codex/
EOF
  fi

  # .env file with API key (only if it doesn't exist)
  if [ ! -f ".env" ]; then
    echo "${FG_BLUE}🔑 Erstelle .env Datei...${RESET}"
    cat > .env << EOF
# OpenAI Configuration (REQUIRED for Codex CLI)
OPENAI_API_KEY=${OPENAI_API_KEY_PRESET}

# Add your other environment variables here
EOF
  elif [ -n "$OPENAI_API_KEY_PRESET" ]; then
    # Update existing .env if API key is set in script but not in .env
    if ! grep -q "OPENAI_API_KEY" .env; then
      echo "OPENAI_API_KEY=${OPENAI_API_KEY_PRESET}" >> .env
      echo "${FG_BLUE}🔑 API Key zu bestehender .env Datei hinzugefügt.${RESET}"
    fi
  fi

  # Commit changes if git repository exists
  if [ -d ".git" ] && command -v git &> /dev/null; then
    echo "${FG_BLUE}📝 Committe OpenAI Codex Setup...${RESET}"
    git add .
    if [ "$PROJECT_EXISTS" = true ]; then
      git commit -m "Add OpenAI Codex configuration

- Created AGENTS.md with Codex instructions
- Updated .gitignore for Codex files
- Added/updated .env with API key configuration" 2>/dev/null || echo "${FG_YELLOW}⚠️ Git commit fehlgeschlagen (möglicherweise keine Änderungen).${RESET}"
    else
      git commit -m "Initial commit: OpenAI Codex project setup

- Added README.md with project documentation
- Created .env file for API keys
- Added comprehensive .gitignore
- Created AGENTS.md with Codex instructions
- Set up basic Node.js project structure" 2>/dev/null || echo "${FG_YELLOW}⚠️ Git commit fehlgeschlagen.${RESET}"
    fi
  fi

  # Test API key setup
  echo "${FG_BLUE}🧪 Teste API Key Setup...${RESET}"
  if [ -n "$OPENAI_API_KEY_PRESET" ]; then
    export OPENAI_API_KEY="$OPENAI_API_KEY_PRESET"
    echo "${FG_GREEN}✅ API Key aus Script-Konfiguration geladen.${RESET}"
  else
    echo "${FG_RED}❌ Kein API Key im Script konfiguriert.${RESET}"
    echo "${FG_CYAN}💡 Bearbeite die Variable OPENAI_API_KEY_PRESET im Script.${RESET}"
    echo "${FG_CYAN}💡 Oder setze: export OPENAI_API_KEY=\"sk-...\"${RESET}"
  fi

  # Success message
  echo ""
  if [ "$PROJECT_EXISTS" = true ]; then
    echo "${FG_GREEN}🎉 OpenAI Codex erfolgreich zu bestehendem Projekt '$PROJECT_NAME' hinzugefügt!${RESET}"
  else
    echo "${FG_GREEN}🎉 Neues Projekt '$PROJECT_NAME' mit OpenAI Codex erstellt!${RESET}"
  fi
  echo ""
  echo "${FG_CYAN}📊 Projekt-Information:${RESET}"
  echo "  📁 Pfad: $PROJECT_PATH"
  echo "  🤖 AI Tool: OpenAI Codex CLI"
  echo "  📝 Konfiguration: AGENTS.md"
  echo "  🔑 API Key: $([ -n "$OPENAI_API_KEY_PRESET" ] && echo "✅ Konfiguriert" || echo "❌ Nicht gesetzt")"
  echo ""
  echo "${FG_CYAN}💡 Nächste Schritte:${RESET}"
  echo "  1. ${FG_YELLOW}cd $PROJECT_PATH${RESET}"
  echo "  2. ${FG_YELLOW}codex${RESET} - Starte interaktiven AI-Modus"
  echo "  3. ${FG_YELLOW}codex \"analyze this project structure\"${RESET}"
  echo "  4. Bearbeite AGENTS.md für projektspezifische Anweisungen"
  if [ "$PROJECT_EXISTS" = false ]; then
    echo "  5. ${FG_YELLOW}npm install${RESET} - Falls du npm-Pakete brauchst"
  fi
  echo ""
  if [ "$PROJECT_EXISTS" = false ]; then
    echo "${FG_CYAN}🔒 Codex Approval Modi:${RESET}"
    echo "  • ${FG_GREEN}suggest${RESET} (Standard) - Schlägt vor, fragt nach Bestätigung"
    echo "  • ${FG_YELLOW}auto-edit${RESET} - Bearbeitet Dateien automatisch"
    echo "  • ${FG_RED}full-auto${RESET} - Vollautomatisch (sandboxed)"
  fi
}

suggest_vscode_extensions() {
  echo "${FG_GREEN}💡 Empfohlene VS Code Extensions:${RESET}"
  echo "- GitHub Copilot"
  echo "- Python"
  echo "- Docker"
  echo "- Prettier"
  echo "- ESLint"
  echo "- GitLens"
  echo "- Live Server"
  echo "- Auto Rename Tag"
  echo "- Bracket Pair Colorizer"
  echo ""
  echo "${FG_CYAN}Möchtest du diese Extensions automatisch installieren? (y/n)${RESET}"
  read -p "> " install_ext
  if [[ "$install_ext" =~ ^[Yy]$ ]]; then
    if command -v code &> /dev/null; then
      echo "${FG_BLUE}📦 Installiere Extensions...${RESET}"
      code --install-extension GitHub.copilot
      code --install-extension ms-python.python
      code --install-extension ms-azuretools.vscode-docker
      code --install-extension esbenp.prettier-vscode
      code --install-extension dbaeumer.vscode-eslint
      code --install-extension eamodio.gitlens
      code --install-extension ritwickdey.liveserver
      code --install-extension formulahendry.auto-rename-tag
      echo "${FG_GREEN}✅ Extensions installiert.${RESET}"
    else
      echo "${FG_RED}❌ VS Code nicht gefunden. Bitte zuerst installieren.${RESET}"
    fi
  fi
}

check_tool_status() {
  echo ""
  echo "${FG_CYAN}🔎 Tool Status Check:${RESET}"
  echo "------------------------"
  
  # Array von Tools zum Prüfen
  tools=("code:VS Code" "git:Git" "gh:GitHub CLI" "docker:Docker" "node:Node.js" "python3:Python" "pip3:pip" "mysql:MySQL" "dbeaver:DBeaver" "google-chrome:Chrome" "chromium-browser:Chromium" "postman:Postman" "nvm:NVM" "pyenv:pyenv" "zsh:Zsh" "terminator:Terminator" "tree:Tree" "7z:7zip" "filezilla:FileZilla" "terraform:Terraform" "az:Azure CLI" "sqlite3:SQLite" "redis-server:Redis" "claude:Claude Code" "codex:Codex CLI")
  
  for tool_info in "${tools[@]}"; do
    tool="${tool_info%%:*}"
    name="${tool_info##*:}"
    if command -v "$tool" &> /dev/null; then
      version=$($tool --version 2>/dev/null | head -n1)
      echo "${FG_GREEN}✅ $name ist installiert${RESET} ${FG_CYAN}($version)${RESET}"
    else
      echo "${FG_RED}❌ $name fehlt${RESET}"
    fi
  done
  echo "------------------------"
  echo ""
}

show_help_menu() {
  while true; do
    clear
    echo "${FG_CYAN}📚 IAMYB Dev Setup - Help & Documentation${RESET}"
    echo "${FG_CYAN}============================================${RESET}"
    echo ""
    echo "1) 🔧 Development Tools Help"
    echo "2) 🤖 AI Tools Setup Guide"
    echo "3) 📁 GitHub & Project Management"
    echo "4) 🗄️ Database & Environment Setup"
    echo "5) 🔑 API Keys & Authentication"
    echo "6) 🐛 Troubleshooting & Common Issues"
    echo "7) 💡 Best Practices & Tips"
    echo "8) 📋 System Requirements"
    echo "9) 🔗 Useful Links & Resources"
    echo "10) Zurück zum Hauptmenü"
    echo ""

    read -p "Wähle ein Help-Thema (1–10): " help_choice
    case "$help_choice" in
      1) show_dev_tools_help ;;
      2) show_ai_tools_help ;;
      3) show_github_help ;;
      4) show_database_help ;;
      5) show_api_keys_help ;;
      6) show_troubleshooting_help ;;
      7) show_best_practices_help ;;
      8) show_system_requirements_help ;;
      9) show_useful_links_help ;;
      10) break ;;
      *) echo "${FG_RED}❌ Ungültige Auswahl. Bitte 1–10 wählen.${RESET}"; sleep 2 ;;
    esac
    if [ "$help_choice" != "10" ]; then
      read -p "⏎ Zurück zum Help-Menü mit Enter..."
    fi
  done
}

show_dev_tools_help() {
  clear
  echo "${FG_CYAN}🔧 Development Tools Help${RESET}"
  echo "${FG_CYAN}=========================${RESET}"
  echo ""
  echo "${FG_GREEN}📦 Available Development Tools:${RESET}"
  echo ""
  echo "${FG_YELLOW}Code Editors & IDEs:${RESET}"
  echo "  • VS Code - Lightweight, extensible code editor"
  echo "  • Extensions - GitHub Copilot, Python, Docker, etc."
  echo ""
  echo "${FG_YELLOW}Version Control:${RESET}"
  echo "  • Git - Distributed version control system"
  echo "  • GitHub CLI - Command-line tool for GitHub"
  echo ""
  echo "${FG_YELLOW}Programming Languages:${RESET}"
  echo "  • Node.js & npm - JavaScript runtime and package manager"
  echo "  • Python3 & pip - Python interpreter and package installer"
  echo "  • Version Managers: NVM (Node), pyenv (Python)"
  echo ""
  echo "${FG_YELLOW}Development Tools:${RESET}"
  echo "  • Docker - Containerization platform"
  echo "  • Postman - API testing tool"
  echo "  • DBeaver - Universal database tool"
  echo ""
  echo "${FG_YELLOW}System Tools:${RESET}"
  echo "  • Zsh + Oh My Zsh - Enhanced shell experience"
  echo "  • Terminator - Advanced terminal emulator"
  echo "  • OpenSSH - Secure shell access"
  echo "  • 7zip - File archiver"
  echo "  • Tree - Directory structure viewer"
  echo "  • FileZilla - FTP/SFTP client"
  echo ""
  echo "${FG_YELLOW}Cloud & Infrastructure:${RESET}"
  echo "  • Terraform - Infrastructure as Code"
  echo "  • Azure CLI - Microsoft cloud management"
  echo ""
  echo "${FG_CYAN}💡 Installation Tips:${RESET}"
  echo "  • Install tools individually based on your project needs"
  echo "  • Version managers (NVM, pyenv) allow multiple language versions"
  echo "  • Use 'Status Check' to verify installations"
}

show_ai_tools_help() {
  clear
  echo "${FG_CYAN}🤖 AI Tools Setup Guide${RESET}"
  echo "${FG_CYAN}=======================${RESET}"
  echo ""
  echo "${FG_GREEN}🔵 Claude Code (Anthropic):${RESET}"
  echo ""
  echo "${FG_YELLOW}Claude Code CLI:${RESET}"
  echo "  • Command-line AI assistant for coding"
  echo "  • Installation: npm install -g @anthropic-ai/claude-code"
  echo "  • Usage: 'claude' (interactive) or 'claude \"task\"'"
  echo "  • Authentication: Browser-Login (/login) oder API Key"
  echo ""
  echo "${FG_YELLOW}Claude API Key:${RESET}"
  echo "  • Optional für Claude Code CLI"
  echo "  • Get from: https://console.anthropic.com/settings/keys"
  echo "  • Set as: ANTHROPIC_API_KEY environment variable"
  echo ""
  echo "${FG_GREEN}🟠 OpenAI Codex CLI:${RESET}"
  echo ""
  echo "${FG_YELLOW}Codex CLI:${RESET}"
  echo "  • OpenAI's command-line coding assistant"
  echo "  • Installation: npm install -g @openai/codex"
  echo "  • Usage: 'codex' (interactive) or 'codex \"task\"'"
  echo "  • Approval Modi: suggest, auto-edit, full-auto"
  echo "  • GitHub: https://github.com/openai/codex"
  echo ""
  echo "${FG_YELLOW}OpenAI API Key:${RESET}"
  echo "  • ERFORDERLICH für Codex CLI"
  echo "  • Get from: https://platform.openai.com/api-keys"
  echo "  • Set as: OPENAI_API_KEY environment variable"
  echo "  • Format: sk-..."
  echo ""
  echo "${FG_YELLOW}Features:${RESET}"
  echo "  • Zero-setup installation"
  echo "  • Multimodal inputs (text, screenshots, diagrams)"
  echo "  • Rich approval workflow mit verschiedenen Modi"
  echo "  • Sandboxed execution in full-auto mode"
  echo "  • AGENTS.md/CLAUDE.md files für custom instructions"
  echo ""
  echo "${FG_CYAN}💡 Setup Recommendations:${RESET}"
  echo "  • Choose Claude OR OpenAI based on your project"
  echo "  • Start with 'suggest' mode für safety"
  echo "  • Claude Code: Browser-Login bevorzugt"
  echo "  • OpenAI Codex: API Key zwingend erforderlich"
}

show_github_help() {
  clear
  echo "${FG_CYAN}📁 GitHub & Project Management Help${RESET}"
  echo "${FG_CYAN}==================================${RESET}"
  echo ""
  echo "${FG_GREEN}🔧 GitHub CLI Setup:${RESET}"
  echo ""
  echo "${FG_YELLOW}Authentication Methods:${RESET}"
  echo "  1. Browser (Recommended)"
  echo "     • Automatic web browser authentication"
  echo "     • Most secure and user-friendly"
  echo ""
  echo "  2. Personal Access Token"
  echo "     • Manual token creation and input"
  echo "     • Good for CI/CD or headless environments"
  echo "     • Required scopes: repo, workflow, write:packages"
  echo ""
  echo "  3. SSH Key"
  echo "     • Uses existing SSH keys"
  echo "     • Good for advanced users"
  echo ""
  echo "${FG_GREEN}📋 Project Bootstrap Features:${RESET}"
  echo ""
  echo "${FG_YELLOW}Automatic Setup:${RESET}"
  echo "  • Creates project directory in ~/Dev/projects/"
  echo "  • Generates professional README.md"
  echo "  • Comprehensive .gitignore for multiple languages"
  echo "  • Initializes Git repository with main branch"
  echo "  • Creates GitHub repository (private/public choice)"
  echo "  • Links local and remote repositories"
  echo ""
  echo "${FG_YELLOW}Smart Features:${RESET}"
  echo "  • Checks for existing repositories"
  echo "  • Offers to clone instead of create"
  echo "  • Handles repository conflicts"
  echo "  • Shows next steps after creation"
  echo ""
  echo "${FG_CYAN}💡 Best Practices:${RESET}"
  echo "  • Use descriptive project names"
  echo "  • Start with private repos for personal projects"
  echo "  • Edit README.md after project creation"
  echo "  • Use meaningful commit messages"
}

show_database_help() {
  clear
  echo "${FG_CYAN}🗄️ Database & Environment Setup Help${RESET}"
  echo "${FG_CYAN}====================================${RESET}"
  echo ""
  echo "${FG_GREEN}📊 Available Databases:${RESET}"
  echo ""
  echo "${FG_YELLOW}MySQL:${RESET}"
  echo "  • Full-featured relational database"
  echo "  • Server: Complete MySQL installation"
  echo "  • Client: For connecting to remote MySQL servers"
  echo "  • Service management: Start/Stop/Status"
  echo "  • Security: Run 'sudo mysql_secure_installation'"
  echo ""
  echo "${FG_YELLOW}SQLite:${RESET}"
  echo "  • Lightweight, file-based database"
  echo "  • Perfect for development and small applications"
  echo "  • No server setup required"
  echo "  • Usage: sqlite3 database.db"
  echo ""
  echo "${FG_YELLOW}Redis:${RESET}"
  echo "  • In-memory data structure store"
  echo "  • Used for caching, sessions, pub/sub"
  echo "  • Service management: Start/Stop/Status"
  echo "  • Default port: 6379"
  echo ""
  echo "${FG_GREEN}🔧 Database Tools:${RESET}"
  echo ""
  echo "${FG_YELLOW}DBeaver:${RESET}"
  echo "  • Universal database GUI tool"
  echo "  • Supports MySQL, PostgreSQL, SQLite, and more"
  echo "  • Visual query builder and data editor"
  echo "  • Perfect for database administration"
  echo ""
  echo "${FG_GREEN}☁️ Cloud & DevOps:${RESET}"
  echo ""
  echo "${FG_YELLOW}Terraform:${RESET}"
  echo "  • Infrastructure as Code tool"
  echo "  • Manage cloud resources declaratively"
  echo "  • Supports AWS, Azure, GCP, and more"
  echo ""
  echo "${FG_YELLOW}Azure CLI:${RESET}"
  echo "  • Microsoft Azure command-line interface"
  echo "  • Manage Azure resources from terminal"
  echo "  • Login: az login"
  echo ""
  echo "${FG_CYAN}💡 Service Management Tips:${RESET}"
  echo "  • Use 'Check Services Status' to monitor running services"
  echo "  • Start services only when needed to save resources"
  echo "  • Configure services to start on boot if used regularly"
}

show_api_keys_help() {
  clear
  echo "${FG_CYAN}🔑 API Keys & Authentication Help${RESET}"
  echo "${FG_CYAN}=================================${RESET}"
  echo ""
  echo "${FG_GREEN}🤖 AI API Keys:${RESET}"
  echo ""
  echo "${FG_YELLOW}Claude (Anthropic):${RESET}"
  echo "  • Environment Variable: ANTHROPIC_API_KEY"
  echo "  • Get from: https://console.anthropic.com/settings/keys"
  echo "  • Used by: Claude Code CLI"
  echo "  • Format: sk-ant-api03-..."
  echo "  • Status: OPTIONAL (Browser-Login verfügbar)"
  echo ""
  echo "${FG_YELLOW}OpenAI:${RESET}"
  echo "  • Environment Variable: OPENAI_API_KEY"
  echo "  • Get from: https://platform.openai.com/api-keys"
  echo "  • Used by: Codex CLI, ChatGPT API"
  echo "  • Format: sk-..."
  echo "  • Status: ERFORDERLICH für Codex CLI"
  echo ""
  echo "${FG_GREEN}🔧 GitHub Authentication:${RESET}"
  echo ""
  echo "${FG_YELLOW}Personal Access Token:${RESET}"
  echo "  • Create at: https://github.com/settings/tokens/new"
  echo "  • Required Scopes:"
  echo "    ✅ repo (Full control of private repositories)"
  echo "    ✅ workflow (Update GitHub Action workflows)"
  echo "    ✅ write:packages (Upload packages)"
  echo "  • Expiration: 90 days recommended"
  echo "  • Store securely and don't share"
  echo ""
  echo "${FG_GREEN}🔒 Security Best Practices:${RESET}"
  echo ""
  echo "${FG_YELLOW}Environment Variables:${RESET}"
  echo "  • Store in ~/.bashrc or ~/.zshrc"
  echo "  • Never commit to version control"
  echo "  • Use .env files for project-specific keys"
  echo "  • Add .env to .gitignore"
  echo ""
  echo "${FG_YELLOW}Key Management:${RESET}"
  echo "  • Use different keys for different projects"
  echo "  • Rotate keys regularly"
  echo "  • Revoke unused keys immediately"
  echo "  • Monitor key usage in provider dashboards"
  echo ""
  echo "${FG_CYAN}💡 Usage Tips:${RESET}"
  echo "  • Test keys after setup with simple API calls"
  echo "  • Check rate limits and quotas"
  echo "  • Monitor API usage and costs"
  echo "  • Use separate keys for development and production"
}

show_troubleshooting_help() {
  clear
  echo "${FG_CYAN}🐛 Troubleshooting & Common Issues${RESET}"
  echo "${FG_CYAN}==================================${RESET}"
  echo ""
  echo "${FG_GREEN}🔧 Installation Issues:${RESET}"
  echo ""
  echo "${FG_YELLOW}Chrome Installation Failed:${RESET}"
  echo "  Problem: Dependency conflicts or architecture issues"
  echo "  Solution: Script auto-installs Chromium as fallback"
  echo "  Manual: sudo apt install chromium-browser"
  echo ""
  echo "${FG_YELLOW}Node.js Version Issues:${RESET}"
  echo "  Problem: Wrong Node.js version for tools"
  echo "  Solution: Use NVM to manage versions"
  echo "  Commands: nvm install 22, nvm use 22"
  echo ""
  echo "${FG_YELLOW}Permission Errors:${RESET}"
  echo "  Problem: sudo errors or permission denied"
  echo "  Solution: Fix npm permissions or use version managers"
  echo "  Docs: https://docs.npmjs.com/resolving-eacces-permissions-errors"
  echo ""
  echo "${FG_GREEN}🔐 Authentication Issues:${RESET}"
  echo ""
  echo "${FG_YELLOW}GitHub CLI Browser Not Opening:${RESET}"
  echo "  Problem: Browser detection fails"
  echo "  Solution: Use manual URL or Personal Access Token"
  echo "  URL: https://github.com/login/device"
  echo ""
  echo "${FG_YELLOW}API Key Not Working:${RESET}"
  echo "  Problem: Key not properly set or expired"
  echo "  Solution: Check environment variables"
  echo "  Test: echo \$ANTHROPIC_API_KEY"
  echo "  Fix: source ~/.bashrc"
  echo ""
  echo "${FG_GREEN}🗄️ Database Issues:${RESET}"
  echo ""
  echo "${FG_YELLOW}MySQL Won't Start:${RESET}"
  echo "  Problem: Port conflicts or configuration issues"
  echo "  Solution: Check status and logs"
  echo "  Commands:"
  echo "    sudo systemctl status mysql"
  echo "    sudo journalctl -u mysql"
  echo "    sudo systemctl restart mysql"
  echo ""
  echo "${FG_YELLOW}Redis Connection Refused:${RESET}"
  echo "  Problem: Redis not running or wrong port"
  echo "  Solution: Start Redis service"
  echo "  Commands:"
  echo "    sudo systemctl start redis-server"
  echo "    redis-cli ping"
  echo ""
  echo "${FG_GREEN}🤖 AI Tools Issues:${RESET}"
  echo ""
  echo "${FG_YELLOW}Claude Code Not Found:${RESET}"
  echo "  Problem: Installation failed or PATH issues"
  echo "  Solution: Reinstall or check PATH"
  echo "  Commands:"
  echo "    npm list -g @anthropic-ai/claude-code"
  echo "    npm install -g @anthropic-ai/claude-code"
  echo ""
  echo "${FG_CYAN}💡 General Troubleshooting:${RESET}"
  echo "  • Check 'Status Check' for tool availability"
  echo "  • Restart terminal after PATH changes"
  echo "  • Update package lists: sudo apt update"
  echo "  • Check system logs: journalctl"
  echo "  • Verify internet connection for downloads"
}

show_best_practices_help() {
  clear
  echo "${FG_CYAN}💡 Best Practices & Tips${RESET}"
  echo "${FG_CYAN}========================${RESET}"
  echo ""
  echo "${FG_GREEN}🚀 Development Workflow:${RESET}"
  echo ""
  echo "${FG_YELLOW}Project Setup:${RESET}"
  echo "  • Use consistent project structure in ~/Dev/projects/"
  echo "  • Start with private repositories for experiments"
  echo "  • Write meaningful README.md files"
  echo "  • Use descriptive commit messages"
  echo "  • Set up .gitignore before first commit"
  echo ""
  echo "${FG_YELLOW}Version Management:${RESET}"
  echo "  • Use NVM for Node.js versions per project"
  echo "  • Use pyenv for Python versions per project"
  echo "  • Document required versions in README"
  echo "  • Use .nvmrc files for Node version consistency"
  echo ""
  echo "${FG_GREEN}🔒 Security Best Practices:${RESET}"
  echo ""
  echo "${FG_YELLOW}API Keys & Secrets:${RESET}"
  echo "  • Never commit API keys to version control"
  echo "  • Use environment variables for secrets"
  echo "  • Add .env to .gitignore immediately"
  echo "  • Rotate keys regularly"
  echo "  • Use different keys for dev/staging/production"
  echo ""
  echo "${FG_YELLOW}SSH & Authentication:${RESET}"
  echo "  • Use SSH keys instead of passwords"
  echo "  • Enable 2FA on GitHub and cloud providers"
  echo "  • Use strong, unique passwords"
  echo "  • Keep authentication tokens secure"
  echo ""
  echo "${FG_GREEN}🗄️ Database Best Practices:${RESET}"
  echo ""
  echo "${FG_YELLOW}Development Databases:${RESET}"
  echo "  • Use SQLite for local development"
  echo "  • Use Docker for consistent database environments"
  echo "  • Backup databases before major changes"
  echo "  • Use database migrations for schema changes"
  echo "  • Never connect to production from development tools"
  echo ""
  echo "${FG_GREEN}🤖 AI Tools Best Practices:${RESET}"
  echo ""
  echo "${FG_YELLOW}Safe AI Usage:${RESET}"
  echo "  • Start with 'suggest' mode for new projects"
  echo "  • Review all AI-generated code before committing"
  echo "  • Use version control to track AI changes"
  echo "  • Test AI-generated code thoroughly"
  echo "  • Keep sensitive data out of AI prompts"
  echo ""
  echo "${FG_YELLOW}Prompt Engineering:${RESET}"
  echo "  • Be specific about requirements"
  echo "  • Provide context about your project"
  echo "  • Ask for explanations of generated code"
  echo "  • Iterate and refine prompts"
  echo "  • Use AGENTS.md/CLAUDE.md files for consistent guidance"
  echo ""
  echo "${FG_GREEN}⚡ Performance Tips:${RESET}"
  echo ""
  echo "${FG_YELLOW}System Performance:${RESET}"
  echo "  • Only run needed services (MySQL, Redis)"
  echo "  • Use lightweight alternatives when possible"
  echo "  • Monitor system resources with htop"
  echo "  • Clean up unused Docker containers/images"
  echo "  • Use SSD storage for development databases"
  echo ""
  echo "${FG_CYAN}💡 Pro Tips:${RESET}"
  echo "  • Use aliases for frequently used commands"
  echo "  • Set up dotfiles for consistent environment"
  echo "  • Learn keyboard shortcuts for your tools"
  echo "  • Automate repetitive tasks with scripts"
  echo "  • Keep learning new tools and techniques"
}

show_system_requirements_help() {
  clear
  echo "${FG_CYAN}📋 System Requirements${RESET}"
  echo "${FG_CYAN}=====================${RESET}"
  echo ""
  echo "${FG_GREEN}🖥️ Operating System:${RESET}"
  echo ""
  echo "${FG_YELLOW}Supported Systems:${RESET}"
  echo "  ✅ Ubuntu 20.04+ (Recommended)"
  echo "  ✅ Debian 10+"
  echo "  ✅ Linux Mint 20+"
  echo "  ✅ Pop!_OS 20.04+"
  echo "  ✅ Elementary OS 6+"
  echo "  ⚠️ Ubuntu derivatives (mostly compatible)"
  echo ""
  echo "${FG_GREEN}💻 Hardware Requirements:${RESET}"
  echo ""
  echo "${FG_YELLOW}Minimum Requirements:${RESET}"
  echo "  • CPU: 2+ cores (Intel/AMD x64 or ARM64)"
  echo "  • RAM: 4 GB (8 GB recommended)"
  echo "  • Storage: 10 GB free space"
  echo "  • Network: Internet connection for downloads"
  echo ""
  echo "${FG_YELLOW}Recommended Specifications:${RESET}"
  echo "  • CPU: 4+ cores, 2.5+ GHz"
  echo "  • RAM: 16 GB+ (for AI tools and databases)"
  echo "  • Storage: 50+ GB SSD"
  echo "  • Network: Broadband connection"
  echo ""
  echo "${FG_GREEN}📦 Pre-installed Software:${RESET}"
  echo ""
  echo "${FG_YELLOW}Usually Available:${RESET}"
  echo "  ✅ Python3 (on most Ubuntu systems)"
  echo "  ✅ Git (on most modern distributions)"
  echo "  ✅ curl/wget (on most systems)"
  echo "  ✅ Basic system tools"
  echo ""
  echo "${FG_YELLOW}May Need Installation:${RESET}"
  echo "  • Node.js & npm"
  echo "  • Docker"
  echo "  • Snap (if not available)"
  echo "  • Build tools (make, gcc)"
  echo ""
  echo "${FG_GREEN}🔧 Architecture Support:${RESET}"
  echo ""
  echo "${FG_YELLOW}Fully Supported:${RESET}"
  echo "  ✅ x86_64 (Intel/AMD 64-bit)"
  echo "  ✅ aarch64/arm64 (Apple Silicon, ARM servers)"
  echo ""
  echo "${FG_YELLOW}Limited Support:${RESET}"
  echo "  ⚠️ i386 (32-bit Intel) - Some tools unavailable"
  echo "  ⚠️ Other ARM variants - May require manual builds"
  echo ""
  echo "${FG_GREEN}🌐 Network Requirements:${RESET}"
  echo ""
  echo "${FG_YELLOW}Required Access:${RESET}"
  echo "  • GitHub.com (for repositories and CLI)"
  echo "  • NPM registry (for Node.js packages)"
  echo "  • Ubuntu/Debian package repositories"
  echo "  • API endpoints (for AI tools)"
  echo "  • Cloud provider APIs (Azure, etc.)"
  echo ""
  echo "${FG_CYAN}💡 Compatibility Notes:${RESET}"
  echo "  • Some tools may fallback to alternatives (Chrome → Chromium)"
  echo "  • Version managers (NVM, pyenv) handle multiple versions"
  echo "  • WSL2 support for Windows users (experimental)"
  echo "  • Docker can provide consistent environments"
}

show_useful_links_help() {
  clear
  echo "${FG_CYAN}🔗 Useful Links & Resources${RESET}"
  echo "${FG_CYAN}===========================${RESET}"
  echo ""
  echo "${FG_GREEN}🤖 AI Development Tools:${RESET}"
  echo ""
  echo "${FG_YELLOW}Claude (Anthropic):${RESET}"
  echo "  • Console: https://console.anthropic.com/"
  echo "  • API Keys: https://console.anthropic.com/settings/keys"
  echo "  • Documentation: https://docs.anthropic.com/"
  echo "  • Claude Code: https://docs.anthropic.com/claude-code"
  echo ""
  echo "${FG_YELLOW}OpenAI:${RESET}"
  echo "  • Platform: https://platform.openai.com/"
  echo "  • API Keys: https://platform.openai.com/api-keys"
  echo "  • Documentation: https://platform.openai.com/docs"
  echo "  • Codex CLI: https://github.com/openai/codex"
  echo ""
  echo "${FG_GREEN}🔧 Development Tools:${RESET}"
  echo ""
  echo "${FG_YELLOW}Version Control:${RESET}"
  echo "  • GitHub: https://github.com/"
  echo "  • GitHub CLI: https://cli.github.com/"
  echo "  • Git Documentation: https://git-scm.com/doc"
  echo "  • GitHub Tokens: https://github.com/settings/tokens"
  echo ""
  echo "${FG_YELLOW}Code Editors:${RESET}"
  echo "  • VS Code: https://code.visualstudio.com/"
  echo "  • VS Code Extensions: https://marketplace.visualstudio.com/"
  echo "  • VS Code Docs: https://code.visualstudio.com/docs"
  echo ""
  echo "${FG_GREEN}🗄️ Databases & Tools:${RESET}"
  echo ""
  echo "${FG_YELLOW}Database Tools:${RESET}"
  echo "  • DBeaver: https://dbeaver.io/"
  echo "  • MySQL: https://dev.mysql.com/doc/"
  echo "  • Redis: https://redis.io/documentation"
  echo "  • SQLite: https://sqlite.org/docs.html"
  echo ""
  echo "${FG_GREEN}☁️ Cloud & DevOps:${RESET}"
  echo ""
  echo "${FG_YELLOW}Infrastructure:${RESET}"
  echo "  • Terraform: https://www.terraform.io/docs"
  echo "  • Azure CLI: https://docs.microsoft.com/en-us/cli/azure/"
  echo "  • Docker: https://docs.docker.com/"
  echo ""
  echo "${FG_GREEN}📚 Learning Resources:${RESET}"
  echo ""
  echo "${FG_YELLOW}Programming Languages:${RESET}"
  echo "  • Node.js: https://nodejs.org/en/docs/"
  echo "  • Python: https://docs.python.org/3/"
  echo "  • JavaScript: https://developer.mozilla.org/en-US/docs/Web/JavaScript"
  echo ""
  echo "${FG_YELLOW}Version Managers:${RESET}"
  echo "  • NVM: https://github.com/nvm-sh/nvm"
  echo "  • pyenv: https://github.com/pyenv/pyenv"
  echo ""
  echo "${FG_GREEN}🛠️ System Tools:${RESET}"
  echo ""
  echo "${FG_YELLOW}Terminal & Shell:${RESET}"
  echo "  • Oh My Zsh: https://ohmyz.sh/"
  echo "  • Terminator: https://gnome-terminator.org/"
  echo "  • Zsh: https://www.zsh.org/"
  echo ""
  echo "${FG_GREEN}🆘 Support & Community:${RESET}"
  echo ""
  echo "${FG_YELLOW}Help & Documentation:${RESET}"
  echo "  • Ubuntu Documentation: https://help.ubuntu.com/"
  echo "  • Stack Overflow: https://stackoverflow.com/"
  echo "  • GitHub Issues: Report problems in respective repositories"
  echo ""
  echo "${FG_YELLOW}Communities:${RESET}"
  echo "  • Reddit: r/Ubuntu, r/programming, r/webdev"
  echo "  • Discord: Various programming communities"
  echo "  • IRC: #ubuntu, #node.js, #python"
  echo ""
  echo "${FG_CYAN}💡 Pro Tips:${RESET}"
  echo "  • Bookmark important documentation pages"
  echo "  • Join communities for your tech stack"
  echo "  • Follow official blogs and release notes"
  echo "  • Use RSS feeds for updates"
  echo "  • Contribute back to open source projects"
}

# MAIN MENU
while true; do
  clear
  echo "${FG_RED}"
  echo "██╗ █████╗ ███╗   ███╗██╗   ██╗██████╗ "
  echo "██║██╔══██╗████╗ ████║╚██╗ ██╔╝██╔══██╗"
  echo "██║███████║██╔████╔██║ ╚████╔╝ ██████╔╝"
  echo "██║██╔══██║██║╚██╔╝██║  ╚██╔╝  ██╔══██╗"
  echo "██║██║  ██║██║ ╚═╝ ██║   ██║   ██████╔╝"
  echo "╚═╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═════╝ "
  echo ""
  echo "═══════════════════════════════════════════"
  echo "    Ultimate Modular Dev Setup Script"
  echo "      by Yavuz Bogazci / iamyb.com"
  echo "═══════════════════════════════════════════"
  echo "${FG_CYAN}"
  echo "${RESET}"
  echo "${FG_CYAN}💻 IAMYB Ultimate Modular Dev Setup${RESET}"
  echo "${FG_CYAN}====================================${RESET}"
  echo ""
  echo "1) Dev Tools (einzeln auswählbar)"
  echo "2) Projektmanagement (GitHub Setup & Project Bootstrap)"
  echo "3) Database & Environment Management"
  echo "4) AI Development Tools Setup"
  echo "5) VS Code Extensions verwalten"
  echo "6) Status-Check installierter Tools"
  echo "7) Help & Documentation"
  echo "8) Exit"
  echo ""

  read -p "Bitte Option wählen (1-8): " choice
  case "$choice" in
    1) show_dev_tools_menu ;;
    2) setup_github_project ;;
    3) manage_env ;;
    4) show_ai_tools_menu ;;
    5) suggest_vscode_extensions ;;
    6) check_tool_status ;;
    7) show_help_menu ;;
    8)
      echo "${FG_YELLOW}👋 Auf Wiedersehen!${RESET}"
      break
      ;;
    *)
      echo "${FG_RED}❌ Ungültige Eingabe. Bitte 1–8 wählen.${RESET}"
      sleep 2
      ;;
  esac
  
  if [ "$choice" != "8" ]; then
    read -p "⏎ Weiter mit Enter..."
  fi
done