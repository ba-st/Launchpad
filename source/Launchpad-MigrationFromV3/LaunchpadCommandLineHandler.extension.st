Extension { #name : #LaunchpadCommandLineHandler }

{ #category : #'*Launchpad-MigrationFromV3' }
LaunchpadCommandLineHandler >> basicActivate [

	self deprecated: 'This command line handler is not supposed to be subclassed anymore.
	The code in basicActivate must be in your own subclass of LaunchpadApplication in the 
	#basicStartWithin: method.'.

	self halt: 'See deprecation comment'
]

{ #category : #'*Launchpad-MigrationFromV3' }
LaunchpadCommandLineHandler >> configuration [

	self deprecated: 'This command line handler is not supposed to be subclassed anymore.
	The configuration can be obtained by sending #configuration to your own instance of LaunchpadApplication.
	Note that this method now returns a proper configuration object and not a plain dictionary anymore'.

	self halt: 'See deprecation comment'
]

{ #category : #'*Launchpad-MigrationFromV3' }
LaunchpadCommandLineHandler >> configurationDefinition [

	self deprecated: 'This command line handler is not supposed to be subclassed anymore.
	This methods is replaced by #configurationParameters as a class method in your subclass of LaunchpadApplication.
	Note that this method now must return instances of ConfigurationParameter subclasses'.

	self halt: 'See deprecation comment'
]

{ #category : #'*Launchpad-MigrationFromV3' }
LaunchpadCommandLineHandler class >> defaultLogFile [

	self deprecated: 'Setup an appropiate SignalLogger in the LaunchpadApplication.
	By default LaunchpadCommandLineHandler will log information to the stdout and
	errors to the stderr.'.

	self halt: 'See deprecation comment'
]

{ #category : #'*Launchpad-MigrationFromV3' }
LaunchpadCommandLineHandler class >> defaultLogsPath [

	self deprecated: 'Setup an appropiate SignalLogger in the LaunchpadApplication.
	By default LaunchpadCommandLineHandler will log information to the stdout and
	errors to the stderr.'.

	self halt: 'See deprecation comment'
]

{ #category : #'*Launchpad-MigrationFromV3' }
LaunchpadCommandLineHandler class >> dumpStackAndReport: aSignal [

	self deprecated: 'This is now handled in LaunchpadApplication>>#startWithin: . 
		If you need to manually dump a stack trace you can use the #dumpStackTraceFor: message.'.

	self halt: 'Now LaunchpadApplication sub-instances are responsible for dumping stack traces.'
]

{ #category : #'*Launchpad-MigrationFromV3' }
LaunchpadCommandLineHandler >> exitFailure: aMessage [

	self deprecated: 'This command-line handler is not supposed to be subclassed anymore.
	Instances of LaunchpadApplication have a "mode" instance variable, you can delegate
	the exit to the mode'.

	self halt: 'See deprecation comment'
]

{ #category : #'*Launchpad-MigrationFromV3' }
LaunchpadCommandLineHandler >> isDebugModeEnabled [

	self deprecated: 'This command-line handler is not supposed to be subclassed anymore.
	Instances of LaunchpadApplication have a "mode" instance variable. 
	Check LaunchpadApplicationRunningMode hierarchy.
	So, if you need to do something different when debugging the application, extend these classes.'.

	self halt: 'See deprecation comment'
]

{ #category : #'*Launchpad-MigrationFromV3' }
LaunchpadCommandLineHandler class >> logPrefix [

	self deprecated: 'Setup an appropiate SignalLogger in the LaunchpadApplication.
	By default LaunchpadCommandLineHandler will log information to the stdout and
	errors to the stderr.'.

	self halt: 'See deprecation comment'
]
