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

{ #category : #initialization }
ApplicationConfiguration >> missingConfigurationFor: parameter [

	LaunchpadLogRecord emitError:
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

	| currentSection resolvedValues |

	resolvedValues := NeoJSONObject new.
	parameters do: [ :parameter | 
		currentSection := resolvedValues.
		parameter sectionsAsAttributeNames do: [ :section | 
			currentSection := currentSection at: section asSymbol ifAbsentPut: [ NeoJSONObject new ] ].
		AssertionChecker enforce: [ currentSection isKindOf: NeoJSONObject ]
			because: [ 'Conflicting parameter: "<1s>"' expandMacrosWith: parameter name ]
			raising: ConflictingObjectFound.
		currentSection
			at: parameter attributeName asSymbol
			ifPresent: [ 
				ConflictingObjectFound signal:
					( 'Conflicting parameter: "<1s>"' expandMacrosWith: parameter name ) ]
			ifAbsentPut: [ 
			parameter resolveValueUsing: provider ifUnresolvable: [ self missingConfigurationFor: parameter ] ]
		].
	
	 "The update is performed atomically in case the resolution fails, for example during a configuration reload attempt"
	values := resolvedValues
]

{ #category : #'reflective operations' }
ApplicationConfiguration >> respondsTo: selector [

	^ ( super respondsTo: selector ) or: [ values includesKey: selector ]
]

{ #category : #accessing }
ApplicationConfiguration >> valueFor: aParameter [

	| section |

	section := aParameter sectionsAsAttributeNames inject: values
		           into: [ :current :sectionName | current at: sectionName asSymbol ].
	^ section at: aParameter attributeName asSymbol
]
