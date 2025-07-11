Extension { #name : 'LaunchpadApplication' }

{ #category : '*Launchpad-Development-Tools' }
LaunchpadApplication >> configurationParametersInspectorTab: builder [

  <inspectorPresentationOrder: 2 title: 'Parameters'>
  ^ builder newTable
      items: self class configurationParameters;
      addColumn: ( SpStringTableColumn new
            title: 'Name';
            evaluated: #name;
            yourself );
      addColumn: ( SpStringTableColumn new
            title: 'Summary';
            evaluated: #summary;
            yourself );
      addColumn: ( SpStringTableColumn new
            title: 'CLI';
            evaluated: #commandLineArgumentName;
            yourself );
      addColumn: ( SpStringTableColumn new
            title: 'Env';
            evaluated: #environmentVariableName;
            yourself );
      yourself
]

{ #category : '*Launchpad-Development-Tools' }
LaunchpadApplication >> configurationValuesInspectorTab: builder [

  <inspectorPresentationOrder: 3 title: 'Configuration'>
  ^ self configuration configurationValuesInspectorTab: builder
]

{ #category : '*Launchpad-Development-Tools' }
LaunchpadApplication >> configurationValuesInspectorTabContext: context [

	context active: configurationCache notNil
]

{ #category : '*Launchpad-Development-Tools' }
LaunchpadApplication >> documentationInspectorTab: builder [

  <inspectorPresentationOrder: 1 title: 'Docs'>
  ^ builder newText
      text: ( String streamContents: [ :stream | self class printHelpOn: stream ] );
      beWrapWord;
      yourself
]
