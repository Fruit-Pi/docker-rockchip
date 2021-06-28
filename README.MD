## OS requirements

To install Docker, you need the 64-bit version of one of these Ubuntu versions:

* Bionic 18.04 (LTS)
* Xenial 16.04 (LTS)
* Trusty 14.04 (LTS)

Note: the dockerfile is used for arm64 socs by default.

The below is used for arm32 Socs:
    cp dockerfile-32 dcokerfile

## Install Docker

Use this command to install the latest version of Docker(replace docker with docker.io in ubuntu 14.04):

	apt-get install docker qemu-user-static binfmt-support

Start run Docker deamon:

	service docker start

Build Docker image by dockerfile:

	sudo docker build -t rockchip .

Now you get a Docker image named "rockchip" which include a debian multiarch cross-compiling enviroment.

## Build application

1) Enter docker shell:

		docker run -it -v <package dir>:/home/rk/packages rockchip /bin/bash

2) Start build:

for arm 32bit Socs：<br>

```
		cd /home/rk/packages/<package-name>
		DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -rfakeroot -b -d -uc -us -aarmhf
		ls ../ | grep *.deb
```

for arm 64bit Socs：<br>

```
		cd /home/rk/packages/<package-name>
		DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -rfakeroot -b -d -uc -us -aarm64
		ls ../ | grep *.deb
```

## Modify image

If you want to modify your Docker image, you can open a shell by below command:

```
	docker run -it rockchip /bin/bash

```

After exit from container, you should use below command to save your changes.

```
	docker commit  <container_id> rockchip

```

## Others

To get more informations about dockers, please check below link:
https://docs.docker.com
