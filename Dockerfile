# Use the latest Alpine base image
FROM alpine:latest

# Install required packages and dependencies
RUN apk add --no-cache \
    bash \
    curl \
    gcc \
    g++ \
    make \
    python3 \
    python3-dev \
    git \
    linux-headers \
    libx11 libxext libxrender libxtst \
    libxrandr libxi libxmu \
    libxcursor libxinerama \
    virtualbox-ose

# Download and install VirtualBox
RUN curl -o /tmp/VirtualBox.run https://download.virtualbox.org/virtualbox/7.1.4/VirtualBox-7.1.4-165100-Linux_amd64.run \
    && chmod +x /tmp/VirtualBox.run \
    && /tmp/VirtualBox.run install \
    && rm -f /tmp/VirtualBox.run

# Clone and install Xpra
RUN git clone https://github.com/Xpra-org/xpra.git /xpra \
    && cd /xpra \
    && python3 setup.py install \
    && rm -rf /xpra

# Set the entry point to run VirtualBox with Xpra
CMD ["xpra", "start", ":100", "--start-via=xorg", "--monitor", "--daemon=no", "--exit-with-children", "--server-args='-no-sandbox'"]
