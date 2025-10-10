# Start with Ubuntu base with desktop environment
FROM mcr.microsoft.com/devcontainers/python:1-3.11-bullseye

# Install system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        # Basic desktop environment (XFCE - lightweight)
        xfce4 \
        xfce4-goodies \
        xfce4-terminal \
        # VNC server
        tigervnc-standalone-server \
        tigervnc-common \
        # Web-based VNC client
        novnc \
        websockify \
        # Essential utilities
        dbus-x11 \
        at-spi2-core \
        # Browser for web access
        firefox-esr \
        # File manager
        thunar \
        # Text editor
        gedit \
        # Image viewer
        ristretto \
        # Archive manager
        file-roller \
        # System monitor
        htop \
        # Network tools
        net-tools \
        # Additional development tools
        git \
        curl \
        wget \
        vim \
        nano \
        # For matplotlib and other GUI apps
        python3-tk \
        # Audio support (optional)
        pulseaudio \
        alsa-utils \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Create VNC directories
RUN mkdir -p /home/vscode/.vnc \
    && chown -R vscode:vscode /home/vscode/.vnc

# Set up VNC password for user vscode
RUN echo "vscode" | vncpasswd -f > /home/vscode/.vnc/passwd \
    && chmod 600 /home/vscode/.vnc/passwd \
    && chown vscode:vscode /home/vscode/.vnc/passwd

# Configure XFCE as default desktop
RUN echo "startxfce4" > /home/vscode/.vnc/xstartup \
    && chmod +x /home/vscode/.vnc/xstartup \
    && chown vscode:vscode /home/vscode/.vnc/xstartup

# Install additional Python packages for ML/AI work
RUN pip install --no-cache-dir \
    numpy==1.24.3 \
    pandas==2.0.3 \
    scikit-learn==1.3.0 \
    matplotlib==3.7.2 \
    seaborn==0.12.2 \
    jupyter==1.0.0 \
    jupyterlab==4.0.5 \
    plotly==5.15.0 \
    ipywidgets==8.0.7 \
    flask==2.3.2 \
    flask-socketio==5.3.4 \
    requests==2.31.0 \
    websockets==11.0.3 \
    python-dotenv==1.0.0 \
    gitpython==3.1.32 \
    psutil==5.9.5

# Set up desktop environment configuration
USER vscode
WORKDIR /home/vscode

# Create desktop shortcuts
RUN mkdir -p /home/vscode/Desktop \
    && mkdir -p /home/vscode/.config/xfce4/xfconf/xfce-perchannel-xml

# Configure XFCE panel and desktop
COPY --chown=vscode:vscode .devcontainer/xfce4-config/ /home/vscode/.config/xfce4/

# Expose ports
EXPOSE 5901 6080 8000 8888 5000

# Switch back to root for final setup
USER root

# Create startup script directory
RUN mkdir -p /opt/startup

# Copy startup scripts
COPY .devcontainer/start-vnc.sh /opt/startup/
COPY .devcontainer/start-novnc.sh /opt/startup/
RUN chmod +x /opt/startup/*.sh

# Set environment variables
ENV DISPLAY=:1 \
    VNC_RESOLUTION=1920x1080 \
    VNC_COLOR_DEPTH=24 \
    VNC_DPI=96 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Back to vscode user
USER vscode
WORKDIR /workspaces/BAI-SVM-Prototype

# Default command
CMD ["/bin/bash"]