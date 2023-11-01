FROM ghcr.io/ba-st/gs64-gem:v3.7.0

COPY --chown=gemstone:users ./launchpad* ./
RUN set -eu; \
  ln -s /opt/gemstone/launchpad /usr/local/bin/launchpad; \
  ln -s /opt/gemstone/launchpad-gem /usr/local/bin/launchpad-gem; \
  chmod a+x /usr/local/bin/launchpad*; \
  true
