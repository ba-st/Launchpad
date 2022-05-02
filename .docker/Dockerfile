FROM ghcr.io/ba-st/pharo-loader:v10.0.0 as loader

COPY ./source ./source
COPY ./.git/ ./.git/
RUN pharo metacello install gitlocal://./source \
  BaselineOfLaunchpad --groups=Examples

FROM launchpad:sut

COPY --from=loader /opt/pharo/Pharo.image ./
COPY --from=loader /opt/pharo/Pharo.changes ./
COPY --from=loader /opt/pharo/Pharo*.sources ./
CMD [ "launchpad-start", "greeter" , "--name=DJ", "--title=Mr." ]
