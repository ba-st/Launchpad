Class {
	#name : #DebuggingApplicationMode,
	#superclass : #LaunchpadApplicationRunningMode,
	#category : #'Launchpad-Applications'
}

{ #category : #utilities }
DebuggingApplicationMode >> exitFailure [

	LogRecord emitError: 'Exit application'
]

{ #category : #utilities }
DebuggingApplicationMode >> exitSuccess [

	LogRecord emitInfo: 'Exit application'
]

{ #category : #testing }
DebuggingApplicationMode >> isDebugMode [

	^ true
]

{ #category : #utilities }
DebuggingApplicationMode >> value: aBlock onErrorDo: errorHandler [

	^ aBlock value
]
