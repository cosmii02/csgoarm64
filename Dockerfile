# Use the latest Ubuntu image
FROM ubuntu:latest

# Install required dependencies
RUN apt-get update && \
    apt-get install -y curl git build-essential cmake libx11-dev libxext-dev libxrandr-dev libxinerama-dev libxcursor-dev wget gnupg python3 python3-pip

# Install SteamCMD
RUN mkdir /steamcmd && \
    cd /steamcmd && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - && \
    box86 ./steamcmd.sh +login anonymous +force_install_dir /csgo +app_update 740 validate +quit

# Set working directory
WORKDIR /csgo

# Set environment variable for Box86
ENV LD_LIBRARY_PATH=/usr/lib/box86

# Run CS:GO server in Box86
CMD ["box86", "./srcds_linux", "-game", "csgo", "-console", "-usercon", "+game_type", "0", "+game_mode", "1", "+mapgroup", "mg_active", "+map", "de_dust2"]