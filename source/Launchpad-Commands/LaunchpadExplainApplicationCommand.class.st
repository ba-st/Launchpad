Class {
	#name : #LaunchpadExplainApplicationCommand,
	#superclass : #LaunchpadSubcommand,
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

	| nextArgument |

	nextArgument := context nextCommandLineArgumentIfNone: [ 
		                LaunchpadLogRecord emitError: 'Missing application name or option.'.
		                context exitFailure
		                ].
	options detect: [ :option | option canHandle: nextArgument ]
		ifFound: [ :option | option evaluateWithin: context handling: nextArgument ]
		ifNone: [ 
			| application |

			application := LaunchpadApplication applicationFor: nextArgument ifNone: [ 
				               LaunchpadLogRecord emitError:
					               ( '<1s> unknown <2?option:application>: <3s>' expandMacrosWith: self name
						                 with: ( nextArgument beginsWith: '-' )
						                 with: nextArgument ).
				               context exitFailure
				               ].
			self explain: application within: context
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
