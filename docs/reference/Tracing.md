# Stack tracing

Applications started via Launchpad are required to provide a stack trace dumper.
This dumper produces a stack trace when an unexpected error happens during the
startup sequence.

## Stack tracing for Pharo

When using Launchpad in Pharo the following dumpers are available:

- `StackTraceTextDumper` produces a textual stack trace written to the
  configured stream.
- `StackTraceBinarySerializer` produces a binary stack trace serialized by
  [Fuel](https://github.com/theseion/Fuel). This stack traces can be later
  opened in a Pharo image and debugged live using the familiar tooling.
- `NullStackTraceDumper` emits a warning and doesn't produce any stack trace. Its
  usage is discouraged in production environments.

## Stack tracing for GemStone/S 64

When using Launchpad in GemStone/S the following dumpers are available:

- `StackTraceTextDumper` produces a textual stack trace written to the
  configured stream.
- `NullStackTraceDumper` emits a warning and doesn't produce any stack trace. Its
  usage is discouraged in production environments.
