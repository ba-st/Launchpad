"
An ApplicationConfigurationTest is a test class for testing the behavior of ApplicationConfiguration
"
Class {
	#name : #ApplicationConfigurationTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Configuration-Tests'
}

{ #category : #private }
ApplicationConfigurationTest >> commandLineProviderOver: arguments [

	^ ConfigurationFromCommandLineProvider over: ( CommandLineArguments withArguments: arguments )
]

{ #category : #private }
ApplicationConfigurationTest >> createFileNamed: fileName containing: fileContents during: aBlock [

	| fileReference |

	fileReference := fileName asFileReference.
	fileReference ensureCreateFile.
	[ 
	fileReference writeStreamDo: [ :stream | stream nextPutAll: fileContents ].
	aBlock value
	] ensure: [ fileReference ensureDelete ]
]

{ #category : #private }
ApplicationConfigurationTest >> newApplicationConfiguration [

	| provider parameters |

	parameters := Array
		              with: ( MandatoryConfigurationParameter named: 'Port'
				                describedBy: 'Port'
				                inside: #( 'Communications' 'HTTP' )
				                convertingWith: #asInteger )
		              with: ( MandatoryConfigurationParameter named: 'Public URL'
				                describedBy: 'Public URL'
				                convertingWith: #asUrl ) asSensitive
		              with: ( OptionalConfigurationParameter named: 'Scheme'
				                describedBy: 'Scheme'
				                inside: #( 'Communications' 'HTTP' )
				                defaultingTo: 'https' )
		              with: ( OptionalConfigurationParameter named: 'Consul Agent Location'
				                describedBy: 'Location of the Consul Agent'
				                inside: #( 'Service Discovery' )
				                defaultingTo: 'localhost' ).

	provider := self commandLineProviderOver:
		            #( '--communications.http.port=8086' '--public-url=https://api.example.com' ).
	^ ApplicationConfiguration forAll: parameters providedBy: provider
]

{ #category : #tests }
ApplicationConfigurationTest >> testAccessing [

	| configuration parameters provider |

	parameters := Array
		              with: ( MandatoryConfigurationParameter named: 'Port'
				                describedBy: 'Port'
				                inside: #( 'Communications' 'HTTP' )
				                convertingWith: #asInteger )
		              with: ( MandatoryConfigurationParameter named: 'Public URL'
				                describedBy: 'Public URL'
				                convertingWith: #asUrl ) asSensitive
		              with: ( OptionalConfigurationParameter named: 'Scheme'
				                describedBy: 'Scheme'
				                inside: #( 'Communications' 'HTTP' )
				                defaultingTo: 'https' ).

	provider := self commandLineProviderOver:
		            #( '--communications.http.port=8086' '--public-url=https://api.example.com' ).

	configuration := ApplicationConfiguration forAll: parameters providedBy: provider.

	self
		assert: configuration publicURL equals: 'https://api.example.com' asUrl;
		assert: configuration communications http port equals: 8086;
		assert: configuration communications http scheme equals: 'https'
]

{ #category : #tests }
ApplicationConfigurationTest >> testAsCommandLine [

	| configuration commandLine |

	configuration := self newApplicationConfiguration.
	commandLine := String streamContents: [ :stream | configuration asCommandLineOn: stream ].
	self assert: commandLine
		equals:
		' --communications.http.port=8086 --communications.http.scheme=https --public-url=https://api.example.com/ --service-discovery.consul-agent-location=localhost'
]

{ #category : #tests }
ApplicationConfigurationTest >> testAsEnvironment [

	| configuration env |

	configuration := self newApplicationConfiguration.
	env := String streamContents: [ :stream | configuration asEnvironmentOn: stream ].
	self assert: env equals: '# Port
COMMUNICATIONS__HTTP__PORT=8086
# Scheme. Defaults to https
COMMUNICATIONS__HTTP__SCHEME=https
# Public URL
PUBLIC_URL=https://api.example.com/
# Location of the Consul Agent. Defaults to localhost
SERVICE_DISCOVERY__CONSUL_AGENT_LOCATION=localhost
'
]

{ #category : #tests }
ApplicationConfigurationTest >> testAsIniFile [

	| configuration ini |

	configuration := self newApplicationConfiguration.
	ini := String streamContents: [ :stream | configuration asIniFileOn: stream ].
	self assert: ini equals: '; Public URL
publicURL = https://api.example.com/

[Communications.HTTP]
; Port
port = 8086
; Scheme. Defaults to https
scheme = https

[Service-Discovery]
; Location of the Consul Agent. Defaults to localhost
consulAgentLocation = localhost
'
]

{ #category : #tests }
ApplicationConfigurationTest >> testAsJson [

	| configuration json |

	configuration := self newApplicationConfiguration.
	json := NeoJSONObject fromString: configuration asJson.
	self
		assert: ( json at: #publicURL ) equals: 'https://api.example.com/';
		assert: ( json atPath: #( #communications #http #port ) ) equals: 8086;
		assert: ( json atPath: #( #communications #http #scheme ) ) equals: 'https';
		assert: ( json atPath: #( #serviceDiscovery #consulAgentLocation ) ) equals: 'localhost'
]

{ #category : #tests }
ApplicationConfigurationTest >> testCantCreateConfigurationWhenParameterConflictsWithSection [

	| parameters provider |

	parameters := Array with: ( MandatoryConfigurationParameter named: 'Port' describedBy: '' )
		              with:
		              ( MandatoryConfigurationParameter named: 'External'
			                describedBy: ''
			                inSection: 'Port' ) asSensitive.
	provider := self commandLineProviderOver: #( '--port=8086' ).

	self should: [ ApplicationConfiguration forAll: parameters providedBy: provider ]
		raise: ConflictingObjectFound
		withMessageText: 'Conflicting parameter: "External"'
]

{ #category : #tests }
ApplicationConfigurationTest >> testCantCreateConfigurationWithOverlappingParameters [

	| parameters provider |

	parameters := Array with: ( MandatoryConfigurationParameter named: 'Port' describedBy: '' )
		              with: ( MandatoryConfigurationParameter named: 'Port' describedBy: '' ) asSensitive.
	provider := self commandLineProviderOver: #( '--port=8086' ).

	self should: [ ApplicationConfiguration forAll: parameters providedBy: provider ]
		raise: ConflictingObjectFound
		withMessageText: 'Conflicting parameter: "Port"'
]

{ #category : #tests }
ApplicationConfigurationTest >> testLoadingIniBasedSettings [

	| configuration iniFile provider |

	configuration := self newApplicationConfiguration.
	iniFile := FileSystem memory / 'settings.ini'.
	iniFile writeStreamDo: [ :stream | configuration asIniFileOn: stream ].

	provider := ConfigurationFromSettingsFileProvider loading: iniFile.
	configuration := ApplicationConfiguration forAll: configuration parameters providedBy: provider.

	self
		assert: configuration publicURL equals: 'https://api.example.com' asUrl;
		assert: configuration communications http port equals: 8086;
		assert: configuration communications http scheme equals: 'https'
]

{ #category : #tests }
ApplicationConfigurationTest >> testLoadingJsonSettings [

	| configuration jsonFile provider |

	configuration := self newApplicationConfiguration.
	jsonFile := FileSystem memory / 'settings.json'.
	jsonFile writeStreamDo: [ :stream | configuration asJsonOn: stream ].

	provider := ConfigurationFromSettingsFileProvider loading: jsonFile.
	configuration := ApplicationConfiguration forAll: configuration parameters providedBy: provider.

	self
		assert: configuration publicURL equals: 'https://api.example.com' asUrl;
		assert: configuration communications http port equals: 8086;
		assert: configuration communications http scheme equals: 'https'
]

{ #category : #tests }
ApplicationConfigurationTest >> testMissingParameterValue [

	| parameter |

	parameter := MandatoryConfigurationParameter named: 'Port' describedBy: 'Port'.

	self
		should: [ 
			ApplicationConfiguration forAll: ( Array with: parameter )
				providedBy: NullConfigurationProvider new ]
		raise: RequiredConfigurationNotFound
		withMessageText: '"Port" parameter not present.'
]

{ #category : #tests }
ApplicationConfigurationTest >> testReloadingConfiguration [

	| fileName configuration |

	fileName := '<1s>-settings.json' expandMacrosWith: testSelector asString.

	configuration := self newApplicationConfiguration.

	self createFileNamed: fileName asFileReference containing: configuration asJson during: [ 
		| provider |

		provider := ConfigurationFromSettingsFileProvider loading: fileName asFileReference.
		configuration := ApplicationConfiguration forAll: configuration parameters providedBy: provider
		].

	self
		assert: configuration publicURL equals: 'https://api.example.com' asUrl;
		assert: configuration communications http port equals: 8086;
		assert: configuration communications http scheme equals: 'https';
		assert: configuration serviceDiscovery consulAgentLocation equals: 'localhost'.

	self createFileNamed: fileName asFileReference
		containing:
		'{"communications":{"http":{"port":9090,"scheme":"http"}},"publicURL":"http://api.example.com/","serviceDiscovery":{"consulAgentLocation":"consul.example.com"}}'
		during: [ configuration reload ].

	self
		assert: configuration publicURL equals: 'http://api.example.com' asUrl;
		assert: configuration communications http port equals: 9090;
		assert: configuration communications http scheme equals: 'http';
		assert: configuration serviceDiscovery consulAgentLocation equals: 'consul.example.com'
]

{ #category : #tests }
ApplicationConfigurationTest >> testReloadingEmptyConfiguration [

	| fileName configuration |

	fileName := '<1s>-settings.json' expandMacrosWith: testSelector asString.

	configuration := self newApplicationConfiguration.

	self createFileNamed: fileName asFileReference containing: configuration asJson during: [ 
		| provider |

		provider := ConfigurationFromSettingsFileProvider loading: fileName asFileReference.
		configuration := ApplicationConfiguration forAll: configuration parameters providedBy: provider
		].

	self
		assert: configuration publicURL equals: 'https://api.example.com' asUrl;
		assert: configuration communications http port equals: 8086;
		assert: configuration communications http scheme equals: 'https';
		assert: configuration serviceDiscovery consulAgentLocation equals: 'localhost'.

	self createFileNamed: fileName asFileReference
		containing: '{}'
		during: [ self should: [ configuration reload ] raise: RequiredConfigurationNotFound ].

	self
		assert: configuration publicURL equals: 'https://api.example.com' asUrl;
		assert: configuration communications http port equals: 8086;
		assert: configuration communications http scheme equals: 'https';
		assert: configuration serviceDiscovery consulAgentLocation equals: 'localhost'
]

{ #category : #tests }
ApplicationConfigurationTest >> testReloadingIniBasedSettings [

	| configuration iniFile provider |

	configuration := self newApplicationConfiguration.
	iniFile := FileSystem memory / 'settings.ini'.
	iniFile ensureCreateFile.

	provider := ConfigurationFromSettingsFileProvider loading: iniFile.

	self should: [ ApplicationConfiguration forAll: configuration parameters providedBy: provider ]
		raise: RequiredConfigurationNotFound.

	iniFile writeStreamDo: [ :stream | configuration asIniFileOn: stream ].

	self should: [ ApplicationConfiguration forAll: configuration parameters providedBy: provider ]
		raise: RequiredConfigurationNotFound.

	provider reloadConfiguration.	

	configuration := ApplicationConfiguration forAll: configuration parameters providedBy: provider.

	self
		assert: configuration publicURL equals: 'https://api.example.com' asUrl;
		assert: configuration communications http port equals: 8086;
		assert: configuration communications http scheme equals: 'https'
]

{ #category : #tests }
ApplicationConfigurationTest >> testReloadingJsonSettings [

	| configuration json provider |

	configuration := self newApplicationConfiguration.
	json := FileSystem memory / 'settings.json'.
	json ensureCreateFile.

	provider := ConfigurationFromSettingsFileProvider loading: json.

	self should: [ ApplicationConfiguration forAll: configuration parameters providedBy: provider ]
		raise: RequiredConfigurationNotFound.

	json writeStreamDo: [ :stream | configuration asJsonOn: stream ].

	self should: [ ApplicationConfiguration forAll: configuration parameters providedBy: provider ]
		raise: RequiredConfigurationNotFound.

	provider reloadConfiguration.

	configuration := ApplicationConfiguration forAll: configuration parameters providedBy: provider.

	self
		assert: configuration publicURL equals: 'https://api.example.com' asUrl;
		assert: configuration communications http port equals: 8086;
		assert: configuration communications http scheme equals: 'https'
]

{ #category : #tests }
ApplicationConfigurationTest >> testValueForGlobalParameter [

	| configuration parameter provider |

	parameter := MandatoryConfigurationParameter named: 'Port'
		             describedBy: 'Port'
		             convertingWith: #asInteger.

	provider := self commandLineProviderOver: #( '--port=8086' ).

	configuration := ApplicationConfiguration forAll: ( Array with: parameter ) providedBy: provider.

	self assert: ( configuration valueFor: parameter ) equals: 8086
]

{ #category : #tests }
ApplicationConfigurationTest >> testValueForParameterInSection [

	| configuration parameter provider |

	parameter := MandatoryConfigurationParameter named: 'Port'
		             describedBy: 'Listening port'
		             inside: #( 'Communications' 'HTTP' )
		             convertingWith: #asInteger.

	provider := self commandLineProviderOver: #( '--communications.http.port=8086' ).

	configuration := ApplicationConfiguration forAll: ( Array with: parameter ) providedBy: provider.

	self assert: ( configuration valueFor: parameter ) equals: 8086
]
