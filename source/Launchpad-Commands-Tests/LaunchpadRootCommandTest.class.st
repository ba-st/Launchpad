"
A LaunchpadMainCommandTest is a test class for testing the behavior of LaunchpadMainCommand
"
Class {
	#name : #LaunchpadRootCommandTest,
	#superclass : #LaunchpadTest,
	#instVars : [
		'command'
	],
	#category : #'Launchpad-Commands-Tests'
}

{ #category : #private }
LaunchpadRootCommandTest >> assertCommandCanHandleNextArgumentIn: context [

	self assert: ( command canHandle: ( context nextCommandLineArgumentIfNone: [ self fail ] ) )
]

{ #category : #private }
LaunchpadRootCommandTest >> contextWithArguments: arguments writingTo: outputStream [

	^ LaunchpadCommandLineProcessingContext handling: ( CommandLineArguments withArguments: arguments )
		  writingTo: outputStream
]

{ #category : #private }
LaunchpadRootCommandTest >> createFileNamed: fileName containing: fileContents during: aBlock [

	| fileReference |

	fileReference := fileName asFileReference.
	fileReference ensureCreateFile.
	[ 
	fileReference writeStreamDo: [ :stream | stream nextPutAll: fileContents ].
	aBlock value
	] ensure: [ fileReference ensureDelete ]
]

{ #category : #private }
LaunchpadRootCommandTest >> expectedExplainBrokenHelpOutput [

	^ 'NAME<n>		broken [v0.0.1] - A broken application<n>SYNOPSYS<n>		broken [--raise-error]<n>COMMANDS<n>		--raise-error<n>			Raises an unexpected error. Useful to test stack trace generation.<n>'
		  expandMacros
]

{ #category : #private }
LaunchpadRootCommandTest >> expectedExplainGreeterHelpOutput [

	^ 'NAME<n>		greeter [v1.0.0] - A greetings application<n>SYNOPSYS<n>		greeter --name=%<name> [--title=%<title>]<n>PARAMETERS<n>		--name=%<name><n>			The name of the user to greet.<n>		--title=%<title><n>			The title of the user to greet. Defaults to nothing.<n>ENVIRONMENT<n>		NAME<n>			The name of the user to greet.<n>		TITLE<n>			The title of the user to greet. Defaults to nothing.<n>'
		  expandMacros
]

{ #category : #private }
LaunchpadRootCommandTest >> expectedExplainHelpOutput [

	^ 'NAME<n>		launchpad-explain - Give details about the selected application<n>SYNOPSYS<n>		launchpad explain [--help|-h] %<app><n>DESCRIPTION<n>		Give details about the application selected via %<app> including its configuration options.<n>OPTIONS<n>		-h, --help<n>			Print this help message and exit.<n>'
		  expandMacros			
]

{ #category : #private }
LaunchpadRootCommandTest >> expectedHelpOutput [

	^ 'NAME<n>		launchpad - A minimal application launcher<n>SYNOPSYS<n>		launchpad [--version] [--help|-h] %<command><n>DESCRIPTION<n>		A command-line interface to start, list, and explain the applications available within the image.<n>OPTIONS<n>		--version<n>			Print the version and exit.<n>		-h, --help<n>			Print this help message and exit.<n>COMMANDS<n>		start<n>			Start the selected application<n>		list<n>			List available applications<n>		explain<n>			Give details about the selected application<n>'
		  expandMacros
]

{ #category : #private }
LaunchpadRootCommandTest >> expectedListHelpOutput [

	^ 'NAME<n>		launchpad-list - List available applications<n>SYNOPSYS<n>		launchpad list [--verbose|-v] [--help|-h]<n>DESCRIPTION<n>		Lists the available applications contained in the image.<n>OPTIONS<n>		-v, --verbose<n>			Produce more verbose output.<n>		-h, --help<n>			Print this help message and exit.<n>'
		  expandMacros
]

{ #category : #private }
LaunchpadRootCommandTest >> expectedStartHelpOutput [

	^ 'NAME<n>		launchpad-start - Start the selected application<n>SYNOPSYS<n>		launchpad start [--help|-h] [--debug-mode] [--settings-file=%<filename>] [--enable-structured-logging] [--enable-tcp-command-server=%<listeningPort>] %<app> [%<parameters>]<n>DESCRIPTION<n>		Start the application selected via %<app>.<n><n><t><t>Application configuration is made by the command-line via %<parameters>, using environment variables or settings files.<n><n><t><t>Execute launchpad explain %<app> to get a list of valid configuration parameters.<n>OPTIONS<n>		-h, --help<n>			Print this help message and exit.<n>		--debug-mode<n>			Enable the debugging mode. The image will not quit on unexpected errors. This configuration can be used in the application to improve the debugging experience.<n>		--settings-file=%<filename><n>			Provide application configuration via a settings file. This option can occur several times to configure more than one settings file. Supported file settings formats are INI and JSON.<n>		--enable-structured-logging<n>			Enable structured logging. When enabled the log will be emitted in JSON format.<n>		--enable-tcp-command-server=%<listeningPort><n>			Enable a TCP command server. This can be used to send commands controlling the application using a TCP port.<n>'
		  expandMacros			
]

{ #category : #private }
LaunchpadRootCommandTest >> expectedVerboseListOutput [

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
LaunchpadRootCommandTest >> handle: arguments [

	^ String streamContents: [ :stream | 
		  | context |

		  context := self contextWithArguments: arguments writingTo: stream.

		  self assertCommandCanHandleNextArgumentIn: context.

		  self runMemoryLoggerDuring: [ self use: 'v4.0.0' asVersionDuring: [ command evaluateWithin: context ] ]
		  ]
]

{ #category : #private }
LaunchpadRootCommandTest >> handle: arguments onExitDo: aBlock [

	^ String streamContents: [ :stream | 
		  | context |

		  context := self contextWithArguments: arguments writingTo: stream.

		  self assertCommandCanHandleNextArgumentIn: context.

		  self should: [ 
			  self runMemoryLoggerDuring: [ self use: 'v4.0.0' asVersionDuring: [ command evaluateWithin: context ] ] ]
			  raise: Exit
			  withExceptionDo: aBlock
		  ]
]

{ #category : #private }
LaunchpadRootCommandTest >> set: environmentVariableName to: value during: aBlock [

	LanguagePlatform current os environment at: environmentVariableName put: value.
	aBlock ensure: [ LanguagePlatform current os environment removeKey: environmentVariableName ]
]

{ #category : #running }
LaunchpadRootCommandTest >> setUp [

	super setUp.
	command := LaunchpadRootCommand new
]

{ #category : #tests }
LaunchpadRootCommandTest >> testAccessing [

	| options subcommands |

	self
		assert: command name equals: 'launchpad';
		assert: command summary equals: 'A minimal application launcher';
		assert: command description
		equals:
			'A command-line interface to start, list, and explain the applications available within the image.'.

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
LaunchpadRootCommandTest >> testHandlingExplainBrokenApplication [

	| output |

	output := self
		          handle: { 'launchpad'. 'explain'. LaunchpadBrokenApplication commandName }
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedExplainBrokenHelpOutput;
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling explain subcommand' }
LaunchpadRootCommandTest >> testHandlingExplainGreeterApplication [

	| output |

	output := self
		          handle: { 'launchpad'. 'explain'. LaunchpadGreeterApplication commandName }
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedExplainGreeterHelpOutput;
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling explain subcommand' }
LaunchpadRootCommandTest >> testHandlingExplainSubcommandHelp [

	| output |

	output := self handle: #( 'launchpad' 'explain' '--help' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedExplainHelpOutput;
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling explain subcommand' }
LaunchpadRootCommandTest >> testHandlingExplainSubcommandShortHelp [

	| output |

	output := self handle: #( 'launchpad' 'explain' '-h' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedExplainHelpOutput;
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling main command' }
LaunchpadRootCommandTest >> testHandlingHelpOption [

	| output |

	output := self handle: #( 'launchpad' '--help' ) onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedHelpOutput;
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling explain subcommand' }
LaunchpadRootCommandTest >> testHandlingInvalidExplainSubcommandApp [

	| output |

	output := self handle: #( 'launchpad' 'explain' 'wrong' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assertLogRecordsMatch: #( '[ERROR] explain unknown application: wrong' )
]

{ #category : #'tests - handling explain subcommand' }
LaunchpadRootCommandTest >> testHandlingInvalidExplainSubcommandOption [

	| output |

	output := self handle: #( 'launchpad' 'explain' '--wrong' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assertLogRecordsMatch: #( '[ERROR] explain unknown option: --wrong' )
]

{ #category : #'tests - handling list subcommand' }
LaunchpadRootCommandTest >> testHandlingInvalidListSubcommandOption [

	| output |

	output := self handle: #( 'launchpad' 'list' '--wrong' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assertLogRecordsMatch: #( '[ERROR] list unknown option: --wrong' )
]

{ #category : #'tests - handling main command' }
LaunchpadRootCommandTest >> testHandlingInvalidOption [

	| output |

	output := self handle: #( 'launchpad' '--wrong' ) onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assertLogRecordsMatch: #( '[ERROR] launchpad unknown option: --wrong' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingInvalidStartSubcommandApp [

	| output |

	output := self
		          handle: #( 'launchpad' 'start' 'wrong' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assertLogRecordsMatch: #( '[ERROR] start unknown application: wrong' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingInvalidStartSubcommandOption [

	| output |

	output := self
		          handle: #( 'launchpad' 'start' '--wrong' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assertLogRecordsMatch: #( '[ERROR] start unknown option: --wrong' )
]

{ #category : #tests }
LaunchpadRootCommandTest >> testHandlingInvalidSubcommand [

	| output |

	output := self handle: #( 'launchpad' 'wrong' ) onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assertLogRecordsMatch: #( '[ERROR] launchpad unknown command: wrong' )
]

{ #category : #'tests - handling list subcommand' }
LaunchpadRootCommandTest >> testHandlingListSubcommand [

	| output |

	output := self handle: #( 'launchpad' 'list' ) onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: ( String streamContents: [ :stream | 
					  LaunchpadApplication availableApplications
						  do: [ :application | stream nextPutAll: application commandName ]
						  separatedBy: [ stream space ].
					  stream nextPutAll: '<n>' expandMacros
					  ] );
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling list subcommand' }
LaunchpadRootCommandTest >> testHandlingListSubcommandHelp [

	| output |

	output := self
		          handle: #( 'launchpad' 'explain' '--help' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedExplainHelpOutput;
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling list subcommand' }
LaunchpadRootCommandTest >> testHandlingListSubcommandShortHelp [

	| output |

	output := self
		          handle: #( 'launchpad' 'list' '-h' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedListHelpOutput;
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling list subcommand' }
LaunchpadRootCommandTest >> testHandlingListSubcommandShortVerboseMode [

	| output |

	output := self
		          handle: #( 'launchpad' 'list' '-v' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedVerboseListOutput;
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling list subcommand' }
LaunchpadRootCommandTest >> testHandlingListSubcommandVerboseMode [

	| output |

	output := self
		          handle: #( 'launchpad' 'list' '--verbose' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedVerboseListOutput;
		assertThereAreNoLogRecords
]

{ #category : #tests }
LaunchpadRootCommandTest >> testHandlingMissingSubcommandAndOption [

	| output |

	output := self handle: #( 'launchpad' ) onExitDo: [ :exit | self deny: exit isSuccess ].

	self
		assert: output isEmpty;
		assertLogRecordsMatch: #( '[ERROR] Missing command or option.' )
]

{ #category : #'tests - handling main command' }
LaunchpadRootCommandTest >> testHandlingShortHelpOption [

	| output |

	output := self handle: #( 'launchpad' '-h' ) onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedHelpOutput;
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartBrokenApplication [

	| output |

	output := self
		          handle: #( 'launchpad' 'start' 'broken' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self assert: output isEmpty.

	self assertLogRecordsMatch:
		#( '[INFO] broken [v0.0.1] - A broken application'
			'[INFO] Obtaining configuration...'
		   '[INFO] Obtaining configuration... [DONE]' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartBrokenApplicationInDebugMode [

	| output |

	output := self handle: #( 'launchpad' 'start' '--debug-mode' 'broken' ).

	self assert: output isEmpty.

	self assertLogRecordsMatch:
		#( '[INFO] broken [v0.0.1] - A broken application'
			'[INFO] Obtaining configuration...'
		   '[INFO] Obtaining configuration... [DONE]'
			'[ERROR] Exit application' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartBrokenApplicationRaisingUnexpectedError [

	| output |

	output := self
		          handle: #( 'launchpad' 'start' 'broken' '--raise-error' )
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self assert: output isEmpty.

	self assertLogRecordsMatch:
		#( '[INFO] broken [v0.0.1] - A broken application'
			'[INFO] Obtaining configuration...'
		   '[INFO] Obtaining configuration... [DONE]'
			'[ERROR] Unexpected startup error: "Doh!"' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartBrokenApplicationRaisingUnexpectedErrorInDebugMode [

	self
		should: [ self handle: #( 'launchpad' 'start' '--debug-mode' 'broken' '--raise-error' ) ]
		raise: Error
		withMessageText: 'Doh!'.


	self assertLogRecordsMatch:
		#( '[INFO] broken [v0.0.1] - A broken application'
			'[INFO] Obtaining configuration...'
		   '[INFO] Obtaining configuration... [DONE]' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartGreeterApplication [

	| output |

	output := self
		          handle: { 
				          'launchpad'.
				          'start'.
				          LaunchpadGreeterApplication commandName.
				          '--name=John' }
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self assert: output equals: 'Hi John!<n>' expandMacros.

	self assertLogRecordsMatch: #(
		'[INFO] greeter [v1.0.0] - A greetings application'
		'[INFO] Obtaining configuration...'
		'[WARNING] "Title" parameter not provided. Using default.'
	   '[INFO] Name: John'
		'[INFO] Title: '
		'[INFO] Obtaining configuration... [DONE]' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartGreeterApplicationEnablingStructuredLogging [

	| output |

	output := self handle: { 
			          'launchpad'.
			          'start'.
			          '--debug-mode'.
			          '--enable-structured-logging'.
			          LaunchpadGreeterApplication commandName.
			          '--name=John' }.

	self assert: output equals: 'Hi John!<n>' expandMacros.

	self assertLogRecordsMatch: #( 
		'[INFO] greeter [v1.0.0] - A greetings application'
		'[INFO] Obtaining configuration...'
		'[WARNING] "Title" parameter not provided. Using default.'
		'[INFO] Name: John'
		'[INFO] Title: '
		'[INFO] Obtaining configuration... [DONE]'
		'[INFO] Exit application' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartGreeterApplicationEnablingTCPCommandServer [

	| output |

	output := self handle: { 
			          'launchpad'.
			          'start'.
			          '--debug-mode'.
			          '--enable-tcp-command-server=0'.
			          LaunchpadGreeterApplication commandName.
			          '--name=John' }.

	self assert: output equals: 'Hi John!<n>' expandMacros.

	self assertLogRecordsMatch: #( 
		'[INFO] Receiving commands over TCP/0'
		'[INFO] greeter [v1.0.0] - A greetings application'
		'[INFO] Obtaining configuration...'
		'[WARNING] "Title" parameter not provided. Using default.'
		'[INFO] Name: John'
		'[INFO] Title: '
		'[INFO] Obtaining configuration... [DONE]'
		'[INFO] Exit application' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartGreeterApplicationInDebugMode [

	| output |

	output := self handle: { 
			          'launchpad'.
			          'start'.
			          '--debug-mode'.
			          LaunchpadGreeterApplication commandName.
			          '--name=John' }.

	self assert: output equals: 'Hi John!<n>' expandMacros.

	self assertLogRecordsMatch: #( 
		'[INFO] greeter [v1.0.0] - A greetings application'
		'[INFO] Obtaining configuration...'
		'[WARNING] "Title" parameter not provided. Using default.'
		'[INFO] Name: John'
		'[INFO] Title: '
		'[INFO] Obtaining configuration... [DONE]'
		'[INFO] Exit application' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartGreeterApplicationLoadingSettingsFile [

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

			self assertLogRecordsMatch: #( 
				'[INFO] greeter [v1.0.0] - A greetings application'
				'[INFO] Obtaining configuration...'
				'[INFO] Name: Jones' '[INFO] Title: Mr.'
				'[INFO] Obtaining configuration... [DONE]' )
			]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartGreeterApplicationLoadingSeveralSettingsFile [

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
				self assertLogRecordsMatch: #(
					'[INFO] greeter [v1.0.0] - A greetings application'
					'[INFO] Obtaining configuration...'
					'[INFO] Name: Jones' '[INFO] Title: Mr.'
					'[INFO] Obtaining configuration... [DONE]' )
				]
			]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartGreeterApplicationMissingMandatoryParameter [

	| output |

	output := self
		          handle: { 
				          'launchpad'.
				          'start'.
				          LaunchpadGreeterApplication commandName.
				          '--title=Mr.' }
		          onExitDo: [ :exit | self deny: exit isSuccess ].

	self assert: output isEmpty.

	self assertLogRecordsMatch: #(
		'[INFO] greeter [v1.0.0] - A greetings application'
		'[INFO] Obtaining configuration...'
		'[ERROR] "Name" parameter not provided. You must provide one.'
		'[ERROR] Obtaining configuration... [FAILED]' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartGreeterApplicationMissingMandatoryParameterInDebugMode [

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

	self assertLogRecordsMatch: #( 
		'[INFO] greeter [v1.0.0] - A greetings application'
		'[INFO] Obtaining configuration...'
		'[ERROR] "Name" parameter not provided. You must provide one.'
		'[ERROR] Exit application'
		'[INFO] Obtaining configuration... [DONE]'
		'[ERROR] "Name" parameter not provided. You must provide one.' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartGreeterApplicationWithAllParameters [

	| output |

	output := self
		          handle: { 
				          'launchpad'.
				          'start'.
				          LaunchpadGreeterApplication commandName.
				          '--title=Mr.'.
				          '--name=Jones' }
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self assert: output equals: 'Hi Mr. Jones!<n>' expandMacros.

	self assertLogRecordsMatch: #(
		'[INFO] greeter [v1.0.0] - A greetings application'
		'[INFO] Obtaining configuration...'
		'[INFO] Name: Jones'
		'[INFO] Title: Mr.'
		'[INFO] Obtaining configuration... [DONE]' )
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartGreeterApplicationWithMixedConfiguration [

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

				self assertLogRecordsMatch: #(
					'[INFO] greeter [v1.0.0] - A greetings application'
					'[INFO] Obtaining configuration...'
					'[INFO] Name: Jones'
					'[INFO] Title: Mr.'
					'[INFO] Obtaining configuration... [DONE]' )
				]
			]
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartSubcommandHelp [

	| output |

	output := self
		          handle: #( 'launchpad' 'start' '--help' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedStartHelpOutput;
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStartSubcommandShortHelp [

	| output |

	output := self
		          handle: #( 'launchpad' 'start' '-h' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: self expectedStartHelpOutput;
		assertThereAreNoLogRecords
]

{ #category : #'tests - handling start subcommand' }
LaunchpadRootCommandTest >> testHandlingStopBrokenApplicationWhileRunning [

	| semaphore |

	semaphore := Semaphore new.

	[ 
	[ self handle: #( 'launchpad' 'start' '--debug-mode' 'broken' '--raise-error' ) ]
		on: Error
		do: [ :error | 
			semaphore wait.
			error return
			]
	] forkAt: Processor userInterruptPriority named: 'Launching broken application'.

	LaunchpadApplication currentlyRunning stop.
	semaphore signal.

	self assertLogRecordsMatch:
		#( '[INFO] broken [v0.0.1] - A broken application'
			'[INFO] Obtaining configuration...'
		   '[INFO] Obtaining configuration... [DONE]' )
]

{ #category : #'tests - handling main command' }
LaunchpadRootCommandTest >> testHandlingVersionOption [

	| output |

	output := self
		          handle: #( 'launchpad' '--version' )
		          onExitDo: [ :exit | self assert: exit isSuccess ].

	self
		assert: output equals: 'Launchpad v4.0.0<n>' expandMacros;
		assertThereAreNoLogRecords
]

{ #category : #tests }
LaunchpadRootCommandTest >> testPrintHelpOn [

	| help |

	help := String streamContents: [ :stream | command printHelpOn: stream ].

	self assert: help equals: 'NAME
		launchpad - A minimal application launcher
SYNOPSYS
		launchpad [--version] [--help|-h] <command>
DESCRIPTION
		A command-line interface to start, list, and explain the applications available within the image.
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
LaunchpadRootCommandTest >> use: version asVersionDuring: aBlock [

	| currentVersion |

	currentVersion := LaunchpadRootCommand version.
	LaunchpadRootCommand version: version.
	aBlock ensure: [ LaunchpadRootCommand version: currentVersion ]
]
