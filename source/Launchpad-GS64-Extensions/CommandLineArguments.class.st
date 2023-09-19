"
The CommandLineArguments represents the arguments passed to the image.
"
Class {
	#name : #CommandLineArguments,
	#superclass : #Object,
	#instVars : [
		'arguments'
	],
	#category : #'Launchpad-GS64-Extensions'
}

{ #category : #'instance creation' }
CommandLineArguments class >> new [

	^ self withArguments: System commandLineArguments
]

{ #category : #'instance creation' }
CommandLineArguments class >> withArguments: aCollection [

	^ super new
		  initializeWithArguments: aCollection;
		  yourself
]

{ #category : #accessing }
CommandLineArguments >> argumentAt: index [

	^ arguments at: index
]

{ #category : #accessing }
CommandLineArguments >> arguments [

	^ arguments
]

{ #category : #copying }
CommandLineArguments >> copySubcommand [

	^ self class withArguments: arguments allButFirst
]

{ #category : #testing }
CommandLineArguments >> hasArguments [

	^ arguments notEmpty
]

{ #category : #testing }
CommandLineArguments >> hasOption: aString [

	| option |
	option := ((self isShort: aString)
		           ifTrue: [ '-' ]
		           ifFalse: [ '--' ]) , aString.
	(self arguments includes: option) ifTrue: [ ^ true ].
	option := option , '='.
	^ self arguments anySatisfy: [ :arg | arg beginsWith: option ]
]

{ #category : #testing }
CommandLineArguments >> includesSubCommand: aName [

	self withFirstArgument: [ :arg | arg = aName ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #initialization }
CommandLineArguments >> initializeWithArguments: aCollection [

	arguments := aCollection
]

{ #category : #private }
CommandLineArguments >> isShort: aString [
	"One letter strings are considered short options/arguments"

	^ aString size = 1
]

{ #category : #private }
CommandLineArguments >> longOptionAt: aString ifAbsent: absentBlock [
	| optionStart |
	optionStart := '--' , aString , '='.
	^ self arguments
		detect: [ :arg | arg beginsWith: optionStart ]
		ifFound: [ :option | (option splitOn: '=') second ]
		ifNone: absentBlock
]

{ #category : #accessing }
CommandLineArguments >> optionAt: aString [

	^ self
		  optionAt: aString
		  ifAbsent: [ Error signal: 'Could not find option ' , aString ]
]

{ #category : #accessing }
CommandLineArguments >> optionAt: aString ifAbsent: absentBlock [

	^ (self isShort: aString)
		  ifTrue: [ self shortOptionAt: aString ifAbsent: absentBlock ]
		  ifFalse: [ self longOptionAt: aString ifAbsent: absentBlock ]
]

{ #category : #accessing }
CommandLineArguments >> optionAt: aString ifPresent: presentBlock [
	| option |

	option := self optionAt: aString ifAbsent: [ ^ self ].
	^ presentBlock value: option
]

{ #category : #accessing }
CommandLineArguments >> optionAt: aString ifPresent: presentBlock ifAbsent: absentBlock [

	| option |
	option := self optionAt: aString ifAbsent: [ ^ absentBlock value ].
	^ presentBlock value: option
]

{ #category : #private }
CommandLineArguments >> shortOptionAt: aString ifAbsent: absentBlock [
	| index |
	index := (arguments indexOf: '-', aString) + 1.
	^ (index <= 1 or: [ index > arguments size ])
		ifFalse: [ arguments at: index ]
		ifTrue: absentBlock
]

{ #category : #accessing }
CommandLineArguments >> withFirstArgument: aBlock [

	self arguments ifEmpty: [ ^ self ].
	^ aBlock value: self arguments first
]
