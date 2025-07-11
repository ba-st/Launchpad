Extension { #name : 'ApplicationConfiguration' }

{ #category : '*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationAsCLIInspectorTab: builder [

  <inspectorPresentationOrder: 5 title: 'CLI'>
  ^ builder newText
      text: ( String streamContents: [ :stream | self asCommandLineOn: stream ] );
      beWrapWord;
      yourself
]

{ #category : '*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationAsEnvironmentInspectorTab: builder [

  <inspectorPresentationOrder: 6 title: 'Environment'>
  ^ builder newText
      text: ( String streamContents: [ :stream | self asEnvironmentOn: stream ] );
      beWrapWord;
      yourself
]

{ #category : '*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationAsINIInspectorTab: builder [

  <inspectorPresentationOrder: 4 title: 'INI'>
  ^ builder newText
      text: ( String streamContents: [ :stream | self asIniFileOn: stream ] );
      beWrapWord;
      yourself
]

{ #category : '*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationAsJSONInspectorTab: builder [

  <inspectorPresentationOrder: 3 title: 'JSON'>
  ^ builder newText
      text: self asJson;
      beWrapWord;
      yourself
]

{ #category : '*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationParametersInspectorTab: builder [

  <inspectorPresentationOrder: 2 title: 'Parameters'>
  ^ builder newTable
      items: parameters;
      addColumn: ( SpStringTableColumn new
            title: 'Name';
            sortFunction: #name ascending;
            evaluated: #name;
            yourself );
      addColumn: ( SpStringTableColumn new
            title: 'Summary';
            sortFunction: #summary ascending;
            evaluated: #summary;
            yourself );
      addColumn: ( SpStringTableColumn new
            title: 'CLI';
            sortFunction: #commandLineArgumentName ascending;
            evaluated: #commandLineArgumentName;
            yourself );
      addColumn: ( SpStringTableColumn new
            title: 'Env';
            sortFunction: #environmentVariableName ascending;
            evaluated: #environmentVariableName;
            yourself );
      yourself
]

{ #category : '*Launchpad-Development-Tools' }
ApplicationConfiguration >> configurationValuesInspectorTab: builder [

  <inspectorPresentationOrder: 1 title: 'Values'>
  ^ builder newTable
      items: parameters;
      addColumn: ( SpStringTableColumn new
            title: 'Name';
            sortFunction: #name ascending;
            evaluated: #name;
            yourself );
      addColumn: ( SpStringTableColumn new
            title: 'Value';
            evaluated: [ :parameter | self valueFor: parameter ];
            yourself );
      yourself
]
