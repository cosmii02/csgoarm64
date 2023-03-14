FROM ubuntu:latest

# Install required dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y curl git build-essential cmake libx11-dev libxext-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev:i386

# Download and extract box86 source from v0.3.0 release
RUN curl -LO "https://github.com/ptitSeb/box86/archive/refs/tags/v0.3.0.tar.gz" && \
    tar zxvf v0.3.0.tar.gz && \
    mv box86-0.3.0 box86 && \
    rm v0.3.0.tar.gz

# Build and install box86
RUN cd box86 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf box86

# Clone and build Box64 from source
RUN git clone https://github.com/ptitSeb/box64.git && \
    cd box64 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf box64

# Install SteamCMD and CS:GO
RUN mkdir /steamcmd && \
    cd /steamcmd && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - && \
    ./steamcmd.sh +login anonymous +force_install_dir /csgo +app_update 740 validate +quit

# Set working directory
WORKDIR /csgo

# Set environment variables for Box64
ENV LD_LIBRARY_PATH=/usr/local/lib/box64
ENV BOX64_PATH=/usr/local/bin/box64

# Run SteamCMD and CS:GO in Box86 and Box64, respectively
CMD ["box86", "./steamcmd.sh", "+login", "anonymous", "+app_run", "740", "-game", "csgo_linux64", "-novid"]
