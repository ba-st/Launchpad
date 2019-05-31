# How To

You can see an example on:

- `ExampleApplicationStarterCommandLineHandler` in the package `Application-Starter-Examples`
- `ExampleApplicationStarterCommandLineHandlerTest` in the package `Application-Starter-Tests`

## Defining the handler

Start off by subclassing `ApplicationStarterCommandLineHandler`.
Then implement the required methods:

- basicActivate: what to do to start up your application.
- configurationDefinitions: a collection of arguments required by the command line handler.
- logPrefix: a string to prepend to the logs and fuel files.
- commandName: (class side) used to activate this handler from command line.
- description: (class side) used to describe this handler when `./pharo <image> list` is called.

### basicActivate

This should contain the logic to start your application

It's wrapped in a block handling **Error** which handles the program termination,
see [Debugging](Debugging.md) for more information.

### configurationDefinitions

Should return a collection of arguments.

These are logged to console when the application starts,
and are accessible under `self configuration` on the command line handler.

#### MandatoryArgument

To define arguments of the format `--key=value`, defined as: `MandatoryArgument named: 'key'`.
If this argument is not present the program will log an error and exit.

Supports transformations to the provided value (something like: `#asNumber` or `[:arg | arg asNumber]`).

#### OptionalArgument

To define arguments of the format `--key=value`, defined as: `OptionalArgument named: 'key' defaultingTo: aDefaultValue`.
If this argument is absent, the program will warn that a `aDefaultValue` is being used but continue execution.

Supports transformations to the provided value (something like: `#asNumber` or `[:arg | arg asNumber]`).

#### FlagArgument

To define arguments of the format `--key`, `--key=true` or `--key=false`, defined as: `FlagArgument named: 'key'`.
When absent or set to false (case insensitive), the value will be the Boolean `false`.
When present without value or set to true (case insensitive), the value will be the boolean `true`

## Launching your application using the handler

_Assuming the `ExampleApplicationStarterCommandLineHandler` is being used_

The Example allows 5 possible arguments:

- `--fail` a flag to demonstrate what happens when the handler exits with an expected error (just exit).
- `--raise-error` a flag to demonstrate what happens when the handler exits with an unexpected error (crate a fuel stack file).
- `--seed` an optional argument which is interpreted as a Number defaults to 0.
- `--addend` mandatory argument which is interpreted as a Number.

The handler adds the value of `seed` and `addend` logs it with level _[INFO]_ and exits.

To launch the example (which must be loaded in the image):

```bash
./pharo Pharo.image example --seed=2 --addend=40
```

Let's split that and explain each section:

- `./pharo` is the pharo headless startup script
- `Pharo.image` is our current image
- `example` is the `commandName` we defined on the class side of the example handler.
    Without this the handler is not activated and the image does nothing in partiocular.
- `--seed=2` our optional argument, this could be absent, and then `self configuration at: 'seed'` would be 0.
    Because the handler uses `#asNumber`, the string `'2'` is converted to the number `2`.
- `--addend=40` out mandatory argument, without this the program will log an error and exit (no dump file).
    Because the handler uses `#asNumber`, the string `'40'` is converted to the number `4`.

This would log:

```log
[2019-05-31T03:06:56.962318-03:00] [INFO] addend: 40
[2019-05-31T03:06:56.963318-03:00] [INFO] fail: false
[2019-05-31T03:06:56.964318-03:00] [INFO] raise-error: false
[2019-05-31T03:06:56.965318-03:00] [INFO] seed: 2
[2019-05-31T03:06:56.965318-03:00] [INFO] The sum of 2 and 40 is 42
```

If we ommit `--addend` which is mandatory, the output would be:

```bash
./pharo Pharo.image example --seed=2
```

```log
[2019-05-31T03:06:56.965318-03:00] [ERROR] addend option not provided. You must provide one.
```

On the other hand if we ommit `--seed` which is optional, the output would be:

```bash
./pharo Pharo.image example --addend=40
```

```log
[2019-05-31T03:06:56.962318-03:00] [INFO] addend: 40
[2019-05-31T03:06:56.963318-03:00] [INFO] fail: false
[2019-05-31T03:06:56.964318-03:00] [INFO] raise-error: false
[2019-05-31T03:06:56.965318-03:00] [WRANING]  seed option not provided. Defaulting to 0"
[2019-05-31T03:06:56.965318-03:00] [INFO] The sum of 0 and 40 is 40
```

Ussing `--fail` which will force an exit (expected exit, so no fuel dump)

```bash
./pharo Pharo.image example --addend=40 --fail
```

```log
[2019-05-31T03:22:30.246708-03:00] [INFO] addend: 4
[2019-05-31T03:22:30.247708-03:00] [INFO] fail: true
[2019-05-31T03:22:30.248708-03:00] [INFO] raise-error: false
[2019-05-31T03:22:30.232708-03:00] [WARNING] seed option not provided. Defaulting to 0
[2019-05-31T03:22:30.249708-03:00] [INFO] seed: 0
This was a forced failure, should not dump a stack on runtime, nor log nothing specific
    ...
Command line handler failed
```

Using `--raise-error` which simulates an unexpected error and generate a fuel dump file.
Details on how can you use that dump are described in [Debugging](Debugging.md).

You should also see a .fuel file on logs/, this is usually a `<logPrefix>-<timestamp>.fuel` but for testing purpouses, the example uses `<logPrefix>-<date>.fuel`.

```bash
./pharo Pharo.image example --addend=40 --raise-error
```

```log
[2019-05-31T03:25:05.128569-03:00] [INFO] addend: 4
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

### Implicit arguments

There are 2 flags which are defined on the superclass and always present:

- `--suspend-ui` suspends the UI process to improve performance on headless applications. (Teapot servers are a common use case)
- `--debug-mode` supresses exit on error and enables debugging, useful when you are trying to debug the handler.
  - With the example handler it would be: `./pharo-ui example --addend=2 --raise-error`

By default both are disabled.