Class {
	#name : #LeveledLogger,
	#superclass : #Object,
	#category : #'Launchpad-MigrationFromV3-Launchpad-MigrationFromV3'
}

{ #category : #accessing }
LeveledLogger class >> default [

	self deprecated: 'Emit LaunchpadLogRecord instances instead'
]

{ #category : #testing }
LeveledLogger class >> isDeprecated [

	^ true
]

{ #category : #logging }
LeveledLogger >> logAsError: aMessage [

	self deprecated: 'Use LaunchpadLogRecord>>#emitError:'
		transformWith: '`@receiver logAsError: `@message' -> 'LaunchpadLogRecord emitError: `@message'.
	LaunchpadLogRecord emitError: aMessage
]

{ #category : #logging }
LeveledLogger >> logAsError: aMessage during: aBlock [

	self deprecated: 'Use LaunchpadLogRecord>>#emitError:'
		transformWith:
		'`@receiver logAsError: `@message during: `@aBlock' -> 'LaunchpadLogRecord emitError: `@message'.
	LaunchpadLogRecord emitError: aMessage
]

{ #category : #logging }
LeveledLogger >> logAsInfo: aMessage [

	self deprecated: 'Use LaunchpadLogRecord>>#emitInfo:'
		transformWith: '`@receiver logAsInfo: `@message' -> 'LaunchpadLogRecord emitInfo: `@message'.
	LaunchpadLogRecord emitInfo: aMessage
]

{ #category : #logging }
LeveledLogger >> logAsInfo: aMessage during: aBlock [

	self deprecated: 'Use LaunchpadLogRecord>>#emitInfo:during:'
		transformWith: '`@receiver logAsInfo: `@message during: `@aBlock'
			-> 'LaunchpadLogRecord emitInfo: `@message during: `@aBlock'.
	LaunchpadLogRecord emitInfo: aMessage during: aBlock
]

{ #category : #logging }
LeveledLogger >> logAsInfo: anInformationMessage handlingErrorsDuring: aBlock [

	self deprecated: 'Use LaunchpadLogRecord>>#emitInfo:during:'
		transformWith: '`@receiver logAsInfo: `@message during: `@aBlock'
			-> 'LaunchpadLogRecord emitInfo: `@message during: `@aBlock'.
	LaunchpadLogRecord emitInfo: anInformationMessage during: aBlock
]

{ #category : #logging }
LeveledLogger >> logAsWarning: aMessage [

	self deprecated: 'Use LaunchpadLogRecord>>#emitWarning:'
		transformWith: '`@receiver logAsWarning: `@message' -> 'LaunchpadLogRecord emitWarning: `@message'.
	LaunchpadLogRecord emitWarning: aMessage
]

{ #category : #logging }
LeveledLogger >> logAsWarning: aMessage during: aBlock [

	self deprecated: 'Use LaunchpadLogRecord>>#emitemitWarning::'
		transformWith: '`@receiver logAsemitWarning:: `@message during: `@aBlock'
			-> 'LaunchpadLogRecord emitWarning: `@message'.
	LaunchpadLogRecord emitWarning: aMessage
]
