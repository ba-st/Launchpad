Class {
	#name : #CurrentLogger,
	#superclass : #DynamicVariable,
	#category : #Launchpad
}

{ #category : #accessing }
CurrentLogger >> default [

	^ LeveledLogger default
]
