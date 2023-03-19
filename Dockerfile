# Use the latest Ubuntu image
FROM ubuntu:latest

# Install required dependencies
RUN apt-get update && \
    apt-get install -y curl git build-essential cmake libx11-dev libxext-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev:i386 wget gnupg

# Install Box86
RUN echo "deb http://itai-nelken.github.io/weekly-box86-debs/debian/ ./" > /etc/apt/sources.list.d/box86.list && \
    wget -qO- https://itai-nelken.github.io/weekly-box86-debs/debian/KEY.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y box86

# Install required dependencies for Box64
RUN apt-get install -y git build-essential cmake

# Clone, build, and install Box64
RUN git clone https://github.com/ptitSeb/box64.git && \
    cd box64 && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo -DARM_DYNAREC=ON && \
    make -j$(nproc) && \
    make install

# Install SteamCMD and CS:GO
RUN mkdir /steamcmd && \
    cd /steamcmd && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - && \
    ./steamcmd.sh +login anonymous +force_install_dir /csgo +app_update 740 validate +quit

# Set working directory
WORKDIR /csgo

# Set environment variables for Box86 and Box64
ENV LD_LIBRARY_PATH=/usr/local/lib/box64
ENV BOX64_PATH=/usr/local/bin/box64

# Run SteamCMD and CS:GO in Box86 and Box64, respectively
CMD ["box86", "./steamcmd.sh", "+login", "anonymous", "+app_run", "740", "-game", "csgo_linux64", "-novid"]
