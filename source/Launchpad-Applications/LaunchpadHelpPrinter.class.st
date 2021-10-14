Class {
	#name : #LaunchpadHelpPrinter,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'Launchpad-Applications'
}

{ #category : #'instance creation' }
LaunchpadHelpPrinter class >> on: aWriteStream [

	^ self new initializeOn: aWriteStream
]

{ #category : #'printing - sections' }
LaunchpadHelpPrinter >> commandsSectionDescribing: subcommands [

	subcommands ifNotEmpty: [ 
		stream
			nextPutAll: 'COMMANDS';
			cr.
		subcommands do: [ :subcommand | 
			stream
				tab: 2;
				nextPutAll: subcommand name;
				cr;
				tab: 3;
				nextPutAll: subcommand summary;
				cr
			]
		]
]

{ #category : #'printing - sections' }
LaunchpadHelpPrinter >> descriptionSectionContaining: contents [

	self sectionNamed: 'DESCRIPTION' containing: contents
]

{ #category : #initialization }
LaunchpadHelpPrinter >> initializeOn: aWriteStream [

	stream := aWriteStream
]

{ #category : #'printing - sections' }
LaunchpadHelpPrinter >> nameSectionContaining: contents [

	self sectionNamed: 'NAME' containing: contents
]

{ #category : #'printing - sections' }
LaunchpadHelpPrinter >> optionsSectionDescribing: options [

	options ifNotEmpty: [ 
		stream
			nextPutAll: 'OPTIONS';
			cr.
		options do: [ :option | 
			stream tab: 2.
			option printHelpOn: stream.
			stream
				cr;
				tab: 3;
				nextPutAll: option summary;
				cr
			]
		]
]

{ #category : #'printing - sections' }
LaunchpadHelpPrinter >> parametersAndEnvironmentSectionDescribing: parameters [

	parameters ifNotEmpty: [ 
		stream
			nextPutAll: 'PARAMETERS';
			cr.
		parameters do: [ :parameter | 
			stream
				tab: 2;
				nextPutAll: '--';
				nextPutAll: parameter commandLineArgumentName;
				nextPutAll: '=<';
				nextPutAll: parameter attributeName;
				nextPutAll: '>';
				cr;
				tab: 3;
				nextPutAll: parameter summary;
				nextPut: $.;
				cr
			].
		stream
			nextPutAll: 'ENVIRONMENT';
			cr.
		parameters do: [ :parameter | 
			stream
				tab: 2;
				nextPutAll: parameter environmentVariableName;
				cr;
				tab: 3;
				nextPutAll: parameter summary;
				nextPut: $.;
				cr
			]
		]
]

{ #category : #'printing - sections' }
LaunchpadHelpPrinter >> sectionNamed: sectionName containing: contents [

	stream nextPutAll: sectionName.
	contents linesDo: [ :line | 
		stream
			cr;
			tab: 2;
			nextPutAll: line;
			cr
		]
]

{ #category : #'printing - sections' }
LaunchpadHelpPrinter >> synopsysSectionFor: commandName with: aBlock [

	stream
		nextPutAll: 'SYNOPSYS';
		cr;
		tab: 2;
		nextPutAll: commandName.
	aBlock value.
	stream cr
]
