FROM tavisrudd/stage3
MAINTAINER tavisrudd
ADD salt/base/etc/portage/package.keywords/ /etc/portage/package.keywords/
ADD salt/ /srv/salt
ADD bin/bootstrap-stage4-in-container.sh /root/bootstrap.sh
#VOLUME ["/usr/portage"]
# ADD http://gentoo.arcticnetwork.ca/snapshots/portage-latest.tar.xz /usr/portage
RUN /root/bootstrap.sh
