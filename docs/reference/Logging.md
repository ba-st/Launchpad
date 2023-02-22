# Logging

Launchapad log events using [Bell](https://github.com/ba-st/Bell).

By default, during the application startup process, Launchpad enables two loggers
to process these events. One of the loggers writes informational log records to
`stdout`. The other one handles warning and error records, writing them to `stderr`.
Applications can freely configure their loggers if they want to report these events
differently.

If you want the logging in an structured format, use `--enable-structured-logging`
option. When enabled the logs are emitted in JSON format.
