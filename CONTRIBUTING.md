# Contributing

There are several ways to contribute to the project: reporting bugs, sending
feedback, proposing ideas for new features, fixing or adding documentation,
promoting the project, or even contributing code.

## Reporting issues

You can [report issues here](https://github.com/ba-st/Launchpad/issues/new)

## Contributing Code

- This project is MIT licensed, so any code contribution MUST be under the same license.
- This project uses [Semantic Versioning](http://semver.org/), so keep it in
  mind when you make backwards-incompatible changes. If some backwards
  incompatible change is made the major version MUST be increased.
- The source code is hosted in this repository using the Tonel format in the
  `source` folder.
- The `release-candidate` branch contains the latest changes and should always
  be in a releasable state.
- Feel free to send pull requests or fork the project.
- Code contributions without test cases have a lower probability of being merged
  into the main branch.

1. [Load the project code in a Pharo image](docs/how-to/how-to-load-in-pharo.md)
2. Create a new branch to host your code changes
3. Do the changes
4. Run the test cases
5. Commit and push your changes to the branch using the Iceberg UI. You may need
  to add your fork if lacking the required permissions to push to the main repo.
6. Create a Pull Request against the `release-candidate` branch

## Branching and Releases

The `release-candidate` branch is the production branch. All changes must reach it through a pull request — direct pushes are not allowed.

### Feature Branch Naming

Branches must follow the pattern `{category}/{issue-id}-{slug}`, where:

- **category** is one of: `feature`, `bugfix`, `docs`, `chore`, `refactor`
- **issue-id** is the GitHub issue number
- **slug** is a short description in kebab-case

Examples: `feature/1234-user-login`, `bugfix/5678-fix-null-pointer`, `docs/91011-update-readme`

### Commit Messages

Commit messages must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```text
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

The **type** maps directly to the branch category:

| Branch category | Commit type |
| --- | --- |
| `feature` | `feat` |
| `bugfix` | `fix` |
| `docs` | `docs` |
| `chore` | `chore` |
| `refactor` | `refactor` |

The **scope** is optional and should name the area of the codebase affected (e.g. `auth`, `api`, `ci`).

The **description** is a short, imperative-mood summary written in lowercase.

Examples:

```text
feat(auth): add OAuth2 login support
fix(api): handle null response from payment gateway
docs(contributing): add commit message conventions
chore(ci): update markdownlint action to v1
refactor(orders): extract price calculation into service
```

Breaking changes must be indicated by appending `!` after the type/scope, or by adding a `BREAKING CHANGE:` footer in the commit body:

```text
feat(api)!: remove deprecated v1 endpoints
```

#### AI-assisted commits

When any part of the code or content in a commit was produced with the help of an AI tool, a `Co-authored-by` footer must be added to attribute it. Use the tool name and its canonical no-reply address:

| AI tool | Footer |
| --- | --- |
| Claude (Anthropic) | `Co-authored-by: Claude <noreply@anthropic.com>` |
| GitHub Copilot | `Co-authored-by: GitHub Copilot <copilot@github.com>` |
| ChatGPT (OpenAI) | `Co-authored-by: ChatGPT <noreply@openai.com>` |

Example:

```text
docs(contributing): add commit message conventions

Co-authored-by: Claude <noreply@anthropic.com>
```

### Pull Request Requirements

- At least one team member must review and approve the PR before it can be merged.
- PRs must be merged using the **squash** strategy to keep the branch history clean and linear.

## Documentation

Documentation lives in the `docs/` folder, licensed under CC BY-SA 4.0., and organized by content type:

| Folder | Purpose |
| --- | --- |
| `docs/how-to/` | Step-by-step guides for accomplishing specific tasks |
| `docs/reference/` | Reference material (APIs, configuration options, etc.) |
| `docs/tutorials/` | Learning-oriented walkthroughs for newcomers |
| `docs/explanations/` | Clarifications and in-depth discussions of concepts |
