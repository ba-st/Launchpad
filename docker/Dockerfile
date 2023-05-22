FROM ghcr.io/ba-st/pharo:v11.0.0

COPY --chown=pharo:users ./launchpad* ./
USER root
RUN set -eu; \
  apt-get update; \
  apt-get install --assume-yes --no-install-recommends netcat-openbsd; \
  apt-get clean; \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
  ln -s /opt/pharo/launchpad /usr/local/bin/launchpad; \
  ln -s /opt/pharo/launchpad-list /usr/local/bin/launchpad-list; \
  ln -s /opt/pharo/launchpad-explain /usr/local/bin/launchpad-explain; \
  ln -s /opt/pharo/launchpad-start /usr/local/bin/launchpad-start; \
  ln -s /opt/pharo/launchpad-healthcheck /usr/local/bin/launchpad-healthcheck; \
  chmod a+x /usr/local/bin/launchpad*; \
  true

USER pharo

HEALTHCHECK CMD [ "launchpad-healthcheck"]
