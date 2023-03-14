FROM debian:buster-slim

# Install required dependencies
RUN apt-get update && \
    apt-get install -y curl git build-essential cmake libx11-dev libxext-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download precompiled Box86 and Box64 binaries
RUN wget "https://github.com/ptitSeb/box86/releases/download/v1.1.1/box86_1.1.1.tar.gz" && \
    tar zxvf box86_1.1.1.tar.gz && \
    mv box86 /usr/local/bin/ && \
    rm box86_1.1.1.tar.gz && \
    wget "https://github.com/ptitSeb/box64/releases/download/v1.2.1/box64_1.2.1.tar.gz" && \
    tar zxvf box64_1.2.1.tar.gz && \
    mv box64 /usr/local/bin/ && \
    rm box64_1.2.1.tar.gz'

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
