### Pull base image
FROM resin/rpi-raspbian:latest
MAINTAINER Sven Hartmann <sid@sh87.net>

### Install Applications
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
# RUN echo "deb-src http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi" | tee --append /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --force-yes apt-utils
RUN apt-get update --fix-missing
### Install basics
RUN apt-get install -y --force-yes openssh-server sudo wget screen binutils nano 

### Install Java 8 and JNA
RUN apt-get install -y --force-yes openjdk-8-jdk libjna-java 
RUN mkdir /tmp/jna-4.0.0 && \
	cd /tmp/jna-4.0.0 && \
	wget --no-check-certificate 'https://maven.java.net/content/repositories/releases/net/java/dev/jna/jna/4.0.0/jna-4.0.0.jar' && \
	wget --no-check-certificate 'https://maven.java.net/content/repositories/releases/net/java/dev/jna/jna-platform/4.0.0/jna-platform-4.0.0.jar' && \
	cd /tmp/jna-4.0.0 && \
	cd /usr/share/java && \
	rm jna.jar && \
	cp /tmp/jna-4.0.0/*.jar . && \
	ln -s jna-4.0.0.jar jna.jar && \
	ln -s jna-platform-4.0.0.jar jna-platform.jar && \
	java -jar jna.jar
	
### Install dependencies for building p7zip and build p7zip
RUN apt-get install -y --force-yes bzip2 packaging-dev build-essential # debhelper dh-make quilt fakeroot lintian 
RUN cd /tmp && \
	wget --no-check-certificate -O p7zip_9.20.1_src_all.tar.bz2 'http://sourceforge.net/projects/p7zip/files/latest/download' && \
	tar jxvf p7zip_9.20.1_src_all.tar.bz2 && \
	cd p7zip_9.20.1/ && \
	make && \
	./install.sh

### Install filebot
RUN wget -O /tmp/filebot.ipk 'http://sourceforge.net/projects/filebot/files/filebot/FileBot_4.5.6/filebot_4.5.6_arm.ipk/download' \
        && cd /tmp/ \
        && ar -x filebot.ipk \
        && tar xzfv data.tar.gz \
        && cp -r /tmp/opt/share/* /usr/share/ \
        && ln -s /usr/share/filebot/bin/filebot.sh /usr/bin/filebot
		
### Configure filebot
RUN mv /usr/share/filebot/bin/filebot.sh /usr/share/filebot/bin/filebot.sh_old
ADD files/filebot.sh /usr/share/filebot/bin/

### Install and configure mediainfo
RUN apt-get install -y --force-yes mediainfo
RUN cd /usr/share/filebot && \
	mv libzen.so libzen.so_old && \
	mv libmediainfo.so libmediainfo.so_old && \
	ln -s /usr/lib/arm-linux-gnueabihf/libmediainfo.so.0 libmediainfo.so && \
	ln -s /usr/lib/arm-linux-gnueabihf/libzen.so.0 libzen.so
	
### Install filebot scripts
RUN mkdir -p /filebot && \
	cd /filebot && \
	git clone https://github.com/filebot/scripts.git

### Cleanup
RUN apt-get autoclean
RUN apt-get autoremove 
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

ADD startup.sh /
EXPOSE 22
WORKDIR /
ENTRYPOINT ["/startup.sh"]

