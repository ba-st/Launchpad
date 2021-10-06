Class {
	#name : #ConfigurationParameter,
	#superclass : #Object,
	#category : #'Launchpad-Configuration'
}

{ #category : #accessing }
ConfigurationParameter >> asAttributeName: string [

	| parts |

	parts := string substrings.
	^ parts first asLowercase , ( String streamContents: [ :stream | 
		    parts allButFirstDo: [ :word | stream nextPutAll: word capitalized ] ] )
]

{ #category : #accessing }
ConfigurationParameter >> asIniFileSection [

	^ String streamContents: [ :stream | 
		  self sections do: [ :section | stream nextPutAll: ( self asIniFileSectionName: section ) ]
			  separatedBy: [ stream nextPut: $. ]
		  ]
]

{ #category : #accessing }
ConfigurationParameter >> asIniFileSectionName: string [

	^ string collect: [ :character | 
		  character isAlphaNumeric ifTrue: [ character ]
			  ifFalse: [ $- ]
		  ]
]

{ #category : #converting }
ConfigurationParameter >> asSensitive [

	^ SensitiveConfigurationParameter over: self
]

{ #category : #accessing }
ConfigurationParameter >> attributeName [

	^ self asAttributeName: self name
]

{ #category : #accessing }
ConfigurationParameter >> commandLineArgumentName [

	| transformer |

	transformer := [ :string :stream | 
	               string do: [ :character | 
		               stream nextPut: ( character isAlphaNumeric ifTrue: [ character asLowercase ]
				                 ifFalse: [ $- ] )
		               ]
	               ].

	^ String streamContents: [ :stream | 
		  self sections do: [ :section | 
			  transformer value: section value: stream.
			  stream nextPut: $.
			  ].
		  transformer value: self name value: stream
		  ]
]

{ #category : #accessing }
ConfigurationParameter >> environmentVariableName [

	| transformer |

	transformer := [ :string :stream | 
	               string do: [ :character | 
		               stream nextPut: ( character isAlphaNumeric ifTrue: [ character asUppercase ]
				                 ifFalse: [ $_ ] )
		               ]
	               ].

	^ String streamContents: [ :stream | 
		  self sections do: [ :section | 
			  transformer value: section value: stream.
			  stream nextPutAll: '__'
			  ].
		  transformer value: self name value: stream
		  ]
]

{ #category : #logging }
ConfigurationParameter >> logValueIn: configuration [

	LaunchpadLogRecord emitInfo:
		( '<1s>: <2s>' expandMacrosWith: self name with: ( configuration valueFor: self ) )
]

{ #category : #accessing }
ConfigurationParameter >> name [

	^ self subclassResponsibility
]

{ #category : #printing }
ConfigurationParameter >> printAsCommandLineArgumentTemplateOn: stream [

	self subclassResponsibility
]

{ #category : #resolving }
ConfigurationParameter >> resolveValueUsing: aConfigurationProvider ifUnresolvable: aBlock [

	^ self subclassResponsibility
]

{ #category : #accessing }
ConfigurationParameter >> sections [

	^ self subclassResponsibility
]

{ #category : #accessing }
ConfigurationParameter >> sectionsAsAttributeNames [

	^ self sections collect: [ :section | self asAttributeName: section ]
]

{ #category : #accessing }
ConfigurationParameter >> summary [

	^ self subclassResponsibility
]
