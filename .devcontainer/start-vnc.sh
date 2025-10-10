#!/bin/bash
# Start VNC Server for BAI SVM Environment

set -e

echo "🖥️  Starting VNC server..."

# Set display
export DISPLAY=:1

# Kill any existing VNC servers
vncserver -kill :1 > /dev/null 2>&1 || true

# Create .vnc directory if it doesn't exist
mkdir -p ~/.vnc

# Set VNC password if not already set
if [ ! -f ~/.vnc/passwd ]; then
    echo "Setting VNC password..."
    echo "vscode" | vncpasswd -f > ~/.vnc/passwd
    chmod 600 ~/.vnc/passwd
fi

# Create xstartup file if it doesn't exist
if [ ! -f ~/.vnc/xstartup ]; then
    echo "Creating VNC startup script..."
    cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
    chmod +x ~/.vnc/xstartup
fi

# Set resolution from environment variable
RESOLUTION=${VNC_RESOLUTION:-1920x1080}
COLOR_DEPTH=${VNC_COLOR_DEPTH:-24}
DPI=${VNC_DPI:-96}

echo "📐 Resolution: ${RESOLUTION}"
echo "🎨 Color Depth: ${COLOR_DEPTH}"
echo "📏 DPI: ${DPI}"

# Start VNC server
vncserver :1 \
    -geometry ${RESOLUTION} \
    -depth ${COLOR_DEPTH} \
    -dpi ${DPI} \
    -localhost no \
    -SecurityTypes None \
    -rfbport 5901

echo "✅ VNC server started on :1 (port 5901)"
echo "🔗 Connect via VNC client to: localhost:5901"
echo "🌐 Or use web interface at: http://localhost:6080"

# Keep the script running
tail -f ~/.vnc/*.log