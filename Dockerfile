FROM ubuntu:latest

# Install required dependencies
RUN apt-get update && \
    apt-get install -y curl git build-essential cmake libx11-dev libxext-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev box86 box64 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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
