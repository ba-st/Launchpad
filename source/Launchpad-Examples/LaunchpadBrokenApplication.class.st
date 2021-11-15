Class {
	#name : #LaunchpadBrokenApplication,
	#superclass : #LaunchpadApplication,
	#instVars : [
		'stackTraceDumper'
	],
	#category : #'Launchpad-Examples'
}

{ #category : #accessing }
LaunchpadBrokenApplication class >> commandName [

	^ 'broken'
]

{ #category : #'private - accessing' }
LaunchpadBrokenApplication class >> configurationParameters [

	^ #(  )
]

{ #category : #accessing }
LaunchpadBrokenApplication class >> description [

	^ 'A broken application'
]

{ #category : #printing }
LaunchpadBrokenApplication class >> printCommandArgumentsOn: stream [

	super printCommandArgumentsOn: stream.
	stream
		space;
		nextPutAll: '[';
		nextPutAll: self raiseErrorOption;
		nextPutAll: ']'
]

{ #category : #printing }
LaunchpadBrokenApplication class >> printHelpOn: stream [

	super printHelpOn: stream.
	stream
		nextPutAll: 'COMMANDS';
		cr;
		tab: 2;
		nextPutAll: self raiseErrorOption;
		cr;
		tab: 3;
		nextPutAll: 'Raises an unexpected error. Useful to test stack trace generation.';
		cr
]

{ #category : #printing }
LaunchpadBrokenApplication class >> raiseErrorOption [

	^ '--raise-error'
]

{ #category : #accessing }
LaunchpadBrokenApplication class >> version [

	^ 'v0.0.1'
]

{ #category : #'private - activation' }
LaunchpadBrokenApplication >> basicStartWithin: context [

	| nextArgument |

	nextArgument := context nextCommandLineArgumentIfNone: [ self exitFailure ].
	nextArgument = self class raiseErrorOption ifTrue: [ Error signal: 'Doh!' ]
]

{ #category : #initialization }
LaunchpadBrokenApplication >> initializeRunningIn: anApplicationMode configuredBy: aConfigurationProvider [

	super initializeRunningIn: anApplicationMode configuredBy: aConfigurationProvider.
	stackTraceDumper := self newStackTraceDumperOnStandardError
]

{ #category : #'error handling' }
LaunchpadBrokenApplication >> stackTraceDumper [

	^ stackTraceDumper
]
