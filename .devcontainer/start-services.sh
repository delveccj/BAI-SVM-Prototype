#!/bin/bash
# Start services script for BAI SVM Environment
# This script runs every time the container starts

set -e

echo "🚀 Starting BAI SVM Environment Services..."

# Function to check if a port is in use
check_port() {
    local port=$1
    if nc -z localhost $port 2>/dev/null; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Function to wait for a service to start
wait_for_service() {
    local port=$1
    local service_name=$2
    local timeout=30
    
    echo "⏳ Waiting for $service_name (port $port)..."
    while [ $timeout -gt 0 ]; do
        if check_port $port; then
            echo "✅ $service_name is ready on port $port"
            return 0
        fi
        sleep 1
        timeout=$((timeout - 1))
    done
    echo "⚠️  $service_name did not start within 30 seconds"
    return 1
}

# Start VNC server if not already running
if ! check_port 5901; then
    echo "🖥️  Starting VNC server..."
    bash /opt/startup/start-vnc.sh > /tmp/vnc.log 2>&1 &
    sleep 3
else
    echo "✅ VNC server already running"
fi

# Start noVNC web client if not already running
if ! check_port 6080; then
    echo "🌐 Starting noVNC web client..."
    bash /opt/startup/start-novnc.sh > /tmp/novnc.log 2>&1 &
    wait_for_service 6080 "noVNC"
else
    echo "✅ noVNC already running"
fi

# Set up environment for the user
echo "🔧 Setting up user environment..."

# Ensure proper permissions on VNC files
if [ -d ~/.vnc ]; then
    chmod 700 ~/.vnc
    chmod 600 ~/.vnc/passwd 2>/dev/null || true
fi

# Create workspace directories if they don't exist
mkdir -p ~/workspace
mkdir -p ~/Desktop

# Display service status
echo ""
echo "🎯 Service Status:"
echo "===================="
if check_port 5901; then
    echo "✅ VNC Server: Running (port 5901)"
else
    echo "❌ VNC Server: Not running"
fi

if check_port 6080; then
    echo "✅ noVNC Web: Running (port 6080)"
else
    echo "❌ noVNC Web: Not running"
fi

# Check optional services
if check_port 8000; then
    echo "✅ Professor Server: Running (port 8000)"
else
    echo "⚪ Professor Server: Not started (run 'prof' to start)"
fi

if check_port 8888; then
    echo "✅ Jupyter Lab: Running (port 8888)"
else
    echo "⚪ Jupyter Lab: Not started (run 'lab' to start)"
fi

echo ""
echo "🌐 Access URLs:"
echo "=================="
echo "🖥️  Desktop (noVNC): http://localhost:6080"
echo "📊 Professor Dashboard: http://localhost:8000"
echo "📝 Jupyter Lab: http://localhost:8888"
echo ""
echo "🔐 VNC Password: vscode"
echo ""
echo "💡 Quick Commands:"
echo "   prof    - Start professor server"
echo "   student - Connect to professor"
echo "   lab     - Start Jupyter Lab"
echo ""

# Optional: Auto-start Jupyter Lab if SVM_Demo.ipynb exists
if [ -f "SVM_Demo.ipynb" ] && ! check_port 8888; then
    echo "📚 Found SVM_Demo.ipynb, auto-starting Jupyter Lab..."
    nohup jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root > /tmp/jupyter.log 2>&1 &
    sleep 3
    if check_port 8888; then
        echo "✅ Jupyter Lab started automatically"
    fi
fi

echo "🎉 All services started successfully!"