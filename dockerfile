FROM debian:bullseye
MAINTAINER Caesar Wang "wxt@rock-chips.com"

# setup multiarch enviroment
RUN dpkg --add-architecture arm64
RUN echo "deb-src http://deb.debian.org/debian bullseye main" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.debian.org/debian bullseye-updates main" >> /etc/apt/sources.list
#RUN echo "deb-src http://security.debian.org bullseye/updates main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y crossbuild-essential-arm64

ADD ./overlay/  /

# perpare build dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y sudo locales git fakeroot devscripts cmake vim qemu-user-static:arm64 binfmt-support \
        dh-make dh-exec pkg-kde-tools device-tree-compiler:arm64 bc cpio parted dosfstools mtools libssl-dev:arm64 \
        g++-aarch64-linux-gnu dpkg-dev meson debhelper pkgconf

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get build-dep -y -a arm64 libdrm
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get build-dep -y -a arm64 xorg-server

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y gstreamer1.0-plugins-bad:arm64 gstreamer1.0-plugins-base:arm64 gstreamer1.0-tools:arm64 \
        gstreamer1.0-alsa:arm64 gstreamer1.0-plugins-base-apps:arm64 qtmultimedia5-examples:arm64

# rga
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libdrm-dev:arm64

# gstreamer-rockchip
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libx11-dev:arm64 libdrm-dev:arm64 libgstreamer1.0-dev:arm64 \
        libgstreamer-plugins-base1.0-dev:arm64

# libmali
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libstdc++6:arm64 libgbm-dev:arm64 libdrm-dev:arm64 libx11-xcb1:arm64 libxcb-dri2-0:arm64 libxdamage1:arm64 \
        libxext6:arm64 libwayland-client0:arm64

#drm-cursor
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libgbm-dev:arm64 libegl1-mesa-dev:arm64 libgles2-mesa-dev:arm64

# glmark2
RUN apt-get install -y debhelper-compat libjpeg-dev:arm64 libpng-dev:arm64 libudev-dev:arm64  libxcb1-dev:arm64 python3 wayland-protocols libwayland-dev libwayland-bin

# rktoolkit
#RUN apt install -y libmad-ocaml-dev libmad0-dev:arm64

# lib4l2
#RUN apt update -y
#RUN apt build-dep -y libv4l-dev:arm64

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN echo "Update Headers!"
RUN dpkg -i /packages/arm64/rga/*.deb
RUN dpkg -i /packages/arm64/mpp/*.deb
RUN apt-get install -fy --allow-downgrades /packages/arm64/gst-rkmpp/*.deb
RUN apt-get install -fy --allow-downgrades /packages/arm64/gstreamer/*.deb
RUN apt-get install -fy --allow-downgrades /packages/arm64/gst-plugins-base1.0/*.deb
RUN apt-get install -fy --allow-downgrades /packages/arm64/gst-plugins-bad1.0/*.deb
RUN apt-get install -fy --allow-downgrades /packages/arm64/gst-plugins-good1.0/*.deb

RUN apt-get install -fy --allow-downgrades /packages/arm64/libv4l/*.deb
#RUN dpkg -i /packages/arm64/gst-rkmpp/*.deb
#RUN dpkg -i /packages/arm64/ffmpeg/*.deb
#RUN dpkg -i /packages/arm64/libmali/libmali-midgard-t86x-r18p0-x11*.deb
RUN find /packages/arm64/libdrm -name '*.deb' | sudo xargs -I{} dpkg -x {} /

RUN apt-get update && apt-get install -y -f

# switch to a no-root user
RUN useradd -c 'rk user' -m -d /home/rk -s /bin/bash rk
RUN sed -i -e '/\%sudo/ c \%sudo ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
RUN usermod -a -G sudo rk

USER rk
