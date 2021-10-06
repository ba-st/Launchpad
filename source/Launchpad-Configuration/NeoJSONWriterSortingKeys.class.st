Class {
	#name : #NeoJSONWriterSortingKeys,
	#superclass : #NeoJSONWriter,
	#category : #'Launchpad-Configuration'
}

{ #category : #writing }
NeoJSONWriterSortingKeys >> writeMap: keyValueCollection [

	self writeMapStreamingDo: [ :jsonMapWriter | 
		keyValueCollection keys sorted do: [ :key | 
			jsonMapWriter writeKey: key value: ( keyValueCollection at: key ) ]
		]
]
