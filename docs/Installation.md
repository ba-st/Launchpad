# Installation

## Basic Installation

You can load **Launchpad** evaluating:

```smalltalk
Metacello new
 baseline: 'Launchpad';
 repository: 'github://ba-st/Launchpad:master/source';
 load.
```

> Change `master` to some released version if you want a pinned version

## Using as dependency

In order to include **Launchpad** as part of your project, you should reference the package in your product baseline:

```smalltalk
setUpDependencies: spec

 spec
  baseline: 'Launchpad'
   with: [ spec
    repository: 'github://ba-st/Launchpad:v{XX}/source';
    loads: #('Deployment') ];
  import: 'Launchpad'.
```

> Replace `{XX}` with the version you want to depend on

```smalltalk
baseline: spec

 <baseline>
 spec
  for: #common
  do: [ self setUpDependencies: spec.
   spec package: 'My-Package' with: [ spec requires: #('Launchpad') ] ]
```
