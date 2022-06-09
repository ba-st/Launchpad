# Logging infrastructure

Launchpad logging builds on top of [Beacon](https://github.com/pharo-project/pharo-beacon).
For a summary of Beacon take a look at [this blog post](http://www.humane-assessment.com/blog/beacon).

Launchpad produces logging information by signaling `LaunchpadLogRecord` instances,
including a log level that can be `INFO`, `WARNING`, or `ERROR`.
To emit your logs, you can reuse `LaunchpadLogRecord` by sending one of the
`emit` messages:

- `emitTraceInfo:` will produce informational signals with trace information.
- `emitDebuggingInfo:` will produce informational signals with debugging information.
- `emitInfo:` and `emitInfo:during:` will produce informational signals.
- `emitWarning:` will produce warning signals.
- `emitError:` will produce error signals.

By default, during the application startup process, Launchpad enables two loggers
to process these events. One of the loggers writes informational log records to
`stdout`. The other one handles warning and error records, writing them to `stderr`.
Applications can freely configure their loggers if they want to report these events
differently.
