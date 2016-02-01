FROM luxas/raspbian
MAINTAINER Josh Cox <josh 'at' webhosting.coop>

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV NFS_MOUNTS mount -t nfs -o proto=tcp,port=2049 192.168.0.11:/example /data

RUN apt-get -qq update; \
apt-get -qqy dist-upgrade ; \
apt-get -qqy --no-install-recommends install nfs-common \
sudo procps ca-certificates wget pwgen supervisor; \
echo 'en_US.ISO-8859-15 ISO-8859-15'>>/etc/locale.gen ; \
echo 'en_US ISO-8859-1'>>/etc/locale.gen ; \
echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen ; \
locale-gen ; \
apt-get -y autoremove ; \
apt-get clean ; \
rm -Rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
