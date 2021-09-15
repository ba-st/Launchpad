# Launchpad

![Logo](assets/logo.svg)

Command Line Handler meant to be used as superclass for an application entry point.

[![Unit Tests](https://github.com/ba-st/Launchpad/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/ba-st/Launchpad/actions/workflows/unit-tests.yml)
[![Coverage Status](https://codecov.io/github/ba-st/Launchpad/coverage.svg?branch=release-candidate)](https://codecov.io/gh/ba-st/Launchpad/branch/release-candidate)
[![Group Loading](https://github.com/ba-st/Launchpad/actions/workflows/loading-groups.yml/badge.svg)](https://github.com/ba-st/Launchpad/actions/workflows/loading-groups.yml)
[![Markdown Lint](https://github.com/ba-st/Launchpad/actions/workflows/markdown-lint.yml/badge.svg)](https://github.com/ba-st/Launchpad/actions/workflows/markdown-lint.yml)

[![GitHub release](https://img.shields.io/github/release/ba-st/Launchpad.svg)](https://github.com/ba-st/Launchpad/releases/latest)
[![Pharo 7.0](https://img.shields.io/badge/Pharo-7.0-informational)](https://pharo.org)
[![Pharo 8.0](https://img.shields.io/badge/Pharo-8.0-informational)](https://pharo.org)
[![Pharo 9.0](https://img.shields.io/badge/Pharo-9.0-informational)](https://pharo.org)

Quick links

- [**Explore the docs**](docs/)
- [Report a defect](https://github.com/ba-st/Launchpad/issues/new?labels=Type%3A+Defect)
- [Request a feature](https://github.com/ba-st/Launchpad/issues/new?labels=Type%3A+Feature)

Useful when you want to start up your image from the command line, using
parameters, this provides a framework to use: mandatory and optional arguments,
logging and error handling.

If an error stops the application, it dumps a fuel file with `thisContext`
allowing you to debug the error later. More details about this in the [documentation](docs/Debugging.md)

## License

- The code is licensed under [MIT](LICENSE).
- The documentation is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/).

## Installation

To load the project in a Pharo image, or declare it as a dependency of your own
project follow this [instructions](docs/Installation.md).

## Contributing

Check the [Contribution Guidelines](CONTRIBUTING.md)

---

> *Icons by [Icons8](https://icons8.com/icon/63775/launchpad)*
