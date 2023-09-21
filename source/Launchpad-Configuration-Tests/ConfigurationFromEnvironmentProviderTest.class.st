"
A ConfigurationFromEnvironmentProviderTest is a test class for testing the behavior of ConfigurationFromEnvironmentProvider
"
Class {
	#name : #ConfigurationFromEnvironmentProviderTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Configuration-Tests'
}

{ #category : #private }
ConfigurationFromEnvironmentProviderTest >> set: environmentVariableName to: value during: aBlock [

	LanguagePlatform current os
		environmentAt: environmentVariableName
		put: value.
	aBlock ensure: [
		LanguagePlatform current os removeEnvironmentKey:
			environmentVariableName ]
]

{ #category : #tests }
ConfigurationFromEnvironmentProviderTest >> testMandatoryConfigurationParameterValue [

	| provider parameter |

	parameter := MandatoryConfigurationParameter named: 'Launchpad Hostname'
		             describedBy: 'Hostname to connect.'
		             inside: #( 'Buenos Aires Smalltalk' ).

	provider := ConfigurationFromEnvironmentProvider new.

	self set: parameter environmentVariableName to: 'localhost' during: [ 
		self assert: ( parameter resolveValueUsing: provider ifUnable: [ self fail ] ) equals: 'localhost' ]
]

{ #category : #tests }
ConfigurationFromEnvironmentProviderTest >> testMandatoryConfigurationParameterValueMissing [

	| provider parameter |

	parameter := MandatoryConfigurationParameter named: 'Launchpad Hostname'
		             describedBy: 'Hostname to connect.'
		             inside: #( 'Buenos Aires Smalltalk' ).

	provider := ConfigurationFromEnvironmentProvider new.

	self assert: ( parameter resolveValueUsing: provider ifUnable: [ 'example.com' ] )
		equals: 'example.com'
]

{ #category : #tests }
ConfigurationFromEnvironmentProviderTest >> testOptionalConfigurationParameterValue [

	| provider parameter |

	parameter := OptionalConfigurationParameter named: 'Launchpad Hostname'
		             describedBy: 'Hostname to connect.'
		             inside: #( 'Buenos Aires Smalltalk' )
		             defaultingTo: 'localhost'.

	provider := ConfigurationFromEnvironmentProvider new.

	self set: parameter environmentVariableName to: 'https://example.com' during: [ 
		self assert: ( parameter resolveValueUsing: provider ifUnable: [ self fail ] )
			equals: 'https://example.com'
		]
]

{ #category : #tests }
ConfigurationFromEnvironmentProviderTest >> testOptionalConfigurationParameterValueUsingDefault [

	| provider parameter |

	parameter := OptionalConfigurationParameter named: 'Launchpad Hostname'
		             describedBy: 'Hostname to connect.'
		             inside: #( 'Buenos Aires Smalltalk' )
		             defaultingTo: 'localhost'.

	provider := ConfigurationFromEnvironmentProvider new.

	self assert: ( parameter resolveValueUsing: provider ifUnable: [ self fail ] ) equals: 'localhost'
]

{ #category : #tests }
ConfigurationFromEnvironmentProviderTest >> testSensitiveMandatoryConfigurationParameterValue [

	| provider parameter |

	parameter := ( MandatoryConfigurationParameter named: 'Launchpad Hostname'
		               describedBy: 'Hostname to connect.'
		               inside: #( 'Buenos Aires Smalltalk' ) ) asSensitive.

	provider := ConfigurationFromEnvironmentProvider new.

	self set: parameter environmentVariableName to: 'localhost' during: [ 
		self assert: ( parameter resolveValueUsing: provider ifUnable: [ self fail ] ) equals: 'localhost' ]
]

{ #category : #tests }
ConfigurationFromEnvironmentProviderTest >> testSensitiveOptionalConfigurationParameterValue [

	| provider parameter |

	parameter := ( OptionalConfigurationParameter named: 'Launchpad Hostname'
		               describedBy: 'Hostname to connect.'
		               inside: #( 'Buenos Aires Smalltalk' )
		               defaultingTo: 'localhost' ) asSensitive.

	provider := ConfigurationFromEnvironmentProvider new.

	self set: parameter environmentVariableName to: 'https://example.com' during: [ 
		self assert: ( parameter resolveValueUsing: provider ifUnable: [ self fail ] )
			equals: 'https://example.com'
		]
]

{ #category : #tests }
ConfigurationFromEnvironmentProviderTest >> testValueResolutionDelegatesToNextInChainWhenMissing [

	| provider parameter |

	parameter := MandatoryConfigurationParameter named: 'Launchpad Hostname'
		             describedBy: 'Hostname to connect.'
		             inside: #( 'Buenos Aires Smalltalk' ).

	provider := ConfigurationFromEnvironmentProvider chainedWith:
		            ( ConfigurationFromCommandLineProvider over: ( CommandLineArguments withArguments:
				                #( '--buenos-aires-smalltalk.launchpad-hostname=api.example.com' ) ) ).

	self assert: ( parameter resolveValueUsing: provider ifUnable: [ self fail ] )
		equals: 'api.example.com'
]
