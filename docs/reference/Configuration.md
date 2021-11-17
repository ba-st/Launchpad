# Applications Configuration

Many applications require configuration parameters provided by some external
source. Launchpad provides abstractions for dealing with the definition of the
application parameters and their values.

## Configuration parameter types

Each application needs to specify which parameters are required to work.
This specification is made by instantiating some of the configuration parameter classes:

- **Mandatory**: A mandatory configuration parameter must have a value provided
  externally. This kind of parameter is created by instantiating `MandatoryConfigurationParameter`.
- **Optional**: An optional configuration parameter can be missing in the
  external configuration defaulting to some specific value. This kind of
  parameter is created by instantiating `OptionalConfigurationParameter`.
- **Sensitive**: Sensitive parameters can be mandatory or optional (they are
  created by decorating some of the other parameter types by sending the message
  `asSensitive`). Its purpose is to avoid outputting the value in any log to
  avoid leaking sensitive data.

Every parameter must have a name and a summary.

A parameter's value primordial type is a `String`. Optionally, a parameter can
use a converter to parse the value and transform it
into a proper object.

Configuration parameters can also be nested in sections to group the related ones.

## Configuration providers

When an application starts, its configuration needs to be
pulled from some external source. This data is retrieved using some configuration
provider.

The following providers are available:

- `ConfigurationFromCommandLineProvider` tries to read the configuration parameter
  values by parsing the command-line arguments.
- `ConfigurationFromEnvironmentProvider` tries to read the configuration parameter
  values from the OS environment.
- `ConfigurationFromSettingsFileProvider` tries to read the configuration parameter
  values by parsing the files specified using the `settings-file` option
  of the `start` subcommand. See the [reference](CLI.md).

Launchpad will evaluate the configuration providers in the following order:

`Command-line -> Environment -> Settings-file`

### Reading configuration from the command-line

When reading the configuration from the command-line, parameter names conversion
to arguments follows these rules:

- All parameters are of the form `--parameterName=parameterValue`
- `parameterName` is obtained by converting to lowercase the alphanumeric
  characters in the parameter name (that is a free-form string) and replacing
  non-alphanumeric characters with `-`.
- If one or more sections contain the parameter, each section is treated as the
  parameter name and joined using a `.`.

So for example:

```smalltalk
MandatoryConfigurationParameter
  named: 'Public URL'
  describedBy: 'Public URL of the service'
```

needs to be provided in the command-line as:

```bash
launchpad start app --public-url=https://api.example.com
```

```smalltalk
MandatoryConfigurationParameter
  named: 'Port'
  describedBy: 'Listening port'
  inside: #( 'Communications' 'HTTP' )
```

needs to be provided in the command-line as:

```bash
launchpad start app --communications.http.port=8081
```

### Reading configuration from the OS environment

When reading the configuration from the OS environment, parameter names conversion
to environment variables follows these rules:

- Convert parameter name to uppercase and replace non-alphanumeric characters
  by `_`.
- If one or more sections contain the parameter, each section is treated as the
  parameter name and joined using a `__`.

So for example:

```smalltalk
MandatoryConfigurationParameter
  named: 'Public URL'
  describedBy: 'Public URL of the service'
```

is converted into an environment variable named `PUBLIC_URL`.

```smalltalk
MandatoryConfigurationParameter
  named: 'Port'
  describedBy: 'Listening port'
  inside: #( 'Communications' 'HTTP' )
```

is converted into an environment variable named `COMMUNICATIONS__HTTP__PORT`.

### Reading configuration from setting files

Configuration parameters can also be provided by reading a settings file.
Supported formats are JSON and INI.

When using the JSON format, parameters in the same section are nested in the file
structure. Parameter and sections names are converter to JSON keys in lower
camel-case format.

For example:

```smalltalk
{
  MandatoryConfigurationParameter
    named: 'Port'
    describedBy: 'Listening port'
    inside: #( 'Communications' 'HTTP' ).
  MandatoryConfigurationParameter
    named: 'Transport Scheme'
    describedBy: 'Transport Scheme (HTTP, HTTPS)'
    inside: #( 'Communications' 'HTTP' ).
}
```

needs to be provided as:

```json
{
  "communications": {
    "http": {
      "port":8081,
      "transportScheme":"https"
    }
  }
}
```

When using the INI file format, sections cannot be arbitrarily nested.

Section names to INI sections conversion follows these rules:

- For each section name, replace non-alphanumeric characters with `-`.
- If several sections contain the parameter, join each one using a `.`.

Parameter names are converter to keys in lower camel-case format.

So, the previous example needs to be:

```ini
[Communications.HTTP]
port = 8081
transportScheme = https
```
