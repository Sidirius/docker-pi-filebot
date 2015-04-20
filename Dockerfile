FROM yujiod/rpi-ubuntu-trusty
MAINTAINER Sven Hartmann <sid@sh87.net>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

RUN apt-mark hold initscripts udev plymouth mountall
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/$

RUN apt-get update
RUN apt-get install -y --force-yes software-properties-common
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y --force-yes oracle-java8-installer
RUN apt-get install -y --force-yes openssh-server
RUN apt-get install -y --force-yes sudo
RUN apt-get install -y --force-yes wget
RUN apt-get install -y --force-yes binutils
RUN apt-get install -y --force-yes nano
RUN apt-get autoclean
RUN apt-get autoremove
RUN rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/filebot.ipk 'http://sourceforge.net/projects/filebot/files/filebot/FileBot_4.5.6/filebot_4.5.6_arm.ipk/download' \
        && cd /tmp/ \
        && ar -x filebot.ipk \
        && tar xzfv data.tar.gz \
        && cp -r /tmp/opt/share/* /usr/share/ \
        && ln -s /usr/share/filebot/bin/filebot.sh /usr/bin/filebot

ADD startup.sh /
EXPOSE 22
WORKDIR /
ENTRYPOINT ["/startup.sh"]

