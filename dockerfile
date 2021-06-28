FROM debian:buster
MAINTAINER Caesar Wang "wxt@rock-chips.com"

# setup multiarch enviroment
RUN dpkg --add-architecture arm64
RUN echo "deb-src http://deb.debian.org/debian buster main" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.debian.org/debian buster-updates main" >> /etc/apt/sources.list
RUN echo "deb-src http://security.debian.org buster/updates main" >> /etc/apt/sources.list
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

#Openbox
RUN DEBIAN_FRONTEND=noninteractive apt-get install -f -y debhelper:arm64 gettext:arm64 libstartup-notification0-dev:arm64 libxrender-dev:arm64 libglib2.0-dev:arm64 libxml2-dev:arm64 perl libxt-dev:arm64 libxinerama-dev:arm64 libxrandr-dev:arm64 libpango1.0-dev:arm64 libx11-dev:arm64  autoconf:arm64 automake:arm64 libimlib2-dev:arm64 libxcursor-dev:arm64 autopoint:arm64 librsvg2-dev:arm64 libxi-dev:arm64

# rga
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libdrm-dev:arm64

## opencv
#
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y libopencv-ts-dev:arm64 libopencv-video-dev:arm64 libopencv-videostab-dev:arm64
RUN apt-get download libopencv-dev:arm64
RUN dpkg -x libopencv*.deb /

# gst-plugins-base
# TODO: Bug: /home/rk/packages/gst-plugins-base1.0-1.14.4/docs/libs/gst-plugins-base-libs-scan: line 117: /home/rk/packages/gst-plugins-base1.0-1.14.4/docs/libs/.libs/gst-plugins-base-libs-scan: Too many levels of symbolic links
#RUN apt-get install -y gnome-pkg-tools libgstreamer1.0-dev:arm64 libasound2-dev:arm64 libgudev-1.0-dev libwayland-dev:arm64 libgbm-dev:arm64 #wayland-protocols autotools-dev:arm64 automake autoconf libtool dh-autoreconf autopoint cdbs gtk-doc-tools libxv-dev libxt-dev libvorbis-#dev:arm64 libcdparanoia-dev:arm64 liborc-0.4-dev:arm64 libpango1.0-dev:arm64 libglib2.0-dev:arm64 zlib1g-dev:arm64 libvisual-0.4-dev:arm64 #iso-codes libgtk-3-dev:arm64 libglib2.0-doc gstreamer1.0-doc libgirepository1.0-dev:arm64 gobject-introspection gir1.2-glib-2.0 gir1.2-#freedesktop gir1.2-gstreamer-1.0 zlib1g-dev:arm64 libopus-dev:arm64 libgl1-mesa-dev:arm64 libegl1-mesa-dev:arm64 libgles2-mesa-dev:arm64 #libgraphene-1.0-dev:arm64 libpng-dev:arm64 libjpeg-dev:arm64

# gstreamer-rockchip
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y autotools-dev:arm64 libx11-dev:arm64 libdrm-dev:arm64 libgstreamer1.0-dev:arm64 \
        libgstreamer-plugins-base1.0-dev:arm64

# libmali
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libstdc++6:arm64 libgbm-dev:arm64 libdrm-dev:arm64 libx11-xcb1:arm64 libxcb-dri2-0:arm64 libxdamage1:arm64 \
        libxext6:arm64 libwayland-client0:arm64

#drm-cursor
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libgbm-dev:arm64 libegl1-mesa-dev:arm64 libgles2-mesa-dev:arm64

# xserver
# xf86-video-armsorc
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y xserver-xorg-dev:arm64 libaudit-dev:arm64 xtrans-dev:arm64 xfonts-utils:arm64 x11proto-dev:arm64 libxdmcp-dev:arm64 libxau-dev:arm64 libxdmcp-dev:arm64 libxfont-dev:arm64 libxkbfile-dev:arm64 libpixman-1-dev:arm64 libpciaccess-dev:arm64 libgcrypt-dev:arm64 nettle-dev:arm64 libudev-dev:arm64 libselinux1-dev:arm64 libaudit-dev:arm64 libgl1-mesa-dev:arm64 libunwind-dev:arm64 libxmuu-dev:arm64 libxext-dev:arm64 libx11-dev:arm64 libxrender-dev:arm64 libxi-dev:arm64 libdmx-dev:arm64 libxpm-dev:arm64 libxaw7-dev:arm64 libxt-dev:arm64 libxmu-dev:arm64 libxtst-dev:arm64 libxres-dev:arm64 libxfixes-dev:arm64 libxv-dev:arm64 libxinerama-dev:arm64 libxshmfence-dev:arm64 libepoxy-dev:arm64 libegl1-mesa-dev:arm64 libgbm-dev:arm64

