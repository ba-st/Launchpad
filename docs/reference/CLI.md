# Command Line Interface Reference

## Launchpad root command

Launchpad is activated by using the `launchpad` command and provides a command-line
interface to start, list, and explain the applications available within the image.

Both for [Pharo](https://pharo.org) and [VAST Platform](https://www.instantiations.com/vast-platform/)
the command must be passed after the image parameters:

```bash
pharo App.image launchpad <arguments>
```

```bash
vast/bin/esnx \
    -platform UNIX \
    -no_break \
    -iApp.image \
    -ini:esnx.ini \
    launchpad <arguments>
```

For the sake of simplicity, from now on we will omit in the examples the VM and
image parameters:

```bash
launchpad [--version] [--help|-h] <command>
```

### `launchpad` options

- `version` Print the version and exit.

  ```bash
  $ launchpad --version
  Launchpad [v4.0.0]
  ```

- `help, h` Print the help message and exit.

  ```bash
  $ launchpad -h
  NAME
                launchpad - A minimal application launcher
  SYNOPSYS
                launchpad [--version] [--help|-h] <command>
  DESCRIPTION
                A command-line interface to start, list, and explain the
                applications available within the image.
  OPTIONS
                --version
                        Print the version and exit.
                -h, --help
                        Print this help message and exit.
  COMMANDS
                start
                        Start the selected application
                list
                        List available applications
                explain
                        Give details about the selected application
  ```

### `launchpad` sub-commands

- `list` List available applications
- `explain` Give details about the selected application
- `start` Start the selected application

## Launchpad `list`

The `list` sub-command will list the available applications within the image.

```bash
launchpad list [--verbose|-v] [--help|-h]
```

The applications listed are dependent on the image contents.
Using an image with the `Examples` group loaded will produce:

```bash
$ launchpad list
broken greeter
```

### `list` options

- `verbose,v` Produce more verbose output.

  ```bash
  $ launchpad list -v
  broken v0.0.1 A broken application
  greeter v1.0.0 A greetings application
  ```

- `help,h` Print the help message and exit.

  ```bash
  $ launchpad list -h
  NAME
                launchpad-list - List available applications
  SYNOPSYS
                launchpad list [--verbose|-v] [--help|-h]
  DESCRIPTION
                Lists the available applications contained in the image.
  OPTIONS
                -v, --verbose
                        Produce more verbose output.
                -h, --help
                        Print this help message and exit.
  ```

## Launchpad `explain`

The `explain` sub-command will give details about the selected application,
including the description, version, supported parameters, command-line options
and environment variables.

```bash
launchpad explain [--help|-h] <app>
```

This sub-command requires a valid `<app>` handle to be provided, so it will know
which application is needing explanation. The valid application handles can be obtained
by using the `list` command.

```bash
$ launchpad explain greeter
NAME
                greeter [v1.0.0] - A greetings application
SYNOPSYS
                greeter --name=<name> [--title=<title>]
PARAMETERS
                --name=<name>
                        The name of the user to greet.
                --title=<title>
                        The title of the user to greet. Defaults to nothing.
ENVIRONMENT
                NAME
                        The name of the user to greet.
                TITLE
                        The title of the user to greet. Defaults to nothing.

```

Failing to provide an app handler, or providing and invalid one will result in
an error:

```bash
$ launchpad explain
2021-11-16T11:32:57-03:00 [ERROR] Missing application name or option.
```

```bash
$ launchpad explain bad
2021-11-16T11:42:22-03:00 [ERROR] explain unknown application: bad
```

### `explain` options

- `help,h` Print the help message and exit.

  ```bash
  $ launchpad explain -h
  NAME
                launchpad-explain - Give details about the selected application
  SYNOPSYS
                launchpad explain [--help|-h] <app>
  DESCRIPTION
                Give details about the application selected via <app> including
                its configuration options.
  OPTIONS
                -h, --help
                        Print this help message and exit.
  ```

## Launchpad `start`

The `start` sub-command will start the selected application.

```bash
launchpad start [--help|-h] [--debug-mode] [--settings-file=<filename>]
                [--enable-tcp-command-server=<listeningPort>]
                [--enable-structured-logging]
                <app> [<parameters>]
```

This sub-command requires a valid `<app>` handle to be provided, so it will know
which application to start. The valid application handles can be obtained by
using the `list` command. Once an application is started the control is passed to
it to perform whatever is intended.

```bash
$ launchpad start greeter --name=John
  [INFO] Obtaining configuration...
  [WARNING] "Title" parameter not provided. Using default.
  [INFO] Name: John
  [INFO] Title:
  [INFO] Obtaining configuration... [DONE]
Hi John!
```

Failing to provide an app handler, or providing and invalid one will result in
an error:

```bash
$ launchpad start
2021-11-16T11:55:48-03:00 [ERROR] Missing application name or option.
```

```bash
$ launchpad start bad
2021-11-16T11:56:45-03:00 [ERROR] start unknown application: bad
```

Failing to provide one of the mandatory parameters of the application will also produce
an error:

```bash
$ launchpad start greeter
  [INFO] Obtaining configuration...
  [ERROR] "Name" parameter not provided. You must provide one.
```

### `start` options

- `help, h` Print the help message and exit.

  ```bash
  $ launchpad start -h
  NAME
                launchpad-start - Start the selected application
  SYNOPSYS
                launchpad start [--help|-h] [--debug-mode]
                  [--settings-file=<filename>] <app> [<parameters>]
  DESCRIPTION
                Start the application selected via <app>.

                Application configuration is made by the command-line via
                <parameters>, using environment variables or settings files.

                Execute launchpad explain <app> to get a list of valid
                configuration parameters.
  OPTIONS
                -h, --help
                        Print this help message and exit.
                --debug-mode
                        Enable the debugging mode. The image will not quit on
                        unexpected errors. This configuration can be used in
                        the application to improve the debugging experience.
                --settings-file=<filename>
                        Provide application configuration via a settings file.
                        This option can occur several times to configure more
                        than one settings file. Supported file settings formats
                        are INI and JSON.
  ```

- `debug-mode` Enable the debugging mode.
- `settings-file=<filename>` Provide application configuration via a settings
  file. This option can occur several times to configure more than one settings
  file.

  ```bash
  $ launchpad start --settings-file=names.json --settings-file=titles.ini greeter
    [INFO] Obtaining configuration...
    [INFO] Name: DJ
    [INFO] Title: Mr.
    [INFO] Obtaining configuration... [DONE]
  Hi Mr. DJ!
  ```

  For details over the available configuration formats take a look at the
  configuration providers reference.
- `--enable-tcp-command-server=<listeningPort>` Enable a TCP command server. This
  can be used to send commands controlling the application using a TCP port.
- `--enable-structured-logging` Enable structured logging. When enabled the log
  will be emitted in JSON format.
