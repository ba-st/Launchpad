"
An OptionalArgumentTest is a test class for testing the behavior of OptionalArgument
"
Class {
	#name : #OptionalArgumentTest,
	#superclass : #TestCase,
	#category : #'Launchpad-Tests'
}

{ #category : #test }
OptionalArgumentTest >> testDefault [

	self assert: ( OptionalArgument named: 'port' defaultingTo: 9000 ) default equals: 9000
]