RUN cp /usr/lib/pkgconfig/* /usr/lib/aarch64-linux-gnu/pkgconfig/
RUN apt-get update && apt-get install -y libxtst-dev:arm64

# FFmpeg

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y doxygen cleancss node-less ladspa-sdk
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y frei0r-plugins-dev:arm64 flite1-dev:arm64 libzmq3-dev:arm64 libass-dev:arm64 libbluray-dev:arm64 libbs2b-dev:arm64 libbz2-dev:arm64 libcaca-dev:arm64 libxvmc-dev:arm64 libcdio-paranoia-dev:arm64 libchromaprint-dev:arm64 libdc1394-22-dev:arm64 libdrm-dev:arm64 libfontconfig1-dev:arm64 libfreetype6-dev:arm64 libfribidi-dev:arm64 libgme-dev:arm64 libgsm1-dev:arm64 libiec61883-dev:arm64 libxvidcore-dev:arm64 libavc1394-dev:arm64 libjack-jackd2-dev:arm64 libleptonica-dev:arm64 liblzma-dev:arm64 libmp3lame-dev:arm64 libxcb-xfixes0-dev:arm64 libopenal-dev:arm64 libopencore-amrnb-dev:arm64 libzvbi-dev:arm64 libxcb-shm0-dev:arm64 libopencore-amrwb-dev:arm64 libopencv-imgproc-dev:arm64 libopenjp2-7-dev:arm64 libopenmpt-dev:arm64 libxml2-dev:arm64 libopus-dev:arm64 libpulse-dev:arm64 librubberband-dev:arm64 librsvg2-dev:arm64 libsctp-dev:arm64 libxcb-shape0-dev:arm64 libshine-dev:arm64 libsnappy-dev:arm64 libsoxr-dev:arm64 libspeex-dev:arm64 libssh-gcrypt-dev:arm64 libtesseract-dev:arm64 libtheora-dev:arm64 libtwolame-dev:arm64 libva-dev:arm64 libvdpau-dev:arm64 libx265-dev:arm64 libvo-amrwbenc-dev:arm64 libvorbis-dev:arm64 libvpx-dev:arm64 libwavpack-dev:arm64 libwebp-dev:arm64 libx264-dev:arm64 libgnutls28-dev:arm64 libaom-dev:arm64 liblilv-dev:arm64 libcodec2-dev:arm64 libmysofa-dev:arm64 libvidstab-dev:arm64 libsdl2-dev:arm64 liblensfun-dev:arm64 libgcrypt-dev:arm64 liblept5:arm64 libcrystalhd-dev

RUN apt-get install -y libomxil-bellagio-dev
RUN rm /var/lib/dpkg/info/libomxil-bellagio*

#RUN rm /usr/include/cdio/version.h

# Mpv
#RUN apt-get update && apt-get install -y libasound2-dev:arm64 libass-dev:arm64 libavcodec-dev:arm64 libavdevice-dev:arm64 \
#libavfilter-dev:arm64 libavformat-dev:arm64 libavresample-dev:arm64 libavutil-dev:arm64 libbluray-dev:arm64 libcaca-dev:arm64 \
#libcdio-paranoia-dev:arm64 libdvdnav-dev:arm64 libdvdread-dev:arm64 libegl1-mesa-dev:arm64 libgbm-dev:arm64 \
#libgl1-mesa-dev:arm64 libjack-dev:arm64 libjpeg-dev:arm64 liblcms2-dev:arm64 liblua5.2-dev:arm64 libpulse-dev:arm64 \
#librubberband-dev:arm64 libsdl2-dev:arm64 libsmbclient-dev:arm64 libsndio-dev:arm64 libswscale-dev:arm64 \
#libuchardet-dev:arm64 libva-dev:arm64 libvdpau-dev:arm64 libwayland-dev:arm64 libx11-dev:arm64 libxinerama-dev:arm64 \
#libxkbcommon-dev:arm64 libxrandr-dev:arm64 libxss-dev:arm64 libxv-dev:arm64 python3 python3-docutils wayland-protocols

# glmark2
RUN apt-get install -y debhelper-compat libjpeg-dev:arm64 libpng-dev:arm64 libudev-dev:arm64  libxcb1-dev:arm64 python3 wayland-protocols libwayland-dev libwayland-bin

## yocto
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y gawk wget git-core diffstat unzip texinfo chrpath socat xterm locales

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
