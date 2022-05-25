FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND noninteractive

# Install kali packages
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install kali-linux-core
RUN apt-get clean

# Install kali desktop
RUN apt-get -y install kali-desktop-xfce
RUN apt-get -y install tightvncserver dbus dbus-x11 novnc net-tools


# Install custom packages
RUN apt-get -y install nano
RUN apt-get -y install kali-tools-top10


# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh