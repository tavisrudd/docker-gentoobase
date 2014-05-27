FROM tavisrudd/stage3
MAINTAINER tavisrudd
ADD salt/etc/portage/package.keywords/ /etc/portage/package.keywords/
ADD salt/ /srv/salt
RUN emerge -u --usepkg --quiet --quiet-build salt && \
    salt-call --retcode-passthrough --local state.sls base.salt-patches && \
    salt-call --retcode-passthrough --local state.highstate
