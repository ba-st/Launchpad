# How To

You should subclass **ApplicationStarterCommandLineHandler** and then
implement the methods marked with `self subclassResponsibility`

- basicActivate: what to do to start up your application.
- configurationDefinitions: a collection of arguments required by the command line handler.
- logPrefix: a string to prepend to the logs and fuel files.

## basicActivate

This should contain the logic to start your application

It's wrapped in a block handling **Error** which handles the program termination,
see [Debugging](Debugging.md) for more information.

## configurationDefinitions

Should return a collection of `MandatoryArgument`s and `OptionalArgument`s.

These are logged to console when the application starts,
and are accessible under `self configuration` on the command line handler.

### MandatoryArgument

If this argument is not present the program will log an error and exit. 

Supports transformations to the provided value (something like: `#asNumber` or `[:arg | arg asNumber]`).

### OptionalArgument

If this argument is absent, the program will warn that a default is being used
and the default value will be stored in the configuration,
otherwise the provided value is stored in the configuration.

Supports transformations to the provided value (something like: `#asNumber` or `[:arg | arg asNumber]`).