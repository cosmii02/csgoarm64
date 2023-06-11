# Use the latest Ubuntu image
FROM weilbyte/box:arm64v8-debian-11


# Install required dependencies
RUN apt update && apt install -y curl git build-essential cmake libx11-dev libxext-dev libxrandr-dev libxinerama-dev libxcursor-dev wget gnupg python3 python3-pip

RUN apt-get update 
    RUN box86 apt install libc6:i386 \
# Install SteamCMD
RUN mkdir /steamcmd && \
    cd /steamcmd && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - && \
    box86 ./steamcmd.sh +login anonymous +force_install_dir /csgo +app_update 740 validate +quit

# Set working directory
WORKDIR /csgo

# Run CS:GO server in Box86
CMD ["box86", "./srcds_linux", "-game", "csgo", "-console", "-usercon", "+game_type", "0", "+game_mode", "1", "+mapgroup", "mg_active", "+map", "de_dust2"]
