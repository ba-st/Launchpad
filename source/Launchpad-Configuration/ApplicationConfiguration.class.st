Class {
	#name : #ApplicationConfiguration,
	#superclass : #Object,
	#instVars : [
		'parameters',
		'provider',
		'values'
	],
	#category : #'Launchpad-Configuration'
}

{ #category : #'instance creation' }
ApplicationConfiguration class >> forAll: parameters providedBy: aConfigurationProvider [

	^ self new initializeForAll: parameters providedBy: aConfigurationProvider
]

{ #category : #converting }
ApplicationConfiguration >> asCommandLineOn: stream [

	( parameters sorted: #commandLineArgumentName ascending ) do: [ :parameter | 
		stream
			space;
			nextPutAll: '--';
			nextPutAll: parameter commandLineArgumentName;
			nextPut: $=;
			nextPutAll: ( self valueFor: parameter ) asString
		]
]

{ #category : #converting }
ApplicationConfiguration >> asEnvironmentOn: stream [

	( parameters sorted: #environmentVariableName ascending ) do: [ :parameter | 
		stream
			nextPut: $#;
			space;
			nextPutAll: parameter summary;
			cr;
			nextPutAll: parameter environmentVariableName;
			nextPut: $=;
			nextPutAll: ( self valueFor: parameter ) asString;
			cr
		]
]

{ #category : #private }
ApplicationConfiguration >> asIniFile: aParameterCollection on: stream [

	( aParameterCollection sorted: #attributeName ascending ) do: [ :parameter | 
		stream
			nextPut: $;;
			space;
			nextPutAll: parameter summary;
			cr;
			nextPutAll: parameter attributeName;
			space;
			nextPut: $=;
			space;
			nextPutAll: ( self valueFor: parameter ) asString;
			cr
		]
]

{ #category : #converting }
ApplicationConfiguration >> asIniFileOn: stream [

	| settingsInSection |

	self asIniFile: ( parameters select: [ :parameter | parameter sections isEmpty ] ) on: stream.

	settingsInSection := ( parameters select: [ :parameter | parameter sections notEmpty ] ) 
		                     groupedBy: [ :parameter | parameter asIniFileSection ].
	settingsInSection keys sorted do: [ :section | 
		stream
			cr;
			nextPut: $[;
			nextPutAll: section;
			nextPut: $];
			cr.
		self asIniFile: ( settingsInSection at: section ) on: stream
		]
]

{ #category : #converting }
ApplicationConfiguration >> asJson [

	^ String streamContents: [ :stream | self asJsonOn: stream ]
]

{ #category : #converting }
ApplicationConfiguration >> asJsonOn: stream [

	^ ( NeoJSONWriterSortingKeys on: stream )
		  prettyPrint: true;
		  for: ZnUrl customDo: [ :mapping | mapping encoder: [ :url | url printString ] ];
		  nextPut: values
]

{ #category : #private }
ApplicationConfiguration >> assert: section isNotInConflictWithParameterNamed: name [

	"Sections in the configuration are instances of NeoJSONObject, if we get 
	another kind of object it's because there's a parameter with the same name"

	AssertionChecker enforce: [ section isKindOf: NeoJSONObject ]
		because: [ 'Section conflicting with parameter: "<1s>"' expandMacrosWith: name ]
		raising: ConflictingObjectFound
]

{ #category : #private }
ApplicationConfiguration >> containingSectionFor: parameter startingAt: resolvedValues [

	| currentSection |

	currentSection := resolvedValues.
	parameter sections do: [ :name | 
		currentSection := currentSection at: ( parameter asAttributeName: name ) asSymbol
			                  ifAbsentPut: [ NeoJSONObject new ].
		self assert: currentSection isNotInConflictWithParameterNamed: name
		].
	^ currentSection
]

{ #category : #'reflective operations' }
ApplicationConfiguration >> doesNotUnderstand: message [

	^ values at: message selector ifAbsent: [ super doesNotUnderstand: message ]
]

{ #category : #initialization }
ApplicationConfiguration >> initializeForAll: aParameterCollection providedBy: aConfigurationProvider [

	parameters := aParameterCollection.
	provider := aConfigurationProvider.
	self resolveParameterValues
]

{ #category : #private }
ApplicationConfiguration >> missingConfigurationFor: parameter [

	LogRecord emitError:
		( '"<1s>" parameter not provided. You must provide one.' expandMacrosWith: parameter name ).
	RequiredConfigurationNotFound signal:
		( '"<1s>" parameter not present.' expandMacrosWith: parameter name )
]

{ #category : #accessing }
ApplicationConfiguration >> parameters [

	^ parameters
]

{ #category : #actions }
ApplicationConfiguration >> reload [

	provider reloadConfiguration.
	self resolveParameterValues
]

{ #category : #initialization }
ApplicationConfiguration >> resolveParameterValues [

	| section resolvedValues |

	resolvedValues := NeoJSONObject new.
	parameters do: [ :parameter | 
		section := self containingSectionFor: parameter startingAt: resolvedValues.
		section at: parameter attributeName asSymbol
			ifPresent: [ self signalAsConflictingParameter: parameter ]
			ifAbsentPut: [ 
			parameter resolveValueUsing: provider ifUnable: [ self missingConfigurationFor: parameter ] ]
		].
	self synchronizeValuesWith: resolvedValues
]

{ #category : #'reflective operations' }
ApplicationConfiguration >> respondsTo: selector [

	^ ( super respondsTo: selector ) or: [ values includesKey: selector ]
]

{ #category : #private }
ApplicationConfiguration >> signalAsConflictingParameter: parameter [

	ConflictingObjectFound signal: ( 'Conflicting parameter: "<1s>"' expandMacrosWith: parameter name )
]

{ #category : #private }
ApplicationConfiguration >> synchronizeValuesWith: resolvedValues [

	values := resolvedValues
]

{ #category : #accessing }
ApplicationConfiguration >> valueFor: aParameter [

	| section |

	section := aParameter sectionsAsAttributeNames inject: values
		           into: [ :current :sectionName | current at: sectionName asSymbol ].
	^ section at: aParameter attributeName asSymbol
]
