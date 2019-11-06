Class {
	#name : #ExampleApplicationStarterCommandLineHandler,
	#superclass : #ApplicationStarterCommandLineHandler,
	#category : #'Application-Starter-Examples'
}

{ #category : #accessing }
ExampleApplicationStarterCommandLineHandler class >> commandName [

	" Overwrite this method to provide a short name for this command handler.
	You may pass the commandName as first argument to the image to select this handler"

	^ 'example'
]

{ #category : #'private - defaults' }
ExampleApplicationStarterCommandLineHandler class >> defaultLogFile [

	"We override this to be able to test it, it's not required to be overriden"

	| timestamp fileName |

	timestamp := DateAndTime current asUTC printString copyFrom: 1 to: 10.
	fileName := self logPrefix isEmpty
		ifTrue: [ timestamp ]
		ifFalse: [ '<1s>-<2s>' expandMacrosWith: self logPrefix with: timestamp ].
	^ self defaultLogsPath / fileName withExtension: 'log'
]

{ #category : #accessing }
ExampleApplicationStarterCommandLineHandler class >> description [

	"This method should return a short one-line description of the command"

	^ 'An example command line handler'
]

{ #category : #'private - accessing' }
ExampleApplicationStarterCommandLineHandler class >> logPrefix [

	^ 'example'
]

{ #category : #accessing }
ExampleApplicationStarterCommandLineHandler >> add [

	^ self configuration at: 'add'
]

{ #category : #'private - activation' }
ExampleApplicationStarterCommandLineHandler >> basicActivate [

	( self configuration at: 'fail' )
		ifTrue: [ self
				exitFailure: 'This was a forced failure, should not dump a stack on runtime, nor log nothing specific'
			].
	( self configuration at: 'raise-error' )
		ifTrue: [ self error: 'This was a forced error, which should dump a stack file on runtime' ].
	CurrentLogger value
		info: ( 'The sum of <1p> and <2p> is <3p>' expandMacrosWith: self seed with: self add with: self sum ).
	( self configuration at: 'quit' )
		ifTrue: [ Smalltalk snapshot: false andQuit: true ]
]

{ #category : #'private - accessing' }
ExampleApplicationStarterCommandLineHandler >> configurationDefinition [

	^ OrderedCollection new
		add: ( FlagArgument named: 'fail' );
		add: ( FlagArgument named: 'raise-error' );
		add: ( FlagArgument named: 'quit' );
		add: ( OptionalArgument named: 'seed' defaultingTo: 0 convertingWith: #asNumber );
		add: ( MandatoryArgument named: 'add' convertingWith: [ :arg | arg asNumber ] );
		asArray
]

{ #category : #accessing }
ExampleApplicationStarterCommandLineHandler >> seed [

	^ self configuration at: 'seed'
]

{ #category : #accessing }
ExampleApplicationStarterCommandLineHandler >> sum [

	^ self seed + self add
]
