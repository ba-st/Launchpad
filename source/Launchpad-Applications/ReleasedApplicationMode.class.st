Class {
	#name : #ReleasedApplicationMode,
	#superclass : #LaunchpadApplicationRunningMode,
	#category : #'Launchpad-Applications'
}

{ #category : #utilities }
ReleasedApplicationMode >> exitFailure [

	Exit signalFailure
]

{ #category : #utilities }
ReleasedApplicationMode >> exitSuccess [

	Exit signalSuccess
]

{ #category : #testing }
ReleasedApplicationMode >> isDebugMode [

	^ false
]

{ #category : #utilities }
ReleasedApplicationMode >> value: aBlock onErrorDo: errorHandler [

	^ aBlock on: Error do: errorHandler
]
