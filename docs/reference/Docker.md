# Docker support

Launchpad provides a Docker image that can be used as base for containerized
applications. It's built on top of [pharo:v10.0.0](https://github.com/ba-st/docker-pharo-runtime),
adding some useful scripts for Launchpad-based applications:

- `launchpad` starts the CLI
- `launchpad-explain` starts the CLI with the `explain` command
- `launchpad-list` starts the CLI with the `list` command
- `launchpad-start` starts the CLI with the `start` command and setup
  a `SIGTERM` handler for gracefully stopping the application.
- `launchpad-healthcheck` is run as the default docker `HEALTHCHECK`

## How to use as base docker image

In your Dockerfile put something like:

```docker
FROM ghcr.io/ba-st/pharo-loader:v10.0.0 AS loader
# Load your own application
RUN pharo metacello install github://owner/repo:branch BaselineOfProject

FROM ghcr.io/ba-st/launchpad:v4
COPY --from=loader /opt/pharo/Pharo.image ./
COPY --from=loader /opt/pharo/Pharo.changes ./
COPY --from=loader /opt/pharo/Pharo*.sources ./

# Your own directives

CMD [ "launchpad-start", "app-name" , "--parameter=value" ]
```

## Environment variables

- `LAUNCHPAD__COMMAND_SERVER_PORT` defines in which port is listening the TCP
  command server. Defaults to 22222.

## Structured logging

To enable the structured logging support just change the `CMD` to

```docker
CMD [ "launchpad-start", "--enable-structured-logging", "app-name" ]
```
