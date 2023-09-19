Extension { #name : #CommandLineHandler }

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler >> << aString [
	^ self stdout
		nextPutAll: aString;
		yourself
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler >> activateHelp [
	"Default help implementation, running #help if the only argument is --help "
	((self hasOption: 'help') and: [ self arguments size = 1 ])
		ifTrue: [
			self help.
			^ true ].
	^ false
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler >> activateHelpWithoutArguments [
	"Default help implementation, running #help if the there is no argument or a single one which is --help "
	((self hasOption: 'help') or: [ self arguments isEmpty ])
		ifTrue: [
			self help.
			^ true ].
	^ false
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler >> exitFailure [
	 ^ self exitFailure: 'Command line handler failed'
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler >> exitFailure: aMessage [
	self hasSessionChanged
		ifTrue: [ ^ self ].
	Exit signalFailure: aMessage
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler >> exitSuccess [
	self hasSessionChanged
		ifTrue: [ ^ self ].
	Exit signalSuccess
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler >> hasSessionChanged [
	"check whether the session has changed since the commandline handler as been created"

	^ session ~~ Smalltalk session
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler >> help [
	"This is a crude default help implementation."
	self printHelp.
	Smalltalk isInteractive
		ifFalse: [ self exitSuccess ]
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler >> initializeSession [

	session := Smalltalk session
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler >> printHelp [
	self stderr
		nextPutAll: self class comment; lf
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler >> quit [
	self exitSuccess
]

{ #category : #'*Launchpad-GS64-Compatibility' }
CommandLineHandler class >> requireDeploymentPassword [
	"Here so that we can distinguish user application services command line handlers from usual pharo command line handlers.
	The objective is to be able to filter command line accessible by the user.
	Command line handlers that are not application services can be protected by a password in deployment."

	^ true
]
