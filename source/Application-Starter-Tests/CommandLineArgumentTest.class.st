"
A MandatoryArgumentTest is a test class for testing the behavior of MandatoryArgument
"
Class {
	#name : #CommandLineArgumentTest,
	#superclass : #TestCase,
	#category : #'Application-Starter-Tests'
}

{ #category : #tests }
CommandLineArgumentTest >> handlerWith: anArgument [

	^ ApplicationStarterCommandLineHandler new
		commandLine: ( CommandLineArguments withArguments: ( Array with: anArgument ) )
]

{ #category : #tests }
CommandLineArgumentTest >> testMandatoryArgument [

	| argument |

	argument := MandatoryArgument named: 'one'.
	self assert: ( argument argumentFrom: ( self handlerWith: '--one=1' ) ) equals: '1'.
	self should: [ argument argumentFrom: ( self handlerWith: '--one' ) ] raise: Exit.
	self should: [ argument argumentFrom: ( self handlerWith: '--two' ) ] raise: Exit.
	self
		assert:
			( ( MandatoryArgument named: 'one' convertingWith: #asNumber )
				argumentFrom: ( self handlerWith: '--one=1' ) )
		equals: 1
]

{ #category : #tests }
CommandLineArgumentTest >> testOptionalArgument [

	| argument |

	argument := OptionalArgument named: 'one' defaultingTo: 'no one'.
	self assert: ( argument argumentFrom: ( self handlerWith: '--one=1' ) ) equals: '1'.
	self assert: ( argument argumentFrom: ( self handlerWith: '--one' ) ) equals: 'no one'.
	self assert: ( argument argumentFrom: ( self handlerWith: '--two' ) ) equals: 'no one'.
	self
		assert:
			( ( OptionalArgument named: 'number' defaultingTo: 42 convertingWith: #asNumber )
				argumentFrom: ( self handlerWith: '--number=1' ) )
		equals: 1.
	self
		assert:
			( ( OptionalArgument named: 'number' defaultingTo: 42 convertingWith: [ :arg | arg asNumber ] )
				argumentFrom: ( self handlerWith: '--number' ) )
		equals: 42.
	self
		assert:
			( ( OptionalArgument named: 'number' defaultingTo: 42 convertingWith: #asNumber )
				argumentFrom: ( self handlerWith: '--no-number' ) )
		equals: 42.
	self
		assert:
			( ( OptionalArgument named: 'number' defaultingTo: '42' convertingWith: #asNumber )
				argumentFrom: ( self handlerWith: '--no-number' ) )
		equals: 42
]
