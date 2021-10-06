"
A LaunchpadMainCommandTest is a test class for testing the behavior of LaunchpadMainCommand
"
Class {
	#name : #LaunchpadMainCommandTest,
	#superclass : #TestCase,
	#instVars : [
		'command',
		'logger'
	],
	#category : #'Launchpad-Commands-Tests'
}

{ #category : #private }
LaunchpadMainCommandTest >> assertCommandCanHandleNextArgumentIn: context [

	self assert: ( command canHandle: ( context nextCommandLineArgumentIfNone: [ self fail ] ) )
]

{ #category : #private }
LaunchpadMainCommandTest >> contextWithArguments: arguments writingTo: outputStream [

	^ LaunchpadCommandLineProcessingContext handling: ( CommandLineArguments withArguments: arguments )
		  writingTo: outputStream
]

{ #category : #private }
LaunchpadMainCommandTest >> createFileNamed: fileName containing: fileContents during: aBlock [

	| fileReference |

	fileReference := fileName asFileReference.
	fileReference ensureCreateFile.
	[ 
	fileReference writeStreamDo: [ :stream | stream nextPutAll: fileContents ].
	aBlock value
	] ensure: [ fileReference ensureDelete ]
]

{ #category : #private }
LaunchpadMainCommandTest >> expectedExplainBrokenHelpOutput [

	^ 'NAME<n>		broken [v0.0.1] - A broken application<n>SYNOPSYS<n>		broken [--raise-error]<n>COMMANDS<n>		--raise-error<n>			Raises an unexpected error. Useful to test stack trace generation.<n>'
		  expandMacros
]

{ #category : #private }
LaunchpadMainCommandTest >> expectedExplainGreeterHelpOutput [

	^ 'NAME<n>		greeter [v1.0.0] - A greetings application<n>SYNOPSYS<n>		greeter --name=%<name> [--title=%<title>]<n>PARAMETERS<n>		--name=%<name><n>			The name of the user to greet.<n>		--title=%<title><n>			The title of the user to greet. Defaults to nothing.<n>ENVIRONMENT<n>		NAME<n>			The name of the user to greet.<n>		TITLE<n>			The title of the user to greet. Defaults to nothing.<n>'
		  expandMacros
]

{ #category : #private }
LaunchpadMainCommandTest >> expectedExplainHelpOutput [

	^ 'NAME<n>		launchpad-explain - Give details about the selected application<n>SYNOPSYS<n>		launchpad explain [--help|-h] %<app><n>DESCRIPTION<n>		Give details about the application selected via %<app> including its configuration options.<n>OPTIONS<n>		-h, --help<n>			Print this help message and exit.<n>'
		  expandMacros			
]

{ #category : #private }
LaunchpadMainCommandTest >> expectedHelpOutput [

	^ 'NAME<n>		launchpad - A minimal application launcher<n>SYNOPSYS<n>		launchpad [--version] [--help|-h] %<command><n>DESCRIPTION<n>		Launchpad provides a command-line handler used to start, list, and explain the available applications contained in the image.<n>OPTIONS<n>		--version<n>			Print the version and exit.<n>		-h, --help<n>			Print this help message and exit.<n>COMMANDS<n>		start<n>			Start the selected application<n>		list<n>			List available applications<n>		explain<n>			Give details about the selected application<n>'
		  expandMacros
]

{ #category : #private }
LaunchpadMainCommandTest >> expectedListHelpOutput [

	^ 'NAME<n>		launchpad-list - List available applications<n>SYNOPSYS<n>		launchpad list [--verbose|-v] [--help|-h]<n>DESCRIPTION<n>		Lists the available applications contained in the image.<n>OPTIONS<n>		-v, --verbose<n>			Produce more verbose output.<n>		-h, --help<n>			Print this help message and exit.<n>'
		  expandMacros
]

{ #category : #private }
LaunchpadMainCommandTest >> expectedStartHelpOutput [

	^ 'NAME<n>		launchpad-start - Start the selected application<n>SYNOPSYS<n>		launchpad start [--help|-h] [--debug-mode] [--settings-file=%<filename>] %<app> [%<parameters>]<n>DESCRIPTION<n>		Start the application selected via %<app>.<n><n><t><t>Application configuration is made by the command-line via %<parameters>, using environment variables or settings files.<n><n><t><t>Execute launchpad explain %<app> to get a list of valid configuration parameters.<n>OPTIONS<n>		-h, --help<n>			Print this help message and exit.<n>		--debug-mode<n>			Enable the debugging mode. The image will not quit on unexpected errors. This configuration can be used in the application to improve the debugging experience.<n>		--settings-file=%<filename><n>			Provide application configuration via a settings file. This option can occur several times to configure more than one settings file. Supported file settings formats are INI and JSON.<n>'
		  expandMacros			
]

{ #category : #private }
LaunchpadMainCommandTest >> expectedVerboseListOutput [

	^ String streamContents: [ :stream | 
		  LaunchpadApplication availableApplications
			  do: [ :application | 
				  stream
					  nextPutAll: application commandName;
					  space;
					  nextPutAll: application version;
					  space;
					  nextPutAll: application description
				  ]
			  separatedBy: [ stream nextPutAll: '<n>' expandMacros ].
		  stream nextPutAll: '<n>' expandMacros
		  ]
]

{ #category : #private }
LaunchpadMainCommandTest >> handle: arguments [

	^ String streamContents: [ :stream | 
		  | context |

		  context := self contextWithArguments: arguments writingTo: stream.

		  self assertCommandCanHandleNextArgumentIn: context.

		  logger runDuring: [ self use: 'v4.0.0' asVersionDuring: [ command evaluateWithin: context ] ]
		  ]
]

{ #category : #private }
LaunchpadMainCommandTest >> handle: arguments onExitDo: aBlock [

	^ String streamContents: [ :stream | 
		  | context |

		  context := self contextWithArguments: arguments writingTo: stream.

		  self assertCommandCanHandleNextArgumentIn: context.

		  self should: [ 
			  logger runDuring: [ self use: 'v4.0.0' asVersionDuring: [ command evaluateWithin: context ] ] ]
			  raise: Exit
			  withExceptionDo: aBlock
		  ]
]

{ #category : #private }
LaunchpadMainCommandTest >> set: environmentVariableName to: value during: aBlock [

	OSPlatform current environment at: environmentVariableName put: value.
	aBlock ensure: [ OSPlatform current environment removeKey: environmentVariableName ]
]

{ #category : #initialization }
LaunchpadMainCommandTest >> setUp [

	super setUp.
	command := LaunchpadMainCommand new.
	logger := MemoryLogger new
]

{ #category : #tests }
LaunchpadMainCommandTest >> testAccessing [

	| options subcommands |

	self
		assert: command name equals: 'launchpad';
		assert: command summary equals: 'A minimal application launcher';
		assert: command description
		equals:
			'Launchpad provides a command-line handler used to start, list, and explain the available applications contained in the image.'.

	options := command options.
	self
		assert: options size equals: 2;
		assert: options first name equals: 'version';
		assert: options first summary equals: 'Print the version and exit.';
		assert: options last name equals: 'help';
		assert: options last shortName equals: 'h';
		assert: options last summary equals: 'Print this help message and exit.'.

	subcommands := command subcommands.

	self
		assert: subcommands size equals: 3;
		assert: subcommands first name equals: 'start';
		assert: subcommands second name equals: 'list';
		assert: subcommands last name equals: 'explain'
]

{ #category : #'tests - handling explain subcommand' }
LaunchpadMainCommandTest >> testHandlingExplainBrokenApplication [

	| output |

	output := self
		          handle: { 'launchpad'. 'explain'. LaunchpadBrokenApplication commandName }
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedExplainBrokenHelpOutput;
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling explain subcommand' }
LaunchpadMainCommandTest >> testHandlingExplainGreeterApplication [

	| output |

	output := self
		          handle: { 'launchpad'. 'explain'. LaunchpadGreeterApplication commandName }
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedExplainGreeterHelpOutput;
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling explain subcommand' }
LaunchpadMainCommandTest >> testHandlingExplainSubcommandHelp [

	| output |

	output := self handle: #( 'launchpad' 'explain' '--help' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedExplainHelpOutput;
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling explain subcommand' }
LaunchpadMainCommandTest >> testHandlingExplainSubcommandShortHelp [

	| output |

	output := self handle: #( 'launchpad' 'explain' '-h' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedExplainHelpOutput;
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling main command' }
LaunchpadMainCommandTest >> testHandlingHelpOption [

	| output |

	output := self handle: #( 'launchpad' '--help' ) onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedHelpOutput;
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling explain subcommand' }
LaunchpadMainCommandTest >> testHandlingInvalidExplainSubcommandApp [

	| output |

	output := self handle: #( 'launchpad' 'explain' 'wrong' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assert:
			( logger recordings first printString endsWith: '[ERROR] explain unknown application: wrong' )
]

{ #category : #'tests - handling explain subcommand' }
LaunchpadMainCommandTest >> testHandlingInvalidExplainSubcommandOption [

	| output |

	output := self handle: #( 'launchpad' 'explain' '--wrong' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assert:
			( logger recordings first printString endsWith: '[ERROR] explain unknown option: --wrong' )
]

{ #category : #'tests - handling list subcommand' }
LaunchpadMainCommandTest >> testHandlingInvalidListSubcommandOption [

	| output |

	output := self handle: #( 'launchpad' 'list' '--wrong' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assert:
			( logger recordings first printString endsWith: '[ERROR] list unknown option: --wrong' )
]

{ #category : #'tests - handling main command' }
LaunchpadMainCommandTest >> testHandlingInvalidOption [

	| output |

	output := self handle: #( 'launchpad' '--wrong' ) onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assert: logger recordings size equals: 1;
		assert:
			( logger recordings first printString endsWith: '[ERROR] launchpad unknown option: --wrong' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingInvalidStartSubcommandApp [

	| output |

	output := self handle: #( 'launchpad' 'start' 'wrong' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assert:
			( logger recordings first printString endsWith: '[ERROR] start unknown application: wrong' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingInvalidStartSubcommandOption [

	| output |

	output := self handle: #( 'launchpad' 'start' '--wrong' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assert: ( logger recordings first printString endsWith: '[ERROR] start unknown option: --wrong' )
]

{ #category : #tests }
LaunchpadMainCommandTest >> testHandlingInvalidSubcommand [

	| output |

	output := self handle: #( 'launchpad' 'wrong' ) onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assert: logger recordings size equals: 1;
		assert:
			( logger recordings first printString endsWith: '[ERROR] launchpad unknown command: wrong' )
]

{ #category : #'tests - handling list subcommand' }
LaunchpadMainCommandTest >> testHandlingListSubcommand [

	| output |

	output := self handle: #( 'launchpad' 'list' ) onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: ( String streamContents: [ :stream | 
					  LaunchpadApplication availableApplications do: [ :application | 
							  stream nextPutAll: application commandName ]
						  separatedBy: [ stream space ].
					  stream nextPutAll: '<n>' expandMacros
					  ] );
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling list subcommand' }
LaunchpadMainCommandTest >> testHandlingListSubcommandHelp [

	| output |

	output := self handle: #( 'launchpad' 'explain' '--help' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedExplainHelpOutput;
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling list subcommand' }
LaunchpadMainCommandTest >> testHandlingListSubcommandShortHelp [

	| output |

	output := self handle: #( 'launchpad' 'list' '-h' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedListHelpOutput;
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling list subcommand' }
LaunchpadMainCommandTest >> testHandlingListSubcommandShortVerboseMode [

	| output |

	output := self handle: #( 'launchpad' 'list' '-v' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedVerboseListOutput;
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling list subcommand' }
LaunchpadMainCommandTest >> testHandlingListSubcommandVerboseMode [

	| output |

	output := self handle: #( 'launchpad' 'list' '--verbose' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedVerboseListOutput;
		assert: logger recordings isEmpty
]

{ #category : #tests }
LaunchpadMainCommandTest >> testHandlingMissingSubcommandAndOption [

	| output |

	output := self handle: #( 'launchpad' ) onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assert: logger recordings size equals: 1;
		assert: ( logger recordings first printString endsWith: '[ERROR] Missing command or option.' )
]

{ #category : #'tests - handling main command' }
LaunchpadMainCommandTest >> testHandlingShortHelpOption [

	| output |

	output := self handle: #( 'launchpad' '-h' ) onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedHelpOutput;
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartBrokenApplication [

	| output |

	output := self handle: #( 'launchpad' 'start' 'broken' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self assert: output isEmpty.

	logger recordings with:
		#( '[INFO] Obtaining configuration...' '[INFO] Obtaining configuration... [DONE]' )
		do: [ :recording :expectedOutput | 
		self assert: ( recording printString endsWith: expectedOutput ) ]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartBrokenApplicationInDebugMode [

	| output |

	output := self handle: #( 'launchpad' 'start' '--debug-mode' 'broken' ).

	self assert: output isEmpty.

	logger recordings
		with: #( '[INFO] Obtaining configuration...' '[INFO] Obtaining configuration... [DONE]'
			   '[ERROR] Exit application' )
		do: [ :recording :expectedOutput | 
		self assert: ( recording printString endsWith: expectedOutput ) ]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartBrokenApplicationRaisingUnexpectedError [

	| output |

	output := self handle: #( 'launchpad' 'start' 'broken' '--raise-error' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self assert: output isEmpty.

	self assert: logger recordings size equals: 4.
	logger recordings
		with: #( '[INFO] Obtaining configuration...' '[INFO] Obtaining configuration... [DONE]'
			   '[ERROR] Unexpected startup error: Doh!' '[ERROR] Dumping stack due to unexpected error: "Doh!"' )
		do: [ :recording :expectedOutput | 
		self assert: ( recording printString endsWith: expectedOutput ) ]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartBrokenApplicationRaisingUnexpectedErrorInDebugMode [

	self should: [ self handle: #( 'launchpad' 'start' '--debug-mode' 'broken' '--raise-error' ) ]
		raise: Error
		withMessageText: 'Doh!'.


	self assert: logger recordings size equals: 2.
	logger recordings with:
		#( '[INFO] Obtaining configuration...' '[INFO] Obtaining configuration... [DONE]' )
		do: [ :recording :expectedOutput | 
		self assert: ( recording printString endsWith: expectedOutput ) ]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartGreeterApplication [

	| output |

	output := self
		          handle: { 
				          'launchpad'.
				          'start'.
				          LaunchpadGreeterApplication commandName.
				          '--name=John' }
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self assert: output equals: 'Hi John!<n>' expandMacros.

	logger recordings
		with:
			#( '[INFO] Obtaining configuration...' 
				'[WARNING] "Title" parameter not provided. Using default.'
			   '[INFO] Name: John' 
				'[INFO] Title: ' 
				'[INFO] Obtaining configuration... [DONE]' )
		do: [ :recording :expectedOutput | 
		self assert: ( recording printString endsWith: expectedOutput ) ]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartGreeterApplicationInDebugMode [

	| output |

	output := self handle: { 
			          'launchpad'.
			          'start'.
			          '--debug-mode'.
			          LaunchpadGreeterApplication commandName.
			          '--name=John' }.

	self assert: output equals: 'Hi John!<n>' expandMacros.

	logger recordings
		with:
			#( '[INFO] Obtaining configuration...' '[WARNING] "Title" parameter not provided. Using default.'
			   '[INFO] Name: John' '[INFO] Title: ' '[INFO] Obtaining configuration... [DONE]'
			   '[INFO] Exit application successfuly' )
		do: [ :recording :expectedOutput | 
		self assert: ( recording printString endsWith: expectedOutput ) ]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartGreeterApplicationLoadingSettingsFile [

	| fileName |

	fileName := '<1s>-settings.json' expandMacrosWith: testSelector asString.
	self
		createFileNamed: fileName
		containing: ( NeoJSONWriter toStringPretty: ( Dictionary new
					    at: 'name' put: 'Jones';
					    at: 'title' put: 'Mr.';
					    yourself ) )
		during: [ 
			| output |

			output := self
				          handle: { 
						          'launchpad'.
						          'start'.
						          ( '--settings-file=<1s>' expandMacrosWith: fileName ).
						          LaunchpadGreeterApplication commandName }
				          onExitDo: [ :exit | self assert: exit isSuccess ].

			self assert: output equals: 'Hi Mr. Jones!<n>' expandMacros.

			logger recordings with:
				#( '[INFO] Obtaining configuration...' '[INFO] Name: Jones' '[INFO] Title: Mr.'
				   '[INFO] Obtaining configuration... [DONE]' )
				do: [ :recording :expectedOutput | 
				self assert: ( recording printString endsWith: expectedOutput ) ]
			]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartGreeterApplicationLoadingSeveralSettingsFile [

	| jsonFileName |

	jsonFileName := '<1s>-settings.json' expandMacrosWith: testSelector asString.
	self
		createFileNamed: jsonFileName
		containing: ( NeoJSONWriter toStringPretty: ( Dictionary new
					    at: 'name' put: 'Jones';
					    yourself ) )
		during: [ 
			| iniFileName |

			iniFileName := '<1s>-settings.ini' expandMacrosWith: testSelector asString.
			self createFileNamed: iniFileName containing: 'title=Mr.' during: [ 
				| output |

				output := self
					          handle: { 
							          'launchpad'.
							          'start'.
							          ( '--settings-file=<1s>' expandMacrosWith: jsonFileName ).
							          ( '--settings-file=<1s>' expandMacrosWith: iniFileName ).
							          LaunchpadGreeterApplication commandName }
					          onExitDo: [ :exit | self assert: exit isSuccess ].

				self assert: output equals: 'Hi Mr. Jones!<n>' expandMacros.

				logger recordings with:
					#( '[INFO] Obtaining configuration...' '[INFO] Name: Jones' '[INFO] Title: Mr.'
					   '[INFO] Obtaining configuration... [DONE]' )
					do: [ :recording :expectedOutput | 
					self assert: ( recording printString endsWith: expectedOutput ) ]
				]
			]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartGreeterApplicationMissingMandatoryParameter [

	| output |

	output := self
		          handle: { 
				          'launchpad'.
				          'start'.
				          LaunchpadGreeterApplication commandName.
				          '--title=Mr.' }
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self assert: output isEmpty.

	logger recordings
		with:
			#( '[INFO] Obtaining configuration...' 
				'[ERROR] "Name" parameter not provided. You must provide one.'
			   '[ERROR] Obtaining configuration... [FAILED]' )
		do: [ :recording :expectedOutput | 
		self assert: ( recording printString endsWith: expectedOutput ) ]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartGreeterApplicationMissingMandatoryParameterInDebugMode [

	self
		should: [ 
			self handle: { 
					'launchpad'.
					'start'.
					'--debug-mode'.
					LaunchpadGreeterApplication commandName.
					'--title=Mr.' }
			]
		raise: RequiredConfigurationNotFound
		withMessageText: '"Name" parameter not present.'.

	logger recordings
		with:
			#( '[INFO] Obtaining configuration...' '[ERROR] "Name" parameter not provided. You must provide one.'
			   '[ERROR] Exit application' '[INFO] Obtaining configuration... [DONE]'
			   '[ERROR] "Name" parameter not provided. You must provide one.' )
		do: [ :recording :expectedOutput | 
		self assert: ( recording printString endsWith: expectedOutput ) ]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartGreeterApplicationWithAllParameters [

	| output |

	output := self
		          handle: { 
				          'launchpad'.
				          'start'.
				          LaunchpadGreeterApplication commandName.
				          '--title=Mr.' . '--name=Jones'  }
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self assert: output equals: 'Hi Mr. Jones!<n>' expandMacros.

	logger recordings
		with:
			#( '[INFO] Obtaining configuration...' 
			   '[INFO] Name: Jones' 
				'[INFO] Title: Mr.' 
				'[INFO] Obtaining configuration... [DONE]' )
		do: [ :recording :expectedOutput | 
		self assert: ( recording printString endsWith: expectedOutput ) ]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartGreeterApplicationWithMixedConfiguration [

	| fileName |

	fileName := '<1s>-settings.json' expandMacrosWith: testSelector asString.
	self
		createFileNamed: fileName
		containing: ( NeoJSONWriter toStringPretty: ( Dictionary new
					    at: 'name' put: 'Jones';
					    yourself ) )
		during: [ 
			self set: 'TITLE' to: 'Mr.' during: [ 
				| output |

				output := self
					          handle: { 
							          'launchpad'.
							          'start'.
							          ( '--settings-file=<1s>' expandMacrosWith: fileName ).
							          LaunchpadGreeterApplication commandName }
					          onExitDo: [ :exit | self assert: exit isSuccess ].

				self assert: output equals: 'Hi Mr. Jones!<n>' expandMacros.

				logger recordings with:
					#( '[INFO] Obtaining configuration...' '[INFO] Name: Jones' '[INFO] Title: Mr.'
					   '[INFO] Obtaining configuration... [DONE]' )
					do: [ :recording :expectedOutput | 
					self assert: ( recording printString endsWith: expectedOutput ) ]
				]
			]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartSubcommandHelp [

	| output |

	output := self handle: #( 'launchpad' 'start' '--help' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedStartHelpOutput;
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling start subcommand' }
LaunchpadMainCommandTest >> testHandlingStartSubcommandShortHelp [

	| output |

	output := self handle: #( 'launchpad' 'start' '-h' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedStartHelpOutput;
		assert: logger recordings isEmpty
]

{ #category : #'tests - handling main command' }
LaunchpadMainCommandTest >> testHandlingVersionOption [

	| output |

	output := self handle: #( 'launchpad' '--version' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: 'Launchpad v4.0.0<n>' expandMacros;
		assert: logger recordings isEmpty
]

{ #category : #tests }
LaunchpadMainCommandTest >> testPrintHelpOn [

	| help |

	help := String streamContents: [ :stream | command printHelpOn: stream ].

	self assert: help equals: 'NAME
		launchpad - A minimal application launcher
SYNOPSYS
		launchpad [--version] [--help|-h] <command>
DESCRIPTION
		Launchpad provides a command-line handler used to start, list, and explain the available applications contained in the image.
OPTIONS
		--version
			Print the version and exit.
		-h, --help
			Print this help message and exit.
COMMANDS
		start
			Start the selected application
		list
			List available applications
		explain
			Give details about the selected application
'
]

{ #category : #private }
LaunchpadMainCommandTest >> use: version asVersionDuring: aBlock [

	| currentVersion |

	currentVersion := LaunchpadMainCommand version.
	LaunchpadMainCommand version: version.
	aBlock ensure: [ LaunchpadMainCommand version: currentVersion ]
]
