FROM tavisrudd/stage3
MAINTAINER tavisrudd
ADD salt/base/etc/portage/package.keywords/ /etc/portage/package.keywords/
ADD salt/ /srv/salt
ADD docker-bootstrap.sh /root/
#VOLUME ["/usr/portage"]
# ADD http://gentoo.arcticnetwork.ca/snapshots/portage-latest.tar.xz /usr/portage
RUN /root/docker-bootstrap.sh
