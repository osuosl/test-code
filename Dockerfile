#Load the base image from dockerhuh:
FROM ppc64le/ubuntu:16.04

### Owner
MAINTAINER Amit Ghatwal

RUN echo " Docker file for Ubuntu - sshd "
### Install Dependencies
RUN apt-get update
RUN apt-get install -y  openssh-server \
                        openjdk-8-jdk \
                        git \
                        sudo \
						apt-utils \
						git \
						python \
						make \
						gcc \
						g++ \
						openssl \
						build-essential
						
						
### Set env variables for Java
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk
ENV PATH $PATH:$JAVA_HOME/bin


RUN mkdir /var/run/sshd

RUN echo "create root user and password "

### Set Credentials
RUN echo "root:password" | chpasswd

#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config -- this is meant of < ubuntu 16.04
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


### SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"

#RUN mkdir /etc/sudoers.d/
RUN echo "export VISIBLE=now" >> /etc/profile
RUN useradd -d /home/jenkins -m -s /bin/bash jenkins
RUN echo jenkins:jenkins | chpasswd
RUN echo 'jenkins ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/jenkins
RUN chmod 0440 /etc/sudoers.d/jenkins

### Generate Keys
RUN ssh-keygen -A

### Expose Ports
EXPOSE 22

#Install node / npm
RUN git clone https://github.com/nodejs/node.git node && cd node && git checkout v6.2.1 && ./configure && make && make install

ENV DEBIAN_FRONTEND "noninteractive"
CMD ["/usr/sbin/sshd", "-D"]
