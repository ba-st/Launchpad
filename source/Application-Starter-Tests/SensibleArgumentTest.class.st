"
A SensibleArgumentTest is a test class for testing the behavior of SensibleArgument
"
Class {
	#name : #SensibleArgumentTest,
	#superclass : #TestCase,
	#category : #'Application-Starter-Tests'
}

{ #category : #tests }
SensibleArgumentTest >> testName [

	self
		assert: ( SensibleArgument over: ( MandatoryArgument named: 'private' ) ) name
		equals: 'private'
]
