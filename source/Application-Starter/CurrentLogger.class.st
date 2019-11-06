Class {
	#name : #CurrentLogger,
	#superclass : #DynamicVariable,
	#category : #'Application-Starter'
}

{ #category : #accessing }
CurrentLogger >> default [

	^ LeveledLogger default
]
