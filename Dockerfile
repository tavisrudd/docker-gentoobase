FROM tavisrudd/stage4-base
MAINTAINER tavisrudd
ADD salt/ /srv/salt
ADD bin/bootstrap-stage4-in-container.sh /root/bootstrap.sh
RUN /root/bootstrap.sh
