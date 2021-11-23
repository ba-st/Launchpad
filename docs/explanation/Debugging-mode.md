# Debugging mode

Launchpad-based applications run in one of two modes:

- **Release**: it's the default mode when starting an application.

  In this mode, Launchpad will handle any `Error` produced during the start-up
  phase, generate a stack trace, and quit the image with an error code.

  Also, exit attempts (sending `exitSuccess` or `exitFailure`) will quit the image.

- **Debug**: To enable it, use the `--debug-mode` option on the `start`
  subcommand (see [CLI reference](../reference/CLI.md) for more details).

  An application running in debug mode will not handle the errors produced
  during start-up, giving the chance to open a Debugger to analyze the problem.

  Exit attempts will not quit the image.

  Applications can use it to configure themselves to ease the debugging
  experience. To query the debug mode status, send
  `LanchpadApplication currentlyRunning isDebugModeEnabled`. For example, HTTP
  APIs can let the system handle the errors by opening a debugger instead of
  responding with `500/Internal Server Error` when something unexpected happens.
