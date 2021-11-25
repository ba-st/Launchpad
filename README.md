# Launchpad

![Logo](assets/logo.svg)

A command-line interface to start, list, and explain the applications available
within the image.

[![Unit Tests](https://github.com/ba-st/Launchpad/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/ba-st/Launchpad/actions/workflows/unit-tests.yml)
[![Coverage Status](https://codecov.io/github/ba-st/Launchpad/coverage.svg?branch=release-candidate)](https://codecov.io/gh/ba-st/Launchpad/branch/release-candidate)
[![Baseline Groups](https://github.com/ba-st/Launchpad/actions/workflows/loading-groups.yml/badge.svg)](https://github.com/ba-st/Launchpad/actions/workflows/loading-groups.yml)
[![Markdown Lint](https://github.com/ba-st/Launchpad/actions/workflows/markdown-lint.yml/badge.svg)](https://github.com/ba-st/Launchpad/actions/workflows/markdown-lint.yml)

[![GitHub release](https://img.shields.io/github/release/ba-st/Launchpad.svg)](https://github.com/ba-st/Launchpad/releases/latest)
[![Pharo 8.0](https://img.shields.io/badge/Pharo-8.0-informational)](https://pharo.org)
[![Pharo 9.0](https://img.shields.io/badge/Pharo-9.0-informational)](https://pharo.org)

## Quick Start

### Load all in one

```Smalltalk
  Metacello new
      baseline:'Launchpad';
      repository: 'github://ba-st/Launchpad:release-candidate/source';
      load
```

## Quick links

- [**Explore the docs**](docs/README.md)
- [Report a defect](https://github.com/ba-st/Launchpad/issues/new?labels=Type%3A+Defect)
- [Request a feature](https://github.com/ba-st/Launchpad/issues/new?labels=Type%3A+Feature)

Launchpad provides abstractions to architect your application:

- Configuration parameters (mandatory, optional, and sensitive)
- Command-line arguments, environment variables, or settings file configuration providers.
- Logging infrastructure (based on `Beacon`)
- Inline help
- Textual and binary stack trace generation

## License

- The code is licensed under [MIT](LICENSE).
- The documentation is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/).

## Installation

To load the project in a Pharo image follow this [instructions](docs/how-to/how-to-load-in-pharo.md).

## Contributing

Check the [Contribution Guidelines](CONTRIBUTING.md)

---

> *Icons by [Icons8](https://icons8.com/icon/63775/launchpad)*
