# Tutorial: Hello world

This tutorial will guide you in the creation of your first Launchpad-based application:
The classic hello world!

## Preparation

To start, you will need a Pharo image with Launchpad loaded.
Follow the instructions [here](../how-to/how-to-load-in-pharo.md).

This tutorial assumes some familiarity with [Pharo](https://pharo.org/). If it is
your first time using Pharo, you can start [here](https://pharo.org/documentation).

Minimal command-line knowledge is a plus.

## Lesson 1, greeting the world

In this first lesson, we will create an application outputting `Hello world!`
to the standard output.

Let's start by opening our Pharo image and then the `System browser`. Now
we're going to create a package to host the code we will produce in the tutorial.

Open the contextual menu in the package list and click on *New package*. Use
`Launchpad-Tutorial` as the package name.

Create a new class with the following definition:

```smalltalk
LaunchpadApplication subclass: #LaunchpadHelloWorld
  instanceVariableNames: ''
  classVariableNames: ''
  package: 'Launchpad-Tutorial'
```

Now we need to define a few methods for the class to work.
Start with the class side ones, switch to *Class side* and implement:

```smalltalk
commandName

  ^ 'hello-world'
```

```smalltalk
configurationParameters

  ^ #()
```

```smalltalk
description

  ^ 'Hello world'
```

```smalltalk
version

  ^ '1.0.0'
```

Switch to *Inst. side* in the browser and implement:

```smalltalk
stackTraceDumper

  ^ NullStackTraceDumper new
```

```smalltalk
basicStartWithin: context

  context outputStreamDo: [ :out |
    out
      nextPutAll: 'Hello world!';
      cr ].
  self exitSuccess
```

Now we are ready to test it!

- Save your Pharo image and quit the UI.
- Open a console placed in the image location and type:

  ```bash
  pharo Pharo.image launchpad list
  ```

  If everything is ok, you must be seeing a list including `hello-world`

- Now try it for real, type:

  ```bash
  pharo Pharo.image launchpad start hello-world
  ```

  The output must look similar to:

  ```bash
  2021-11-18T17:29:11-03:00 [INFO] Obtaining configuration...
  2021-11-18T17:29:11-03:00 [INFO] Obtaining configuration... [DONE]
  Hello world!
  ```

- Great! Try one more thing before going into the analysis of what we learned.
  Now type:

  ```bash
  pharo Pharo.image launchpad explain hello-world
  ```

 Let's recap what we learned. I will ignore `configurationParameters` and
`stackTraceDumper` for now.

- To reference the application in the command-line, use the name declared in `commandName`
  method
- The help system uses `description` and `version` methods
- The real work starts in `basicStartWithin:`. In our case, we accessed
  `stdout` through the provided context to write `Hello world!` and then exited
  the application successfully.

## Lesson 2, the world is not enough

Now we're going to make a tiny change. Instead of always greeting the world, we want
the option to greet an alien. The user running the application will provide the
alien's name.

Reopen the Pharo UI with the image of the previous lesson and change the
following methods:

```smalltalk
configurationParameters

^ { OptionalConfigurationParameter
      named: 'Alien name'
      describedBy: 'The name of the alien or people to greet'
      defaultingTo: 'world' }
```

```smalltalk
basicStartWithin: context

  context outputStreamDo: [ :out |
    out
      nextPutAll: 'Hello';
      space;
      nextPutAll: self configuration alienName;
      nextPutAll: '!';
      cr ].
  self exitSuccess
```

- We will use again the `explain` command

  ```bash
  pharo Pharo.image launchpad explain hello-world
  ```

  the output is slightly different now.

- Since we added an optional parameter, we can continue starting the application
  as before getting the same output (but more logging info):

  ```bash
  pharo Pharo.image launchpad start hello-world
  ```

- At last, try it with a parameter

  ```bash
  pharo Pharo.image launchpad start hello-world --alien-name=prot
  ```

  the expected output must be

  ```bash
    2021-11-18T17:56:24-03:00 [INFO] Obtaining configuration...
    2021-11-18T17:56:24-03:00 [INFO] Alien name: prot
    2021-11-18T17:56:24-03:00 [INFO] Obtaining configuration... [DONE]
    Hello prot!
  ```

 Let's recap this second lesson:

- We introduced an external configuration parameter. In the example, we provide
  it using command-line arguments. But there's support for environment
  variables or configuration files (review the [reference](../reference/Configuration.md)
  for more details).
- We changed the startup code to access this configuration parameter and use it to
  produce the desired output. If you noticed it, there was a bit of magic accessing
  the configuration because we didn't define `alienName`. Launchpad infers the
  method name from the configuration parameter name.

## Lesson 3, the formal presentation

Our users requested a last-minute change. We now need to provide a mandatory
message to be given with the greetings. This message is confidential information,
so it only needs to appear in the greetings.

Reopen the Pharo UI with the image of the previous lesson and change the
following methods:

```smalltalk
configurationParameters

  ^ {
      (OptionalConfigurationParameter
         named: 'Alien name'
         describedBy: 'The name of the alien or people to greet'
         defaultingTo: 'world').
      (MandatoryConfigurationParameter
         named: 'Message'
         describedBy: 'The message to report'
         convertingWith: #asUppercase) asSensitive }
```

```smalltalk
basicStartWithin: context

  context outputStreamDo: [ :out |
    out
      nextPutAll: 'Hello';
      space;
      nextPutAll: self configuration alienName;
      nextPutAll: '!';
      cr.
    out
      cr;
      nextPutAll: self configuration message;
      cr ].
  self exitSuccess
```

- First, we will try again the `explain` command

  ```bash
  pharo Pharo.image launchpad explain hello-world
  ```

  the output is slightly different now.

- Since we added a mandatory parameter if we start the application as before,
  we will get an error:

  ```bash
  $ pharo Pharo.image launchpad start hello-world
   [INFO] Obtaining configuration...
   [WARNING] "Alien name" parameter not provided. Using default.
   [ERROR] "Message" parameter not provided. You must provide one.
  ```

- Now we try a correct invocation:

  ```bash
  pharo Pharo.image launchpad start hello-world \
    --alien-name=Spock --message="Live long and prosper"
  ```

  the expected output must be

  ```bash
    2021-11-19T10:40:41-03:00 [INFO] Obtaining configuration...
    2021-11-19T10:40:41-03:00 [INFO] Alien name: Spock
    2021-11-19T10:40:41-03:00 [INFO] Message: **********
    2021-11-19T10:40:41-03:00 [INFO] Obtaining configuration... [DONE]
    Hello Spock!

    LIVE LONG AND PROSPER
  ```

 Let's recap this lesson:

- We introduced a new kind of parameter, a mandatory one. When one of these
  parameters is missing, Launchpad reports an error and exits with an error code.
- We also introduced the `asSensitive` message, whose purpose is to avoid
  leaking parameter values in the logs.
- To create the parameter, we used an instance creation method with a converter.
  Optional parameters also have support for them. Converters transform the
  parameter values before storing them in the configuration. Any object
  responding to cull:/value: can be used as a converter.
