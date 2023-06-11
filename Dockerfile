# Use the latest Ubuntu image
FROM ubuntu:latest

RUN rm -rf /etc/apt/sources.list

RUN echo "deb http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://archive.canonical.com/ubuntu/ jammy partner" >> /etc/apt/sources.list

# Install required dependencies
RUN apt-get update && \
    apt-get install -y curl git build-essential cmake libx11-dev libxext-dev libxrandr-dev libxinerama-dev libxcursor-dev wget gnupg python3 python3-pip

RUN apt-get update && \
    wget https://itai-nelken.github.io/weekly-box86-debs/debian/box86.list -O /etc/apt/sources.list.d/box86.list && \
    wget -qO- https://itai-nelken.github.io/weekly-box86-debs/debian/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg && \
    apt-get update && apt-get install box86 -y
    RUN box86 apt install libc6:i386

# Install SteamCMD
RUN mkdir /steamcmd && \
    cd /steamcmd && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - && \
    box86 ./steamcmd.sh +login anonymous +force_install_dir /csgo +app_update 740 validate +quit

# Set working directory
WORKDIR /csgo

# Run CS:GO server in Box86
CMD ["box86", "./srcds_linux", "-game", "csgo", "-console", "-usercon", "+game_type", "0", "+game_mode", "1", "+mapgroup", "mg_active", "+map", "de_dust2"]
