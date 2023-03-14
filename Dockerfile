FROM ubuntu:latest

# Add Box86 repository and key
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sSL https://itai-nelken.github.io/weekly-box86-debs/debian/KEY.gpg | apt-key add - && \
    echo "deb https://itai-nelken.github.io/weekly-box86-debs/debian/ buster main" > /etc/apt/sources.list.d/box86.list

# Install Box86 and required dependencies
RUN apt-get update && \
    apt-get install -y box86 git build-essential cmake libx11-dev libxext-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install SteamCMD and CS:GO
RUN mkdir /steamcmd && \
    cd /steamcmd && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - && \
    ./steamcmd.sh +login anonymous +force_install_dir /csgo +app_update 740 validate +quit

# Set working directory
WORKDIR /csgo

# Set environment variables for Box86
ENV LD_LIBRARY_PATH=/usr/local/lib/box86

# Run SteamCMD and CS:GO in Box86
CMD ["box86", "./steamcmd.sh", "+login", "anonymous", "+app_run", "740", "-game", "csgo_linux64", "-novid"]
