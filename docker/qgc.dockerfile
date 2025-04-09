FROM ubuntu:22.04


RUN apt-get update && apt-get install -y \
    fuse \
    libxcb-xinerama0 \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libopengl0 \
    libegl1-mesa \
    x11-xserver-utils \
    libgstreamer-plugins-base1.0-dev \
    libqt5gui5 \
    libsdl2-dev \
    locales \
    mesa-utils \
    x11-apps \
    wget \
    iputils-ping \
    netcat \
    && rm -rf /var/lib/apt/lists/*

RUN \
    groupadd user \
    && useradd -ms /bin/bash user -g user \
	&& usermod -a -G dialout user
USER user 
WORKDIR /home/user
RUN wget -P /home/user https://github.com/ingmarfjolla/ardupilot-ascon/releases/download/v1.0.0/QGroundControl-x86_64.AppImage

RUN chmod +x /home/user/QGroundControl-x86_64.AppImage
RUN chown -R user:user /home/user/QGroundControl-x86_64.AppImage


# Set up locale to UTF-8 for Qt
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DISPLAY=:0
ENV DISPLAY=:0

CMD ["/home/user/QGroundControl-x86_64.AppImage", "--appimage-extract-and-run"]
