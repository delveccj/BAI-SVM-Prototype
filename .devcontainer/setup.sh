#!/bin/bash
# Post-create setup script for BAI SVM Environment
# This script runs after the container is created

set -e

echo "🚀 Setting up BAI SVM Development Environment..."

# Update package lists
echo "📦 Updating package lists..."
sudo apt-get update

# Install any additional packages that might be needed
echo "🔧 Installing additional tools..."
sudo apt-get install -y \
    tree \
    jq \
    unzip \
    zip \
    netcat \
    telnet

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
if [ -f requirements.txt ]; then
    pip install --no-cache-dir -r requirements.txt
    echo "✅ Python dependencies installed from requirements.txt"
else
    echo "⚠️  No requirements.txt found, skipping Python dependencies"
fi

# Make scripts executable
echo "🔐 Setting script permissions..."
chmod +x .devcontainer/*.sh

# Create desktop shortcuts
echo "🖥️  Setting up desktop environment..."
mkdir -p ~/Desktop

# Create desktop shortcut for Jupyter Lab
cat > ~/Desktop/jupyter-lab.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Jupyter Lab
Comment=Launch Jupyter Lab for ML Development
Exec=bash -c 'cd /workspaces/BAI-SVM-Prototype && jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root'
Icon=applications-science
Terminal=true
Categories=Development;Education;
EOF

# Create desktop shortcut for Professor Server
cat > ~/Desktop/professor-server.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Professor Server
Comment=Start the Professor Dashboard Server
Exec=bash -c 'cd /workspaces/BAI-SVM-Prototype && python server/professor_server.py'
Icon=applications-internet
Terminal=true
Categories=Development;Education;Network;
EOF

# Create desktop shortcut for Student Connection
cat > ~/Desktop/student-connect.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Connect to Professor
Comment=Connect to Professor's Dashboard
Exec=bash -c 'cd /workspaces/BAI-SVM-Prototype && python student/connect_to_professor.py'
Icon=applications-internet
Terminal=true
Categories=Development;Education;Network;
EOF

# Make desktop files executable
chmod +x ~/Desktop/*.desktop

# Set up Git configuration (if not already set)
echo "📝 Configuring Git..."
if [ -z "$(git config --global user.name)" ]; then
    if [ -n "$GITHUB_USER" ]; then
        git config --global user.name "$GITHUB_USER"
        echo "✅ Git user.name set to: $GITHUB_USER"
    else
        echo "⚠️  GITHUB_USER not set, please configure git manually"
    fi
fi

if [ -z "$(git config --global user.email)" ]; then
    if [ -n "$GITHUB_USER" ]; then
        git config --global user.email "$GITHUB_USER@users.noreply.github.com"
        echo "✅ Git user.email set to: $GITHUB_USER@users.noreply.github.com"
    else
        echo "⚠️  GITHUB_USER not set, please configure git email manually"
    fi
fi

# Create helpful aliases
echo "⚡ Setting up helpful aliases..."
cat >> ~/.bashrc << 'EOF'

# BAI SVM Environment Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'

# Project specific aliases
alias prof='cd /workspaces/BAI-SVM-Prototype && python server/professor_server.py'
alias student='cd /workspaces/BAI-SVM-Prototype && python student/connect_to_professor.py'
alias lab='cd /workspaces/BAI-SVM-Prototype && jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root'
alias notebook='cd /workspaces/BAI-SVM-Prototype && jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root'

# Display helpful information
echo "🎓 BAI SVM Environment Ready!"
echo "📚 Available commands:"
echo "  prof     - Start professor server"
echo "  student  - Connect to professor"
echo "  lab      - Start Jupyter Lab"
echo "  notebook - Start Jupyter Notebook"
echo ""
echo "🖥️  Desktop: http://localhost:6080 (password: vscode)"
echo "📊 Dashboard: http://localhost:8000"
echo "📝 Jupyter: http://localhost:8888"
echo ""
EOF

# Display setup completion message
echo ""
echo "✅ BAI SVM Environment Setup Complete!"
echo ""
echo "🎯 Quick Start Guide:"
echo "  1. Open desktop: http://localhost:6080 (password: vscode)"
echo "  2. Start Jupyter Lab: jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
echo "  3. For professor: python server/professor_server.py"
echo "  4. For student: python student/connect_to_professor.py"
echo ""
echo "📝 VS Code Extensions Installed:"
echo "  ✓ GitHub Copilot"
echo "  ✓ Live Share"
echo "  ✓ Python Development Stack"
echo "  ✓ Jupyter Support"
echo ""
echo "🖥️  Desktop Environment: XFCE4 (lightweight)"
echo "🔗 VNC Access: Port 5901"
echo "🌐 Web Access: Port 6080"
echo ""