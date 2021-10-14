Class {
	#name : #LaunchpadExplainApplicationCommand,
	#superclass : #LaunchpadApplicationCommand,
	#instVars : [
		'options'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #accessing }
LaunchpadExplainApplicationCommand >> description [

	^ 'Give details about the application selected via <app> including its configuration options.'
]

{ #category : #evaluating }
LaunchpadExplainApplicationCommand >> evaluateWithin: context [

	self handleOptionsAndWithNextArgumentIn: context do: [ :argument | 
		LaunchpadApplication applicationFor: argument
			ifFound: [ :application | self explain: application within: context ]
			ifNone: [ context emitErrorAndExit: ( self unknownOptionOrApplicationMessageFor: argument ) ]
		]
]

{ #category : #private }
LaunchpadExplainApplicationCommand >> explain: application within: context [

	context outputStreamDo: [ :stream | application printHelpOn: stream ].
	context exitSuccess
]

{ #category : #initialization }
LaunchpadExplainApplicationCommand >> initialize [

	super initialize.
	options := Array with: ( LaunchpadHelpOption for: self )
]

{ #category : #accessing }
LaunchpadExplainApplicationCommand >> name [

	^ 'explain'
]

{ #category : #accessing }
LaunchpadExplainApplicationCommand >> options [

	^ options
]

{ #category : #printing }
LaunchpadExplainApplicationCommand >> printCommandArgumentsOn: stream [

	super printCommandArgumentsOn: stream.
	stream
		space;
		nextPutAll: '<app>'
]

{ #category : #accessing }
LaunchpadExplainApplicationCommand >> subcommands [

	^ #()
]

{ #category : #accessing }
LaunchpadExplainApplicationCommand >> summary [

	^ 'Give details about the selected application'
]
