Class {
	#name : #CurrentLogger,
	#superclass : #DynamicVariable,
	#category : #'Launchpad-MigrationFromV3'
}

{ #category : #testing }
CurrentLogger class >> isDeprecated [

	^ true
]

{ #category : #accessing }
CurrentLogger class >> value [

	self deprecated: 'Emit LaunchpadLogRecord instances instead'
]

{ #category : #accessing }
CurrentLogger >> default [

	^ LeveledLogger default
]
