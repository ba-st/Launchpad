# How To

You can see an example on:
[Example Handler](../source/Launchpad-Examples/ExampleApplicationStarterCommandLineHandler.class.st) and it's
[Test](../source/Launchpad-Tests/ExampleApplicationStarterCommandLineHandlerTest.class.st)

## Defining the handler

Start off by subclassing `ApplicationStarterCommandLineHandler`.
Then implement the required methods:

- `basicActivate` this method should contain the logic to start your application.
  - It's wrapped in a block handling `Error` which handles the program termination,
  see [Debugging](Debugging.md) for more information.
- `configurationDefinitions` a collection of arguments available to the command line handler.
  - These are logged to console when the application starts,
  and are accessible under `self configuration` on the command line handler.
  - See the comments on the arguments for more information:
    - [FlagArgument](../source/Launchpad/FlagArgument.class.st)
    - [MandatoryArgument](../source/Launchpad/MandatoryArgument.class.st)
    - [OptionalArgument](../source/Launchpad/OptionalArgument.class.st)
- `logPrefix` a string to prepend to the logs and fuel files.
- `commandName` (class side) used to activate this handler from the command line.
- `description` (class side) used to describe this handler when `./pharo <image> list` is called.

### Implicit arguments

There are 2 flags which are defined on the superclass and always present:

- `--suspend-ui` suspends the UI process to improve performance on headless applications. (Teapot servers are a common use case)
- `--debug-mode` suppresses exit on error and enables debugging, useful when you are trying to debug the handler. Available to the handler under `self isDebugModeEnabled`.

By default both are disabled.

## Launching your application using the handler

_Assuming the [Example Handler](../source/Launchpad-Examples/ExampleApplicationStarterCommandLineHandler.class.st) is being used_

The [Example Handler](../source/Launchpad-Examples/ExampleApplicationStarterCommandLineHandler.class.st) allows 5 possible arguments:

- `--fail` a flag to demonstrate what happens when the handler exits with an expected error (just exit).
- `--raise-error` a flag to demonstrate what happens when the handler exits with an unexpected error (create a fuel stack file).
- `--seed` an optional argument which is interpreted as a Number defaults to 0.
- `--add` mandatory argument which is interpreted as a Number.

The handler adds the value of `seed` and `add` logs it with level _[INFO]_ and exits.

To launch the example (which must be loaded in the image):

```bash
./pharo Pharo.image example --seed=2 --add=40
```

Let's split that and explain each section:

- `./pharo` is the pharo headless startup script
- `Pharo.image` is our current image
- `example` is the `commandName` we defined on the class side of the example handler.
    Without this, the handler is not activated and the image does nothing in particular.
- `--seed=2` our optional argument, this could be absent, and then `self configuration at: 'seed'` would be 0.
    Because the handler uses `#asNumber`, the string `'2'` is converted to the number `2`.
- `--add=40` out mandatory argument, without this, the program will log an error and exit (no dump file).
    Because the handler uses `#asNumber`, the string `'40'` is converted to the number `4`.

This would log:

```log
[2019-05-31T03:06:56.962318-03:00] [INFO] add: 40
[2019-05-31T03:06:56.963318-03:00] [INFO] fail: false
[2019-05-31T03:06:56.964318-03:00] [INFO] raise-error: false
[2019-05-31T03:06:56.965318-03:00] [INFO] seed: 2
[2019-05-31T03:06:56.965318-03:00] [INFO] The sum of 2 and 40 is 42
```

### Omitting mandatory arguments

If we omit `--add` which is mandatory, the output would be:

```bash
./pharo Pharo.image example --seed=2
```

```log
[2019-05-31T03:06:56.965318-03:00] [ERROR] add option not provided. You must provide one.
```

### Omitting optional arguments

On the other hand, if we omit `--seed` which is optional, the output would be:

```bash
./pharo Pharo.image example --add=40
```

```log
[2019-05-31T03:06:56.962318-03:00] [INFO] add: 40
[2019-05-31T03:06:56.963318-03:00] [INFO] fail: false
[2019-05-31T03:06:56.964318-03:00] [INFO] raise-error: false
[2019-05-31T03:06:56.965318-03:00] [WRANING]  seed option not provided. Defaulting to 0"
[2019-05-31T03:06:56.965318-03:00] [INFO] The sum of 0 and 40 is 40
```

### Graceful handler exit

Using `--fail` which will force an exit (expected exit, so no fuel dump)

```bash
./pharo Pharo.image example --add=40 --fail
```

```log
[2019-05-31T03:22:30.246708-03:00] [INFO] add: 4
[2019-05-31T03:22:30.247708-03:00] [INFO] fail: true
[2019-05-31T03:22:30.248708-03:00] [INFO] raise-error: false
[2019-05-31T03:22:30.232708-03:00] [WARNING] seed option not provided. Defaulting to 0
[2019-05-31T03:22:30.249708-03:00] [INFO] seed: 0
This was a forced failure, should not dump a stack on runtime, nor log nothing specific
    ...
Command line handler failed
```

### Unexpected errors

Using `--raise-error` which simulates an unexpected error and generates a fuel dump file.
Details on how can you use that dump are described in [Debugging](Debugging.md).

You should also see a .fuel file on logs/, this is usually a `<logPrefix>-<timestamp>.fuel` but for testing purpouses, the example uses `<logPrefix>-<date>.fuel`.

```bash
./pharo Pharo.image example --add=40 --raise-error
```

```log
[2019-05-31T03:25:05.128569-03:00] [INFO] add: 4
[2019-05-31T03:25:05.128569-03:00] [INFO] fail: false
[2019-05-31T03:25:05.129569-03:00] [INFO] raise-error: true
[2019-05-31T03:25:05.127569-03:00] [WARNING] seed option not provided. Defaulting to 0
[2019-05-31T03:25:05.129569-03:00] [INFO] seed: 0
[2019-05-31T03:25:05.130569-03:00] [ERROR] Dumping Stack Due to Unexpected Error: This was a forced error, which should dump a stack file on runtime
[2019-05-31T03:25:05.151569-03:00] [ERROR] Dumping Stack Due to Unexpected Error: This was a forced error, which should dump a stack file on runtime... [OK]
Command line handler failed
    ...
Command line handler failed
```
