# Installation

## Basic Installation

You can load **Launchpad** evaluating:

```smalltalk
Metacello new
 baseline: 'Launchpad';
 repository: 'github://ba-st/Launchpad:release-candidate';
 load.
```

> Change `release-candidate` to some released version if you want a pinned version

## Using as dependency

In order to include **Launchpad** as part of your project, you should reference
the package in your product baseline:

```smalltalk
setUpDependencies: spec

 spec
  baseline: 'Launchpad' 
    with: [ spec repository: 'github://github://ba-st/Launchpad:v{XX}' ];
  project: 'Launchpad-Deployment' 
    copyFrom: 'Launchpad' with: [ spec loads: 'Deployment' ]
```

> Replace `{XX}` with the version you want to depend on

```smalltalk
baseline: spec

 <baseline>
 spec
  for: #common
  do: [ self setUpDependencies: spec.
   spec
    package: 'My-Package' 
      with: [ spec requires: #('Launchpad-Deployment') ] ]
```
