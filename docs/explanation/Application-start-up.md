# Application start-up

Before a user's application takes control, there's a bit of stuff happening under
Launchpad control. Here's a brief description of the start-up process
for people interested in the inner details.

In Pharo, Launchpad is implemented as a command-line handler, taking control
when the `launchpad` command is found in the command line.

In VAST Platform, there's no such thing as a command-line handler. To achieve a
similar effect, the user needs to use `LaunchpadCommandLineHandler activate` as the
`applicationLaunchCode` in his packaging instructions.

Once the command-line handler is activated, the first thing it does is to set up
the logging infra:

- In Pharo, `[INFO]` records output to `stdout`. `[WARNING]` and `[ERROR]`
  records output to `stderr`.
- In VAST Platform, every record outputs to `TranscriptTTY` (that ends up being
  `stdout` on Unix); because there's no way to access the `stderr` handle
  attached to the VM process.

As a second step, instantiates a `LaunchpadCommandLineProcessingContext` with
the command-line and a reference to `stdout`. This context is later available
in all the required methods and ultimately accessible by the application in its
`basicStartWithin:` method.

After that, a `LaunchpadRootCommand` is created and evaluated within the context.
This command tries to handle first any root option and then find which subcommand
to evaluate. Once the `start` sub-command is found, `LaunchpadStartApplicationCommand`
takes control.

The start command will process first any option and then search for an application
with the provided handle. If there's no application matching, it will emit an error
and exit. If an application is found:

- Instantiate it with the corresponding mode and configuration provider
- It became the currently running application
- Control pass to the application itself

Applications first load and log their configuration. If successful, they send the
`basicStartWithin:` message to themselves. Here's where the user-defined code
for the application starts to execute.
