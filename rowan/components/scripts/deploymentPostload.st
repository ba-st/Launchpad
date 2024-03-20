"Recompile LaunchpadApplication and CurrentlyRunningLaunchpadApplication with dbTransient option
 so that instances are not persistent because they store session-dependent information only"

| removeNonTransientVersionsOf |
removeNonTransientVersionsOf := [:class |
    | nonTransientVersions |
    nonTransientVersions := class classHistory reject: [:classVersion | classVersion instancesDbTransient].
    nonTransientVersions do: [:classVersion | class classHistory removeVersion: classVersion]].

LaunchpadApplication instancesDbTransient
    ifFalse: [
        Object subclass: 'LaunchpadApplication'
        	instVarNames: #( configurationCache configurationProvider mode commandServer )
        	classVars: #()
        	classInstVars: #()
        	poolDictionaries: #()
        	inDictionary: Launchpad
        	options: #( dbTransient ).
        (OrderedCollection new
            add: LaunchpadApplication;
            addAll: LaunchpadApplication allSubclasses;
            yourself)
                do: [:applicationClass | removeNonTransientVersionsOf value: applicationClass].
    ].

CurrentlyRunningLaunchpadApplication instancesDbTransient
    ifFalse: [
        Object subclass: 'CurrentlyRunningLaunchpadApplication'
        	instVarNames: #( binding )
        	classVars: #( uniqueInstance )
        	classInstVars: #()
        	poolDictionaries: #()
        	inDictionary: Launchpad
        	options: #( dbTransient ).
        removeNonTransientVersionsOf value: CurrentlyRunningLaunchpadApplication.
    ].

CurrentlyRunningLaunchpadApplication initializeUniqueInstance.
