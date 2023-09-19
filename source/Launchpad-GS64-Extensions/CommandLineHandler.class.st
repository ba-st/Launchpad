"
A CommandLineHandler is activated by the CommandLine. 

The responsible handler with the highest priority is selected and its instance-side method #activate is invoked.

By default the handlers are selected by their class name. In the following shell invocation the FooHandler is chosen:

	pharo Pharo.image FooHandler

A handler may provide a short name with the class-side #commandName method. If the FooHandler defined #commandName returning 'foo' it would be activated with the following shell invocation:
	
	pharo Pharo.image foo
	
For more sophisticated handler selection the CommandLineHandler should implement the #isResponsibleFor: class-side method. An instance of the current command line options is passed to this method which should then return a boolean.

Between all the responsible handlers the one with the highest #priority is chosen. To change the priority overwrite the class-side accessor.

"
Class {
	#name : #CommandLineHandler,
	#superclass : #Object,
	#instVars : [
		'commandLine',
		'session',
		'stdout',
		'stderr'
	],
	#category : #'Launchpad-GS64-Extensions'
}

{ #category : #'instance creation' }
CommandLineHandler class >> activateWith: aCommandLine [

	^ (self commandLine: (self prepareSubcommand: aCommandLine)) activate
]

{ #category : #accessing }
CommandLineHandler class >> allHandlers [
	^ self allSubclasses reject: [ :handler| handler isAbstract ]
]

{ #category : #'instance creation' }
CommandLineHandler class >> commandLine: aCommandLine [

	^ self new
		commandLine: aCommandLine;
		yourself
]

{ #category : #accessing }
CommandLineHandler class >> commandName [

	^ self subclassResponsibility
]

{ #category : #testing }
CommandLineHandler class >> isAbstract [
	^ self = CommandLineHandler
]

{ #category : #testing }
CommandLineHandler class >> isResponsibleFor: aCommandLineArguments [
	^ aCommandLineArguments includesSubCommand: self commandName
]

{ #category : #private }
CommandLineHandler class >> prepareSubcommand: commandLineArguments [

	"strip the subcommand name from the arguments"
	commandLineArguments withFirstArgument: [ :arg|
		arg = self commandName
			ifTrue: [ ^ commandLineArguments copySubcommand ]].

	"not a subcommand hence we keep the same args"
	^ commandLineArguments
]

{ #category : #accessing }
CommandLineHandler class >> priority [
	^ 0
]

{ #category : #private }
CommandLineHandler class >> selectHandlersFor: aCommandLine [

	^ self allHandlers select: [ :handlerClass|
		handlerClass isResponsibleFor: aCommandLine ]
]

{ #category : #activation }
CommandLineHandler >> activate [
	 self subclassResponsibility
]

{ #category : #'accessing - arguments' }
CommandLineHandler >> argumentAt: anInteger [
	^ self commandLine argumentAt: anInteger
]

{ #category : #'accessing - arguments' }
CommandLineHandler >> arguments [
	^ self commandLine arguments
]

{ #category : #accessing }
CommandLineHandler >> commandLine [
	^ commandLine
]

{ #category : #accessing }
CommandLineHandler >> commandLine: aCommandLine [
	commandLine := aCommandLine
]

{ #category : #accessing }
CommandLineHandler >> commandName [
	^ self class commandName
]

{ #category : #testing }
CommandLineHandler >> hasArguments [
	^ self commandLine hasArguments
]

{ #category : #'accessing - arguments' }
CommandLineHandler >> hasOption: aString [
	^ self commandLine hasOption: aString
]

{ #category : #initialization }
CommandLineHandler >> initialize [

	super initialize.
	self
		initializeSession;
		initializeStdout;
		initializeStderr
]

{ #category : #accessing }
CommandLineHandler >> name [
	^ self printString
]

{ #category : #'accessing - arguments' }
CommandLineHandler >> optionAt: aString [
	^ self commandLine optionAt: aString
]

{ #category : #'accessing - arguments' }
CommandLineHandler >> optionAt: aString ifAbsent: absentBlock [
	^ self commandLine
		optionAt: aString ifAbsent: absentBlock
]

{ #category : #'accessing - arguments' }
CommandLineHandler >> optionAt: aString ifPresent: absentBlock [
	^ self commandLine
		optionAt: aString ifPresent: absentBlock
]

{ #category : #'accessing - arguments' }
CommandLineHandler >> optionAt: aString ifPresent: presentBlock ifAbsent: absentBlock [
	^ self commandLine
		optionAt: aString ifPresent: presentBlock ifAbsent: absentBlock
]

{ #category : #accessing }
CommandLineHandler >> stderr [
	^ stderr
]

{ #category : #accessing }
CommandLineHandler >> stdout [
	^ stdout
]
