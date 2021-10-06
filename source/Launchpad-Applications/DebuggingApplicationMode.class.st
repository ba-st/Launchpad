Class {
	#name : #DebuggingApplicationMode,
	#superclass : #LaunchpadApplicationRunningMode,
	#category : #'Launchpad-Applications'
}

{ #category : #utilities }
DebuggingApplicationMode >> exitFailure [

	LaunchpadLogRecord emitError: 'Exit application'
]

{ #category : #utilities }
DebuggingApplicationMode >> exitSuccess [

	LaunchpadLogRecord emitInfo: 'Exit application successfuly'
]

{ #category : #utilities }
DebuggingApplicationMode >> handlingErrorsDuring: aBlock onErrorDo: errorHandler [

	^ aBlock value
]
