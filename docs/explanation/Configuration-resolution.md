# Configuration parameter resolution

Launchpad-based applications must declare their configuration parameters. This
configuration is resolved at start-up time using a combination of providers.
By default, every application can obtain its parameters from the command-line or
the OS environment. The configuration is loadable from files by using the
`settings-file` command-line option (see [CLI Reference](../reference/CLI.md)).

The process for resolving this configuration is as follows:

1. For each configuration parameter declared in the application:

    - Try to find its value in the command-line arguments. If found, go to 2.

    - Try to find its value in an environment variable. If found, go to 2.

    - For each settings file configured using the `settings-file` option, try to
      find its value in the corresponding section in the file. If found, go to 2.

    - If the parameter is optional, record the default value for this parameter.

    - If the parameter is mandatory, signal an error.
2. Apply the defined converter to the obtained value, and record its result for
   this parameter.

Once the configuration is loaded, the user can access it anytime by using
`CurrentApplicationConfiguration value` or reload it by using
`CurrentApplicationConfiguration value reload`.
