# Installation

## Basic Installation

You can load **ApplicationStarter** evaluating:
```smalltalk
Metacello new
	baseline: 'ApplicationStarter';
	repository: 'github://ba-st/ApplicationStarter:master/source';
	load.
```
>  Change `master` to some released version if you want a pinned version

## Using as dependency

In order to include **ApplicationStarter** as part of your project, you should reference the package in your product baseline:

```smalltalk
setUpDependencies: spec

	spec
		baseline: 'ApplicationStarter'
			with: [ spec
				repository: 'github://ba-st/ApplicationStarter:v{XX}/source';
				loads: #('Deployment') ];
		import: 'ApplicationStarter'.
```
> Replace `{XX}` with the version you want to depend on

```smalltalk
baseline: spec

	<baseline>
	spec
		for: #common
		do: [ self setUpDependencies: spec.
			spec package: 'My-Package' with: [ spec requires: #('ApplicationStarter') ] ]
```
