#!/bin/bash
# Start noVNC Web Client for BAI SVM Environment

set -e

echo "🌐 Starting noVNC web client..."

# Wait for VNC server to be ready
echo "⏳ Waiting for VNC server..."
timeout=30
while [ $timeout -gt 0 ]; do
    if nc -z localhost 5901; then
        echo "✅ VNC server is ready"
        break
    fi
    sleep 1
    timeout=$((timeout - 1))
done

if [ $timeout -eq 0 ]; then
    echo "❌ VNC server is not responding after 30 seconds"
    exit 1
fi

# Start websockify to bridge VNC and WebSocket
echo "🔌 Starting websockify bridge..."
websockify --web /usr/share/novnc 6080 localhost:5901 &

# Store the PID
WEBSOCKIFY_PID=$!

echo "✅ noVNC started successfully"
echo "🌐 Web interface: http://localhost:6080"
echo "🔐 Password: vscode"
echo "📱 Mobile friendly interface available"

# Function to handle shutdown
cleanup() {
    echo "🛑 Shutting down noVNC..."
    kill $WEBSOCKIFY_PID 2>/dev/null || true
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Keep the script running
wait $WEBSOCKIFY_PID