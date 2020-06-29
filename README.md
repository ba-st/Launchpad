<p align="center"><img src="assets/logos/128x128.png">
 <h1 align="center">Launchpad</h1>
  <p align="center">
    Command Line Handler meant to be used as superclass for an application entry point.
    <br>
    <a href="docs/"><strong>Explore the docs »</strong></a>
    <br>
    <br>
    <a href="https://github.com/ba-st/Launchpad/issues/new?labels=Type%3A+Defect">Report a defect</a>
    |
    <a href="https://github.com/ba-st/Launchpad/issues/new?labels=Type%3A+Feature">Request feature</a>
  </p>
</p>

[![GitHub release](https://img.shields.io/github/release/ba-st/Launchpad.svg)](https://github.com/ba-st/Launchpad/releases/latest)
[![Build Status](https://github.com/ba-st/Launchpad/workflows/Build/badge.svg?branch=release-candidate)](https://github.com/ba-st/Launchpad/actions?query=workflow%3ABuild)
[![Coverage Status](https://codecov.io/github/ba-st/Launchpad/coverage.svg?branch=release-candidate)](https://codecov.io/gh/ba-st/Launchpad/branch/release-candidate)
[![Pharo 7.0](https://img.shields.io/badge/Pharo-7.0-informational)](https://pharo.org)
[![Pharo 8.0](https://img.shields.io/badge/Pharo-8.0-informational)](https://pharo.org)

Useful when you want to start up your image from the command line, using parameters, this provides a framework to use: mandatory and optional arguments, logging and error handling.

If an error stops the application, it dumps a fuel file with `thisContext` allowing you to debug the error later. More details about this in the [documentation](docs/Debugging.md)

## License

- The code is licensed under [MIT](LICENSE).
- The documentation is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/).

## Quick Start

- Download the latest [Pharo 32](https://get.pharo.org/) or [64 bits VM](https://get.pharo.org/64/).
- Load the project using Metacello using the script in [Basic Installation](docs/Installation.md#basic-installation)
- Explore the [documentation](docs/), starting with [How To](docs/HowTo.md) is recommended.

## Installation

To load the project in a Pharo image, or declare it as a dependency of your own project follow this [instructions](docs/Installation.md).

## Contributing

Check the [Contribution Guidelines](CONTRIBUTING.md)

---
<small><a href="https://icons8.com/icon/63775/launchpad">Launchpad icon by Icons8</a></small>
