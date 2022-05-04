# Launchpad Documentation

Launchpad provides a command-line interface to start, list, and explain the
applications available within the image, including:

- Configuration parameters (mandatory, optional, and sensitive)
- Command-line arguments, environment variables, or settings file configuration providers.
- Logging infrastructure (based on `Beacon`)
- Inline help
- Textual and binary stack trace generation

To learn about the project, [install it](how-to/how-to-load-in-pharo.md) and
follow the [beginners tutorial](tutorial/Hello-world.md).

Once you grasped the basics, lookup for details in the reference docs:

- [Command-line interface](reference/CLI.md)
- [Configuration](reference/Configuration.md)
- [Logging](reference/Logging.md)
- [Tracing](reference/Tracing.md)
- [Docker support](reference/Docker.md)

or expand your understanding over specific topics:

- [What happens when debugging mode is enabled?](explanation/Debugging-mode.md)
- [How is obtained the value of a configuration parameter?](explanation/Configuration-resolution.md)
- [What happens when an application is started?](explanation/Application-start-up.md)

---

To use the project as a dependency of your project, take a look at:

- [How to use Launchpad as a dependency](how-to/how-to-use-as-dependency-in-pharo.md)
- [Baseline groups reference](reference/Baseline-groups.md)
