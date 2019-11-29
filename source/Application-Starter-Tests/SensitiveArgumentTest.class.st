"
A SensitiveArgumentTest is a test class for testing the behavior of SensitiveArgument
"
Class {
	#name : #SensitiveArgumentTest,
	#superclass : #TestCase,
	#category : #'Application-Starter-Tests'
}

{ #category : #tests }
SensitiveArgumentTest >> testName [

	self
		assert: ( SensitiveArgument over: ( MandatoryArgument named: 'private' ) ) name
		equals: 'private'
]
