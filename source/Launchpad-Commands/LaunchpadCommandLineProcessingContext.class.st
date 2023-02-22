Class {
	#name : #LaunchpadCommandLineProcessingContext,
	#superclass : #Object,
	#instVars : [
		'commandLine',
		'output'
	],
	#category : #'Launchpad-Commands'
}

{ #category : #'instance creation' }
LaunchpadCommandLineProcessingContext class >> handling: aCommandLine writingTo: outputStream [

	^ self new initializeHandling: aCommandLine writingTo: outputStream
]

{ #category : #accessing }
LaunchpadCommandLineProcessingContext >> configurationProviderChainedWith: aConfigurationProvider [

	^ ConfigurationFromCommandLineProvider over: commandLine chainedWith: aConfigurationProvider
]

{ #category : #utilities }
LaunchpadCommandLineProcessingContext >> emitErrorAndExit: message [

	LogRecord emitError: message.
	self exitFailure
]

{ #category : #utilities }
LaunchpadCommandLineProcessingContext >> exitFailure [

	Exit signalFailure
]

{ #category : #utilities }
LaunchpadCommandLineProcessingContext >> exitSuccess [

	Exit signalSuccess
]

{ #category : #initialize }
LaunchpadCommandLineProcessingContext >> initializeHandling: aCommandLine writingTo: outputStream [

	commandLine := aCommandLine.
	output := ZnNewLineWriterStream on: outputStream
]

{ #category : #accessing }
LaunchpadCommandLineProcessingContext >> nextCommandLineArgumentIfNone: aFailBlock [

	commandLine withFirstArgument: [ :argument | 
		commandLine := commandLine copySubcommand.
		^ argument
		].
	^ aFailBlock value
]

{ #category : #enumerating }
LaunchpadCommandLineProcessingContext >> outputStreamDo: aBlock [

	aBlock value: output
]

{ #category : #configuration }
LaunchpadCommandLineProcessingContext >> usePlatformLineEnding [

	output forPlatformLineEnding
]
