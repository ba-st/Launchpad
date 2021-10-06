Class {
	#name : #LaunchpadCommand,
	#superclass : #Object,
	#category : #'Launchpad-Commands'
}

{ #category : #testing }
LaunchpadCommand >> canHandle: argument [

	^ argument = self name
]

{ #category : #accessing }
LaunchpadCommand >> description [

	^ self subclassResponsibility
]

{ #category : #evaluating }
LaunchpadCommand >> evaluateWithin: context [

	self subclassResponsibility
]

{ #category : #accessing }
LaunchpadCommand >> fullCommandName [

	^ self subclassResponsibility
]

{ #category : #accessing }
LaunchpadCommand >> fullName [

	^ self subclassResponsibility
]

{ #category : #accessing }
LaunchpadCommand >> name [

	^ self subclassResponsibility
]

{ #category : #accessing }
LaunchpadCommand >> options [

	^ self subclassResponsibility
]

{ #category : #printing }
LaunchpadCommand >> printCommandArgumentsOn: stream [

	self options do: [ :option | 
		stream space.
		option printAsCommandLineArgumentTemplateOn: stream
		].
	self subcommands ifNotEmpty: [ 
		stream
			space;
			nextPutAll: '<command>'
		]
]

{ #category : #printing }
LaunchpadCommand >> printHelpOn: stream [

	( LaunchpadHelpPrinter on: stream )
		nameSectionContaining: ( '<1s> - <2s>' expandMacrosWith: self fullName with: self summary );
		synopsysSectionFor: self fullCommandName
		withArguments: [ :printer | self printCommandArgumentsOn: stream ];
		descriptionSectionContaining: self description;
		optionsSectionDescribing: self options;
		commandsSectionDescribing: self subcommands
]

{ #category : #accessing }
LaunchpadCommand >> subcommands [

	^ self subclassResponsibility
]

{ #category : #accessing }
LaunchpadCommand >> summary [

	^ self subclassResponsibility
]
