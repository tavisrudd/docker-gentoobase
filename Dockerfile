FROM tavisrudd/stage3
MAINTAINER tavisrudd
ADD salt/ /srv/salt
ADD bin/bootstrap-stage4-in-container.sh /root/bootstrap.sh
RUN /root/bootstrap.sh
