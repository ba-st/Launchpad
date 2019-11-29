# Debugging

## How it works

Should the worst happend and an unexpected error raises, ApplicationStarter provides a global *Error* handler that logs to stderr the error message if present, and dumps a fuel file (by default _logs/prefix-timestamp.fuel_) with `thisContext` this can be then loaded using fuel and debugged later.

## How to debug it

You need:

- An image with your code loaded.
  - _If you can use the same image where the error generated better, otherwise, you need to have all the code loaded, otherwise fuel will not be able to deserialize the context_.
- The dump file **the-file.fuel** in this example.
- Materialize the fuel file by any of the following methods:
  - By dragging it to the image
  - Opening it from the file browser
  - Execute the following code on a Playground

```smalltalk
| session |

session := Processor activeProcess
  newDebugSessionNamed: 'External stack'
  startedAt: (FLMaterializer materializeFromFileNamed: 'the-file.fuel').

Smalltalk tools debugger openOn: session.
```
