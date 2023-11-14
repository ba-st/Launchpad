FROM ghcr.io/ba-st/pharo-loader:v11.0.0 as loader

COPY --chown=pharo:users ./source ./source
COPY --chown=pharo:users ./.git/ ./.git/
RUN pharo metacello install gitlocal://./source \
  BaselineOfLaunchpad --groups=Examples

FROM launchpad:sut

COPY --from=loader /opt/pharo/Pharo.image ./
COPY --from=loader /opt/pharo/Pharo*.sources ./
CMD [ "launchpad-start", "greeter" , "--name=DJ", "--title=Mr." ]
